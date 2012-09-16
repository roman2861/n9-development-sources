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
            Authentication.checkUrlForToken(url)
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


    // toolbar for the detail page
    ToolBarLayout {
        id: loginToolbar
        visible: false

        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
    }
}
