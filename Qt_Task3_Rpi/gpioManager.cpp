#include "gpioManager.h"
#include <QFile>
#include <QDebug>

GPIOManager::GPIOManager(QObject *parent)
    : QObject(parent),
    m_speed(0),
    m_leftLedActive(false),
    m_rightLedActive(false),
    m_leftLedState(false),
    m_rightLedState(false)
{
    initGPIO();

    // Setup timers
    m_buttonPollTimer = new QTimer(this);
    connect(m_buttonPollTimer, &QTimer::timeout, this, &GPIOManager::pollButtons);
    m_buttonPollTimer->start(50); // Poll every 50ms

    m_leftLedTimer = new QTimer(this);
    connect(m_leftLedTimer, &QTimer::timeout, this, &GPIOManager::updateLeftLED);

    m_rightLedTimer = new QTimer(this);
    connect(m_rightLedTimer, &QTimer::timeout, this, &GPIOManager::updateRightLED);
}

void GPIOManager::initGPIO()
{
    // Export GPIO pins
    writeGPIO("/sys/class/gpio/export", QString::number(m_leftLedPin));
    writeGPIO("/sys/class/gpio/export", QString::number(m_rightLedPin));
    writeGPIO("/sys/class/gpio/export", QString::number(m_speedUpPin));
    writeGPIO("/sys/class/gpio/export", QString::number(m_speedDownPin));

    // Set directions
    writeGPIO(QString("/sys/class/gpio/gpio%1/direction").arg(m_leftLedPin), "out");
    writeGPIO(QString("/sys/class/gpio/gpio%1/direction").arg(m_rightLedPin), "out");
    writeGPIO(QString("/sys/class/gpio/gpio%1/direction").arg(m_speedUpPin), "in");
    writeGPIO(QString("/sys/class/gpio/gpio%1/direction").arg(m_speedDownPin), "in");
}

void GPIOManager::toggleLeftLED()
{
    m_leftLedActive = !m_leftLedActive;
    if(m_leftLedActive) {
        m_leftLedTimer->start(500); // Blink every 500ms
    } else {
        m_leftLedTimer->stop();
        writeGPIO(QString("/sys/class/gpio/gpio%1/value").arg(m_leftLedPin), "0");
    }
    emit leftLedChanged();
}

void GPIOManager::toggleRightLED()
{
    m_rightLedActive = !m_rightLedActive;
    if(m_rightLedActive) {
        m_rightLedTimer->start(500); // Blink every 500ms
    } else {
        m_rightLedTimer->stop();
        writeGPIO(QString("/sys/class/gpio/gpio%1/value").arg(m_rightLedPin), "0");
    }
    emit rightLedChanged();
}

void GPIOManager::updateLeftLED()
{
    m_leftLedState = !m_leftLedState;
    writeGPIO(QString("/sys/class/gpio/gpio%1/value").arg(m_leftLedPin),
              m_leftLedState ? "1" : "0");
}

void GPIOManager::updateRightLED()
{
    m_rightLedState = !m_rightLedState;
    writeGPIO(QString("/sys/class/gpio/gpio%1/value").arg(m_rightLedPin),
              m_rightLedState ? "1" : "0");
}

void GPIOManager::pollButtons()
{
    static bool lastUpState = false;
    static bool lastDownState = false;

    bool upPressed = readGPIO(QString("/sys/class/gpio/gpio%1/value").arg(m_speedUpPin)) == "0";
    bool downPressed = readGPIO(QString("/sys/class/gpio/gpio%1/value").arg(m_speedDownPin)) == "0";

    if(upPressed && !lastUpState) setSpeed(qMin(m_speed + 10, 240.0));
    if(downPressed && !lastDownState) setSpeed(qMax(m_speed - 10, 0.0));

    lastUpState = upPressed;
    lastDownState = downPressed;
}

void GPIOManager::resetSpeed()
{
    setSpeed(0);
}

// Helper functions
void GPIOManager::writeGPIO(const QString &path, const QString &value)
{
    QFile file(path);
    if(file.open(QIODevice::WriteOnly)) {
        file.write(value.toUtf8());
        file.close();
    }
}

QString GPIOManager::readGPIO(const QString &path)
{
    QFile file(path);
    if(file.open(QIODevice::ReadOnly)) {
        return file.readAll().trimmed();
    }
    return "";
}

// Property getters
double GPIOManager::speed() const { return m_speed; }
bool GPIOManager::leftLedActive() const { return m_leftLedActive; }
bool GPIOManager::rightLedActive() const { return m_rightLedActive; }

void GPIOManager::setSpeed(double newSpeed)
{
    if (qFuzzyCompare(m_speed, newSpeed))
        return;
    m_speed = newSpeed;
    emit speedChanged();
}

GPIOManager::~GPIOManager()
{
    // Cleanup GPIO
    writeGPIO("/sys/class/gpio/unexport", QString::number(m_leftLedPin));
    writeGPIO("/sys/class/gpio/unexport", QString::number(m_rightLedPin));
    writeGPIO("/sys/class/gpio/unexport", QString::number(m_speedUpPin));
    writeGPIO("/sys/class/gpio/unexport", QString::number(m_speedDownPin));

    // Stop timers
    if(m_buttonPollTimer && m_buttonPollTimer->isActive()) {
        m_buttonPollTimer->stop();
    }
    if(m_leftLedTimer && m_leftLedTimer->isActive()) {
        m_leftLedTimer->stop();
    }
    if(m_rightLedTimer && m_rightLedTimer->isActive()) {
        m_rightLedTimer->stop();
    }
}
