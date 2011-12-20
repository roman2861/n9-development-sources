#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include "httpuploader.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    qmlRegisterUncreatableType<HttpPostField>("HttpUp", 1, 0, "HttpPostField", "Can't touch this");
    qmlRegisterType<HttpPostFieldValue>("HttpUp", 1, 0, "HttpPostFieldValue");
    qmlRegisterType<HttpPostFieldFile>("HttpUp", 1, 0, "HttpPostFieldFile");
    qmlRegisterType<HttpUploader>("HttpUp", 1, 0, "HttpUploader");

    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QScopedPointer<QmlApplicationViewer> viewer(QmlApplicationViewer::create());

    viewer->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer->setMainQmlFile(QLatin1String("qml/enqry/main.qml"));
    viewer->showExpanded();

    return app->exec();
}
