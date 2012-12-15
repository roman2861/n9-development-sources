#include <QtGui/QApplication>
#include <QtDeclarative>

#include "qmlapplicationviewer.h"
#include "sharehelper.h"
#include "networkhelper.h"


Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    // make share helper features available in qml
    qmlRegisterType<ShareHelper>("QtShareHelper", 1, 0, "ShareHelper");

    // make network helper features available in qml
    qmlRegisterType<NetworkHelper>("QtNetworkHelper", 1, 0, "NetworkHelper");

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/instago/main.qml"));
    viewer.showExpanded();

    return app->exec();
}
