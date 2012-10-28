// *************************************************** //
// Search Page
//
// This page provides search and displays the results.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1

import "js/globals.js" as Globals
import "js/search.js" as SearchScript

Page {
    // use the detail view toolbar
    tools: mainNavigationToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    Component.onCompleted: {
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: "Search"
    }

    // standard notification area
    NotificationArea {
        id: notification

        visibilitytime: 1500

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }


    // search entry field
    TextField {
        id: searchInput

        anchors {
            top: pageHeader.bottom;
            topMargin: 15;
            left: parent.left;
            leftMargin: 10;
            right: parent.right;
            rightMargin: 10;
        }

        onAccepted: {
            // console.log("Input received: " + searchInput.text);

            if (searchUserButton.checked)
            {
                SearchScript.searchUser(searchInput.text);
            }
            else
            {
                SearchScript.loadHashtagImages(searchInput.text, 0);
            }

            searchInput.platformCloseSoftwareInputPanel();
        }

        placeholderText: "Enter user name"
        text: ""
    }


    // user search button
    Button {
        id: searchUserButton

        anchors {
            top: searchInput.bottom;
            topMargin: 15;
            left: parent.left;
            leftMargin: 13;
        }

        width: 220

        checkable: false
        checked: true

        onClicked: {
            searchUserButton.checked = true;
            searchHashtagButton.checked = false;
            searchInput.placeholderText = "Enter user name"
        }

        text: "Search user"
    }


    // hastags search button
    Button {
        id: searchHashtagButton

        anchors {
            top: searchInput.bottom;
            topMargin: 15;
            left: searchUserButton.right;
            leftMargin: 15;
        }

        width: 220

        checkable: false
        checked: false

        onClicked: {
            searchUserButton.checked = false;
            searchHashtagButton.checked = true;
            searchInput.placeholderText = "Enter hashtag"
        }

        text: "Search hashtag"
    }


    // list of search results for user search
    // container is only visible if user search has completed
    UserList {
        id: searchUserResults;

        anchors {
            top: searchUserButton.bottom
            topMargin: 10;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false
    }


    // list of search results for hashtag search
    // container is only visible if hashtag search has completed
    ImageGallery {
        id: imageGallery;

        anchors {
            top: searchUserButton.bottom
            topMargin: 10;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onItemClicked: {
            // console.log("Image tapped: " + imageId);
            pageStack.push(Qt.resolvedUrl("ImageDetailPage.qml"), {imageId: imageId});
        }

        onListBottomReached: {
            if (paginationNextMaxId !== "")
            {
                SearchScript.loadHashtagImages(searchInput.text, paginationNextMaxId);
            }
        }
    }


    // text shown if search results have been found
    Text {
        id: searchNoResultsFound

        anchors.centerIn: parent

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 45
        wrapMode: Text.Wrap
        color: "darkgray"
        horizontalAlignment: Text.AlignHCenter

        visible: false;

        text: "Can't find<br />search results"
    }


    // show the loading indicator as long as the page is not ready
    BusyIndicator {
        id: loadingIndicator

        anchors.centerIn: parent
        platformStyle: BusyIndicatorStyle { size: "large" }

        running:  false
        visible: false
    }


    // error indicator that is shown when a network error occured
    ErrorMessage {
        id: errorMessage

        anchors {
            top: pageHeader.bottom;
            topMargin: 3;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onVisibleChanged: {
/*
            if (visible == false)
            {
                searchInput.visible = false;
                searchHashtagButton.visible = false;
                searchUserButton.visible = false;
            }
*/
        }

        onErrorMessageClicked: {
            // console.log("Refresh clicked")
            // searchInput.visible = true;
            // searchHashtagButton.visible = true;
            // searchUserButton.visible = true;
            errorMessage.visible = false;
        }
    }
}
