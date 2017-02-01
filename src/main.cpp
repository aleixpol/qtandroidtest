#include <QGuiApplication>
#include <QQmlApplicationEngine>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine(QUrl("qrc:/qml/main.qml"));
    return app.exec();
}
