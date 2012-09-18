import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

    // property string test: "test.png"

    // initial page is the gallery of popular photos
    initialPage: splashScreenPage

    // register the popular photo page
    PopularPhotosPage {
        id: popularPhotosPage
    }

    // register the popular photo page
    SplashScreenPage {
        id: splashScreenPage
    }
}
