// *************************************************** //
// User Profile Page
//
// The user profile page shows the personal information
// of the currently logged in user.
// If the user is not logged in, then a link to the
// login process is shown.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.0

import "js/authentication.js" as Authentication

Page {
    // use the detail view toolbar
    tools: profileToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // check if the user is already logged in
    Component.onCompleted: {
        var userdata = new Array();

        // get the userdata from the persistent database
        // if data is available the user already has a token
        userdata = Authentication.getStoredInstagramToken();

        if (userdata.length > 0)
        {
            // user already has a token
            console.log("User already has a stored token");
        }
        else
        {
            // user does not have a token
            console.log("User does not have a stored token yet");

            userprofileNoTokenContainer.visible = true;
        }
    }

    // standard header for the current page
    Header {
        id: pageHeader
        source: "img/top_header.png"
        text: qsTr("You")
    }


    Rectangle {
        id: userprofileNoTokenContainer

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false;

        // no background color
        color: "transparent"


        // headline
        Text {
            id : userprofileNoTokenHeadline

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: userprofileNoTokenText.top
                bottomMargin: 20
            }

            width: 400

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.WordWrap

            text: "Please log in";
        }


        // description
        Text {
            id : userprofileNoTokenText

            anchors {
                centerIn: parent
            }

            width: 400

            font.family: "Nokia Pure Text"
            font.pixelSize: 20

            wrapMode: Text.WordWrap
            textFormat: Text.RichText

            text: "You are currently not logged in and can only use the public features of Instagram.<br /><br />Please log in to use features that need authntication as well, like your news stream, following users and liking photos.";
        }


        // login button
        Button {
            id: userprofileNoTokenLogin

            anchors {
                left: parent.left;
                leftMargin: 30;
                right: parent.right;
                rightMargin: 30;
                top: userprofileNoTokenText.bottom;
                topMargin: 20;
            }

            text: "Login"

            onClicked: {
                pageStack.push(Qt.resolvedUrl("LoginPage.qml"))
            }
        }
    }


    // toolbar for the detail page
    ToolBarLayout {
        id: profileToolbar
        visible: false

        // jump back to the popular photos page
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }

        // jump to the about page
        ToolIcon {
            iconId: "toolbar-settings";
            onClicked: {
                pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
    }
}
