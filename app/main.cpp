
#include <QByteArray>
#include <QDebug>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QUrl>

#ifndef QML_IMPORT_PATH
#define QML_IMPORT_PATH
#endif

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Set QML import path
    const char *qmlImportPath = std::getenv("QML_IMPORT_PATH");
    if (qmlImportPath) {
        qputenv("QML_IMPORT_PATH", QByteArray(qmlImportPath));
        qDebug() << "QML_IMPORT_PATH:" << qgetenv("QML_IMPORT_PATH");
    } else {
        qDebug() << "QML_IMPORT_PATH is not set";
        qputenv("QML_IMPORT_PATH", QByteArray(QML_IMPORT_PATH));
    }

    qDebug() << "QML_IMPORT_PATH:" << qgetenv("QML_IMPORT_PATH") << "," << std::getenv("QML_IMPORT_PATH") << ".";

    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/main.qml"));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
