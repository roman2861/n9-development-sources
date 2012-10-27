// *************************************************** //
// Header Component
//
// The header component is used by the application pages.
// It displays a rectangle with a given background image
// and text.
// *************************************************** //

import QtQuick 1.1

import "js/globals.js" as Globals

Rectangle {
    id: header

    // text property for the header
    // set text will be shown in the header
    property alias text : headerText.text

    // image property for the header
    // given image will be shown (640x80)
    property alias source : headerImage.source

    // property if reload button is visible
    property alias reloadButtonVisible : headerReloadButton.visible

    // signal if the reload button has been pressed
    signal reloadButtonClicked()

    // place it on top
    anchors {
        top: parent.top;
        left: parent.left;
        right: parent.right
    }

    // full width, height is 80 px
    width: parent.width;
    height: 80


    // image element that holds the image property
    Image {
        id: headerImage
        source: "img/top_header.png"
    }


    // text element that holds the text property
    Text {
        id: headerText

        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.pixelSize: 30
        font.family: "Nokia Pure Text Light"
        color: "white"

        text: ""
    }


    // Reload button top right in the header
    Image {
        id: headerReloadButton

        anchors {
            right: parent.right
            rightMargin: 30
            top: parent.top
            topMargin: 20
            bottom: parent.bottom
            bottomMargin: 20
        }

        width: 40
        z: 10

        visible: false

        source: "image://theme/icon-m-toolbar-refresh-white"


        MouseArea {
            anchors.fill: parent

            onCanceled:
            {
                headerReloadButton.source = "image://theme/icon-m-toolbar-refresh-white"
            }

            onPressed:
            {
                headerReloadButton.source = "image://theme/icon-m-toolbar-refresh-selected"
            }

            onReleased:
            {
                headerReloadButton.source = "image://theme/icon-m-toolbar-refresh-white"
                reloadButtonClicked();
            }
        }
    }
}
