// *************************************************** //
// Network Error Message Component
//
// Generic error message that something went wrong
// with loading Instagram data
// notification rectangle with text.
// This is most likely the case when the network went
// away.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.1

Rectangle  {
    id: networkErrorMessage

    // signal to indicate tap on message
    signal messageTap();

    anchors.fill: parent

    // no background color
    color: "transparent"


    // error message headline
    Text {
        id : networkErrorMessageHeadline

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: networkErrorMessageText.top
            bottomMargin: 20
        }

        width: 400
        visible: true

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 25
        wrapMode: Text.WordWrap

        text: "Can't load data from Instagram";
    }


    // actual error message text
    Text {
        id : networkErrorMessageText

        anchors {
            centerIn: parent
        }

        width: 400
        visible: true

        font.family: "Nokia Pure Text"
        font.pixelSize: 20

        wrapMode: Text.WordWrap
        textFormat: Text.RichText

        text: "Please check your network connection and tap to try again.";
    }


    // the error text is a tap area that calls the reload function
    MouseArea {
        anchors.fill: parent

        onClicked:
        {
            messageTap();
        }
    }
}
