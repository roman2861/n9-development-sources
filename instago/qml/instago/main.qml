import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow

    initialPage: mainPage    

    MainPage {
        id: mainPage
    }

    Component.onCompleted: {
        theme.inverted = true;
    }

    ToolBarLayout {
        id: homeToolbar
        visible: true
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    ToolBarLayout {
        id: overviewToolbar
        visible: false
        ToolIcon {
            iconId: "toolbar-home";
            onClicked: {
                myMenu.close();
                pageStack.pop();
            }
        }
        ToolIcon {
            iconId: "toolbar-refresh";
            onClicked: {
            }
        }

    }


    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: qsTr("Popular Photos"); onClicked: { pageStack.push(Qt.resolvedUrl("PopularPhotosPage.qml")) } }
        }
    }
}
