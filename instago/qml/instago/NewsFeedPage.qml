// *************************************************** //
//  News Feed Page
//
// The page shows the news feed for the user.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1

import "js/globals.js" as Globals
import "js/authentication.js" as Authentication

Page {
    // use the main navigation toolbar
    tools: mainNavigationToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // load the gallery content as soon as the page is ready
    Component.onCompleted: {

        // show main buttosn if the user is logged in
        if (Authentication.isAuthorized())
        {
            iconHome.visible = true;
            iconPopular.visible = true;
        }
    }

    // standard header for the current page
    Header {
        id: pageHeader
        source: "img/top_header.png"
        text: qsTr("News")
    }

}
