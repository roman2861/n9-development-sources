import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

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


    // toolbar for the popular photos
    ToolBarLayout {
        id: mainNavigationToolbar
        visible: false

        // jump to the user stream
        ToolIcon {
            id: iconHome
            iconId: "toolbar-home"
            visible: false
            onClicked: {
                pageStack.replace(Qt.resolvedUrl("UserFeedPage.qml"))
            }
        }


        // jump to the popular photo stream
        ToolIcon {
            id: iconPopular
            iconId: "toolbar-all-content-dimmed-white"
            visible: false

            onClicked: {
                pageStack.replace(Qt.resolvedUrl("PopularPhotosPage.qml"))
            }
        }


        // this is an "empty" icon slot
        // it's visible when the user is logged out thus keeping the user profile icon right
        // will throw an error on runtime: QML QDeclarativeImage_QML_36: Failed to get image from provider: image://theme/icon-m-
        ToolIcon {
            id: iconNone
        }


        // jump to the profile page of the current user
        ToolIcon {
            id: iconProfile
            iconId: "toolbar-contact";
            onClicked: {
                pageStack.push(Qt.resolvedUrl("UserProfilePage.qml"))
            }
        }
    }
}
