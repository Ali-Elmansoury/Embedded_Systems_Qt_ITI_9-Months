#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "gpioManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Create GPIO manager on the heap with parent
    GPIOManager *gpioManager = new GPIOManager(&app);

    QQmlApplicationEngine engine;

    // Properly expose the GPIO manager
    engine.rootContext()->setContextProperty("gpioManager", gpioManager);

    engine.loadFromModule("Qt_Task3_Rpi", "Main");

    if (engine.rootObjects().isEmpty()) {
        delete gpioManager;
        return -1;
    }

    return app.exec();
}
