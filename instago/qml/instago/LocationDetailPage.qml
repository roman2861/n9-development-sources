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
        Location.getLocationData(locationId, 0);
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: "Location"
    }

    // standard notification area
    NotificationArea {
        id: notification

        visibilitytime: 1500

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }


    // container component for map metadata
    Rectangle {
        id: locationMetadata

        anchors {
            top: pageHeader.bottom
            left: parent.left
            leftMargin: 5
            right: parent.right;
            rightMargin: 5
        }

        visible: false;

        // general style definition
        color: "transparent"


        // location icon
        Image {
            id: locationIcon

            anchors {
                top: parent.top;
                topMargin: 10;
                left: parent.left
            }

            source: "image://theme/icon-m-toolbar-tag-dimmed"
        }


        // location name as headline
        Text {
            id: locationName

            anchors {
                top: parent.top
                topMargin: 10
                left: locationIcon.right
                leftMargin: 5
                right: parent.right;
            }

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.Wrap
            color: Globals.instagoDefaultTextColor

            text: ""


            // on tap, return to center of the map
            MouseArea {
                anchors.fill: parent

                onPressed:
                {
                    Location.recenterLocationMap();
                    // Qt.openUrlExternally("geo:" + locationCenter.position.coordinate.latitude + "," +  + locationCenter.position.coordinate.longitude);
                }
            }
        }


        // general container for the map components
        Rectangle {
            id: locationMapContainer

            anchors {
                top: locationName.bottom
                topMargin: 10
                left: parent.left
                right: parent.right;
            }

            height: 150


            // the position of the location
            // this is used by the map as center
            PositionSource {
                id: locationCenter
            }


            // the actual map module
            // note that location shown in the center of the map  is defined by the position source
            Map {
                id: locationMap

                anchors.fill: parent

                plugin : Plugin {name : "nokia"}
                connectivityMode: Map.HybridMode

                zoomLevel: 14
                center: locationCenter.position.coordinate


                // marker for the current location on the map
                MapCircle {
                    id: locationMapVenuePosition

                    color: Globals.instagoHighlightedTextColor
                    border.color: Globals.instagoMeegoDimmedIconColor
                    border.width: 2

                    radius: 75.0
                    center: locationCenter.position.coordinate
                    z: 2
                }
            }


            // this is the mousearea to pan the map around
            MouseArea {
                id: locationMapManipulation

                property int locationMapLastX: -1
                property int locationMapLastY: -1

                anchors.fill : parent

                onPressed: {
                    locationMapLastX = mouseX
                    locationMapLastY = mouseY
                }

                onPositionChanged: {
                    var locationMapNewX = mouseX - locationMapLastX
                    var locationMapNewY = mouseY - locationMapLastY

                    locationMap.pan(-locationMapNewX, -locationMapNewY)

                    locationMapLastX = mouseX
                    locationMapLastY = mouseY
                }
            }
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

        onListBottomReached: {
            if (paginationNextMaxId !== "")
            {
                Location.getLocationData(locationId, paginationNextMaxId);
            }
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
            Location.getLocationData(locationId, 0);
        }
    }


    // toolbar for the location detail page
    ToolBarLayout {
        id: locationToolbar

        // jump back
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
    }
}
