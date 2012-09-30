#include "sharehelper.h"
#include <QImage>

// sharehelper.cpp is based on the PhotoMosaic App
// See: http://www.developer.nokia.com/Community/Wiki/Photomosaic_App_with_Qt

// PhotoMosaic in turn based on the butaca project
// See: http://projects.developer.nokia.com/butaca/

// The article "How to Use the Harmattan’s ShareUI Framework in Qml" on linux4us.org was also helpful
// See: http://blog.linux4us.org/2012/06/14/how-to-use-the-harmattans-shareui-framework-qml/

#include <QDeclarativeContext>

#ifndef QT_SIMULATOR
#include <maemo-meegotouch-interfaces/shareuiinterface.h>
#include <MDataUri>
#endif

ShareHelper::ShareHelper(QObject *parent) :
    QObject(parent)
{
}


// shares a URL with the share-ui interface
void ShareHelper::shareURL(QString title, QString description, QString url)
{
#ifndef QT_SIMULATOR
    MDataUri dataUri;

    dataUri.setMimeType("text/x-url");
    dataUri.setTextData(url);

    dataUri.setAttribute("title", title);
    dataUri.setAttribute("description", description);

    // qDebug() << dataUri.toString();

    QStringList items;
    items << dataUri.toString();
    ShareUiInterface shareIf("com.nokia.ShareUi");
    if (shareIf.isValid()) {
        shareIf.share(items);
    } else {
        qCritical() << "Invalid interface";
    }
#else
    Q_UNUSED(title)
    Q_UNUSED(url)
#endif
}


// shares an image with the share-ui interface
void ShareHelper::shareImage(QString title, QString description, QString url)
{
#ifndef QT_SIMULATOR
    MDataUri dataUri;

    QImage image;
    image.load(url);
    QByteArray body;
    QBuffer buffer(&body);
    buffer.open(QIODevice::WriteOnly);
    image.save(&buffer, "JPG");

    dataUri.setMimeType("image/jpeg");
    dataUri.setBinaryData(body);

    dataUri.setAttribute("title", title);
    dataUri.setAttribute("description", description);

    qDebug() << dataUri.toString();

    QStringList items;
    items << dataUri.toString();
    ShareUiInterface shareIf("com.nokia.ShareUi");
    if (shareIf.isValid()) {
        shareIf.share(items);
    } else {
        qCritical() << "Invalid interface";
    }
#else
    Q_UNUSED(title)
    Q_UNUSED(url)
#endif
}

