#ifndef GPIOMANAGER_H
#define GPIOMANAGER_H

#include <QObject>
#include <QTimer>

class GPIOManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(bool leftLedActive READ leftLedActive NOTIFY leftLedChanged)
    Q_PROPERTY(bool rightLedActive READ rightLedActive NOTIFY rightLedChanged)

public:
    explicit GPIOManager(QObject *parent = nullptr);
    virtual ~GPIOManager() Q_DECL_OVERRIDE;  // Changed here
    Q_INVOKABLE void toggleLeftLED();
    Q_INVOKABLE void toggleRightLED();
    Q_INVOKABLE void resetSpeed();

    double speed() const;
    bool leftLedActive() const;
    bool rightLedActive() const;

public slots:
    void setSpeed(double newSpeed);

signals:
    void speedChanged();
    void leftLedChanged();
    void rightLedChanged();

private slots:
    void pollButtons();
    void updateLeftLED();
    void updateRightLED();

private:
    void initGPIO();
    void writeGPIO(const QString &path, const QString &value);
    QString readGPIO(const QString &path);

    QTimer *m_buttonPollTimer;
    QTimer *m_leftLedTimer;
    QTimer *m_rightLedTimer;

    double m_speed;
    bool m_leftLedActive;
    bool m_rightLedActive;
    bool m_leftLedState;
    bool m_rightLedState;

    // GPIO Pins (adjust according to your wiring)
    const int m_speedUpPin = 529;
    const int m_speedDownPin = 539;
    const int m_leftLedPin = 534;
    const int m_rightLedPin = 535;
};

#endif // GPIOMANAGER_H
