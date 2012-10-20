// *************************************************** //
// Forced Logout Page
//
// This page is shown when Instagram invalidated the
// user token for some reason.
// This can either happen based on user input (removed
// application rights) or based on Instagram itself
// (deleted user).
// If that happens, the user is logged out automatically
// and all his cached userdata cleared.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.0

import "js/authenticationhandler.js" as Authentication

Page {
    // use the forced logout view toolbar
//    tools: forcedLogoutToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // clear the cached user data
    Component.onCompleted: {
        Authentication.auth.deleteStoredInstagramData();
    }

    // standard header for the current page
    Header {
        id: pageHeader
        source: "img/top_header_logo.png"
    }


    // headline for the forced logout page
    Text {
        id : forcedLogoutHeadline

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: forcedLogoutMaintext.top
            bottomMargin: 20
        }

        width: 400
        visible: true

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 25
        wrapMode: Text.WordWrap

        text: "You have been logged out";
    }


    // description for the forced logout page
    Text {
        id : forcedLogoutMaintext

        anchors {
            centerIn: parent
        }

        width: 400
        visible: true

        font.family: "Nokia Pure Text"
        font.pixelSize: 20

        wrapMode: Text.WordWrap
        textFormat: Text.RichText

        text: "Your Instagram session is not valid anymore. This can happen if you or Instagram revoked the application access or changed your user information.<br /><br />You can authenticate again once you restart the application.";
    }
}
