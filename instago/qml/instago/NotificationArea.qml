// *************************************************** //
// Notification Area Component
//
// The notification component shows a simple
// notification rectangle with text.
// It's similar to the QML InfoBanner component but
// has more control over color and animation.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1

Rectangle {
    id: notificationArea

    // actual notification text
    property alias text: notificationText.text

    // fade time for fade in and out
    property int fadeTime: 100

    // colors and background of the notification area
    property alias backgroundColor: notificationArea.color
    property alias textColor: notificationText.color
    property alias backgroundImage: notificationImage.source

    // time the notification is shown in ms
    property alias visibilityTime: notificationTimer.interval

    // signal to show the notification
    signal show();
    onShow: {
        notificationInAnimation.start();
        notificationInOpacity.start()
        notificationArea.visible = true;
        notificationTimer.running = true;
    }

    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.right: parent.right
    anchors.rightMargin: 5

    height: 70

    color: "black"

    visible: false
    z: 100

    border.color: "transparent"
    radius: 10


    // background image
    Image {
        id: notificationImage
        source:  ""

        anchors.fill: parent
    }


    // notification text
    Text {
        id: notificationText
        text: ""

        anchors {
            left: parent.left;
            leftMargin: 10;
            right: parent.right;
            rightMargin: 10;
            verticalCenter: parent.verticalCenter;
        }

        font.family: "Nokia Pure Text"
        font.pixelSize: 24

        wrapMode: Text.WordWrap
        textFormat: Text.RichText

        color: "white"
    }


    // slide in animation
    PropertyAnimation {
        id: notificationInAnimation;
        target: notificationArea;
        property: "height";
        from: 0;
        to: 80;
        duration: notificationArea.fadeTime
    }


    // fade in animation
    NumberAnimation {
        id: notificationInOpacity
        target: notificationArea
        properties: "opacity"
        from: 0
        to: 0.9
        duration: notificationArea.fadeTime
    }


    // slide out animation
    PropertyAnimation {
        id: notificationOutAnimation;
        target: notificationArea;
        property: "height";
        from: 80;
        to: 0;
        duration: notificationArea.fadeTime
    }


    // fade out animation
    NumberAnimation {
        id: notificationOutOpacity
        target: notificationArea
        properties: "opacity"
        from: 0.9
        to: 0
        duration: notificationArea.fadeTime

        onCompleted: {
            notificationArea.visible = false;
        }
    }


    // notification timer
    Timer {
        id: notificationTimer
        interval: 1000
        running: false
        repeat:  false

        onTriggered: {
            notificationOutAnimation.start();
            notificationOutOpacity.start();
        }
    }
}

