import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    // use the detail view toolbar
    tools: aboutToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // standard header for the current page
    Header {
        id: pageHeader
        source: "img/top_header_logo.png"
        text: qsTr("")
    }

    Text {
        id : aboutHeadline
        visible: true

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: aboutMaintext.top
            bottomMargin: 20
        }

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 25

        width: 400
        wrapMode: Text.WordWrap

        text: "Instago";
    }


    Text {
        id : aboutMaintext
        visible: true

        anchors {
            centerIn: parent
        }

        font.family: "Nokia Pure Text"
        font.pixelSize: 20

        width: 400
        wrapMode: Text.WordWrap
        textFormat: Text.RichText

        text: "An Instagram client for MeeGo. Browse popular photos, look at your friends images and find new people.<br /><br />A sideproject by Dirk Songür (dirk@songuer.de).<br /><br />Version 0.0.2";
    }


    // toolbar for the detail page
    ToolBarLayout {
        id: aboutToolbar
        visible: false
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
    }
}
