// *************************************************** //
// User Bio Component
//
// The user bio component is used by the application
// pages. It displays the user bio (text) as well as
// provides the interaction with a user (un- / follow).
// *************************************************** //

import QtQuick 1.0
import com.nokia.meego 1.1
import com.nokia.extras 1.1

import "js/globals.js" as Globals
import "js/authenticationhandler.js" as Authentication

Rectangle {
    id: userBio

    // define content properties to make the data fields accessible
    property alias text: userBioText.text;
    property alias followButtonVisible: userBioFollowUser.visible
    property alias unfollowButtonVisible: userBioUnfollowUser.visible
    property alias logoutButtonVisible: userBioLogoutUser.visible

    // define signals to make the interactions accessible
    signal followButtonClicked();
    signal unfollowButtonClicked();
    signal logoutButtonClicked();

    // no background color
    color: "transparent"

    // bio of the user
    Text {
        id: userBioText

        anchors {
            top: parent.top
            topMargin: 10
            left: parent.left
            leftMargin: 10
            right: parent.right;
            rightMargin: 10
        }

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 25
        wrapMode: Text.Wrap

        text: ""
    }


    // follow button
    Button {
        id: userBioFollowUser

        anchors {
            left: parent.left;
            leftMargin: 30;
            right: parent.right;
            rightMargin: 30;
            top: userBioText.bottom;
            topMargin: 30;
        }

        visible: false
        text: "Follow"

        onClicked: {
            followButtonClicked();
        }
    }


    // unfollow button
    Button {
        id: userBioUnfollowUser

        anchors {
            left: parent.left;
            leftMargin: 30;
            right: parent.right;
            rightMargin: 30;
            top: userBioText.bottom;
            topMargin: 30;
        }

        visible: false
        text: "Unfollow"

        onClicked: {
            unfollowButtonClicked();
        }
    }


    // logout button
    Button {
        id: userBioLogoutUser

        anchors {
            left: parent.left;
            leftMargin: 30;
            right: parent.right;
            rightMargin: 30;
            top: userBioText.bottom;
            topMargin: 30;
        }

        visible: false
        text: "Logout"

        onClicked: {
            logoutButtonClicked();
        }
    }
}
