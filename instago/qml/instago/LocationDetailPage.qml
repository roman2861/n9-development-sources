// *************************************************** //
// Location Detail Page
//
// The location detail page shows generic information
// about a given location as well as images associated
// with this location id.
// *************************************************** //

import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.location 1.2

import "js/globals.js" as Globals
import "js/authenticationhandler.js" as Authentication
import "js/locations.js" as Location

Page {
    // use the detail view toolbar
    tools: locationToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // the location id that is shown
    // the property will be filled by the calling page
    property string locationId: "";

    // check if the user is already logged in
    Component.onCompleted: {
        // load the location data for the given location id
        Location.getLocationData(locationId);
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: "Location"
    }

    Rectangle {
        id: locationMetadata

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
        }

        height: 200
        visible: false;

        // no background color
        color: "transparent"


        // location name as headline
        Text {
            id: locationName

            anchors {
                top: parent.top
                topMargin: 10
                left: parent.left
                leftMargin: 10
                right: parent.right;
                rightMargin: 10
            }

            height: 30

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.Wrap
            color: Globals.instagoDefaultTextColor

            // content container headline
            // text will be given by the content switchers
            text: ""
        }


        // the position of the location
        // this is used by the map as center
        PositionSource {
            id: locationCenter
        }


        // the actual map module
        Map {
            id: locationMap

            anchors {
                top: locationName.bottom
                topMargin: 10;
                left: parent.left
                leftMargin: 5;
                right: parent.right;
                rightMargin: 5;
            }

            height: 150

            plugin : Plugin {name : "nokia"}
            zoomLevel: 14
            center: locationCenter.position.coordinate
        }
    }


    // gallery of location images
    ImageGallery {
        id: locationGallery;

        anchors {
            top: locationMetadata.bottom
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
    }


    // show the loading indicator as long as the page is not ready
    BusyIndicator {
        id: loadingIndicator

        anchors.centerIn: parent
        platformStyle: BusyIndicatorStyle { size: "large" }

        running:  true
        visible: true
    }


    // error indicator that is shown when a network error occured
    ErrorMessage {
        id: errorMessage

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onErrorMessageClicked: {
            // console.log("Refresh clicked")
            errorMessage.visible = false;
            loadingIndicator.running = true;
            loadingIndicator.visible = true;
            Location.getLocationData(locationId);
        }
    }


    // toolbar for the detail page
    ToolBarLayout {
        id: locationToolbar

        // jump back
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
