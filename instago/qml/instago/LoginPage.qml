// *************************************************** //
// Login Page
//
// The login page shows the Instagram login page in
// a web view.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.0
import QtWebKit 1.0

import "js/instagramkeys.js" as InstagramKeys
import "js/authentication.js" as Authentication

Page {
    // use the login view toolbar
    tools: loginToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // standard header for the current page
    Header {
        id: pageHeader
        source: "img/top_header.png"
        text: qsTr("Login")
    }


    // browser window showing the Instagram authentication process
    WebView {
        id: loginInstagramWebView

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        preferredWidth: parent.width
        preferredHeight: parent.height

        smooth: true
        focus: true
        contentsScale: 1

        // Instagram oauth URL
        url: InstagramKeys.instagramAuthorizeUrl + "/?client_id=" + InstagramKeys.instagramClientId + "&redirect_uri=" + InstagramKeys.instagramRedirectUrl + "&response_type=code&scope=likes+comments+relationships";

        // check on every page load if the oauth token is in it
        onUrlChanged: {
            var instagramResponse = new Array();
            instagramResponse = Authentication.checkInstagramAuthenticationUrl(url);
            console.log("Status: " + instagramResponse["status"]);

            if (instagramResponse["status"] == "AUTH_ERROR")
            {
                loginInstagramWebView.visible = false;
                loginErrorText.text = instagramResponse["error_description"];
                loginErrorContainer.visible = true;
            }

            if (instagramResponse["status"] == "AUTH_SUCCESS")
            {
                loginInstagramWebView.visible = false;
                loginSuccessContainer.visible = true;
            }
        }

        // activates the loading indicator when a new page is loaded
        onLoadStarted: {
            loadingIndicator.running = true;
            loadingIndicator.visible = true;
        }

        // deactivates the loading indicator when the page is done loading
        onLoadFinished: {
            loadingIndicator.running = false;
            loadingIndicator.visible = false;
        }


        // show the loading indicator as long as the page is not ready
        BusyIndicator {
            id: loadingIndicator

            anchors.centerIn: parent
            platformStyle: BusyIndicatorStyle { size: "large" }

            running:  false
            visible: false
        }
    }


    Rectangle {
        id: loginErrorContainer

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
            id : loginErrorHeadline

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: loginErrorText.top
                bottomMargin: 20
            }

            width: 400

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.WordWrap

            text: "Could not authenticate you";
        }


        // description
        Text {
            id : loginErrorText

            anchors {
                centerIn: parent
            }

            width: 400

            font.family: "Nokia Pure Text"
            font.pixelSize: 20

            wrapMode: Text.WordWrap
            textFormat: Text.RichText

            text: "";
        }
    }


    Rectangle {
        id: loginSuccessContainer

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
            id : loginSuccessHeadline

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: loginSuccessText.top
                bottomMargin: 20
            }

            width: 400

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.WordWrap

            text: "Thank you for authenticating";
        }


        // description
        Text {
            id : loginSuccessText

            anchors {
                centerIn: parent
            }

            width: 400

            font.family: "Nokia Pure Text"
            font.pixelSize: 20

            wrapMode: Text.WordWrap
            textFormat: Text.RichText

            text: "You are authenticated with Instagram and you can now use all Instago features. Have fun!";
        }
    }


    // toolbar for the detail page
    ToolBarLayout {
        id: loginToolbar
        visible: false

        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop(Qt.resolvedUrl("PopularPhotosPage.qml"));
            }
        }
    }
}
