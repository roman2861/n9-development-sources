import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

    // use the inverted theme instead of the white one
    Component.onCompleted: {
        theme.inverted = true;
    }

    // initial page is the gallery of popular photos
    initialPage: popularPhotosPage

    // register the popular photo page
    PopularPhotosPage {
        id: popularPhotosPage
    }

}
