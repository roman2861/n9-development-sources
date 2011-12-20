import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow
    initialPage: mainPage


    MainPage {
        id: mainPage
    }


    AboutPage {
        id: aboutPage
    }


    UploadPage {
        id: uploadPage
    }


    ToolBarLayout {
        id: commonTools
        visible: true

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }


    Menu {
        id: myMenu
        visualParent: pageStack

        MenuLayout {
            MenuItem {
                text: qsTr("About")
                onClicked: { pageStack.push(Qt.resolvedUrl("AboutPage.qml")) }
            }
        }
    }


    ToolBarLayout {
            id: backTools
            visible: false

            ToolIcon {
                iconId: "toolbar-back"; onClicked: { pageStack.pop(); }
            }
    }
}
