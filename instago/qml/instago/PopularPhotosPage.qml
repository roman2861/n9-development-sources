// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1
import "js/globals.js" as Globals
import "js/popularphotos.js" as PopularPhotosScript

Page {
    // use the popular photos toolbar
    tools: popularPhotosToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // load the gallery content as soon as the page is ready
    Component.onCompleted: {
        PopularPhotosScript.loadImages();
    }


    // standard header for the current page
    Header {
        id: pageHeader
        source: "img/top_header.png"
        text: qsTr("Popular")
    }


    // this is the main container component
    // it contains the actual gallery items
    Component {
        id: galleryDelegate


        // this is an individual gallery item
        Item {
            id: galleryItem
            width: galleryGrid.cellWidth
            height: galleryGrid.cellHeight


            // use the whole item as tap surface
            // all taps on the item will be handled by the onclick event
            MouseArea {
                anchors.fill: parent
                onClicked:
                {
                    // console.log("Image tapped. Id was: " + galleryIndex.text + ", source file was: " + galleryThumbnail.source);

                    Globals.currentGalleryContent = PopularPhotosScript.arrPopularImages;
                    Globals.currentGalleryIndex = galleryIndex.text;

                    pageStack.push(Qt.resolvedUrl("ImageDetailPage.qml"))
                }
            }


            // this is just a dummy text that contains the id of the gallery image
            Text {
                id: galleryIndex
                text: index
                visible: false
            }


            // this is the rectangle that holds the actual gallery image
            // its used as an empty default rect that is filled if the image could be loaded
            Rectangle {
                color: "gainsboro"
                anchors.horizontalCenter: parent.horizontalCenter
                width: 154
                height: 154

                // the actual gallery image
                Image {
                    id: galleryThumbnail
                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter;
                    }
                    source: url
                }
            }
        }
    }


    // this is just an id
    // the model is defined in the array
    ListModel {
        id: galleryListModel
    }


    // show the loading indicator as long as the page is not ready
    BusyIndicator {
        id: loadingIndicator
        platformStyle: BusyIndicatorStyle { size: "large" }
        running:  true
        visible: true
        anchors.centerIn: parent
    }


    // error indicator that is shown when the gallery could not be loaded
    Rectangle {
        id: errorIndicator

        anchors {
            top: pageHeader.bottom;
            topMargin: 3;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            onClicked:
            {
                console.log("Refresh clicked")
                errorIndicator.visible = false;
                galleryGrid.reload = true;
            }
        }

        Text {
            id: reloadMessage
            anchors.fill: parent

            anchors {
                top: parent.top;
                left: parent.left;
                leftMargin: 10;
                right: parent.right;
                rightMargin: 10;
                bottom: parent.bottom;
            }

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            wrapMode: Text.Wrap

            text: "Could not load the popular photo list. Please tap to try again."
        }

    }


    // the actual grid view
    // this contains the individual items and shows them as a list
    GridView {
        id: galleryGrid

        // this checks if the gallery needs to be reloaded
        property bool reload: false

        // this reloads the galley if the reload property has been changed
        onReloadChanged: {
            if (galleryGrid.reload)
            {
                loadingIndicator.running = true;
                loadingIndicator.visible = true;
                galleryGrid.visible = false;
                PopularPhotosScript.loadImages();
                galleryGrid.reload = false;
            }
        }

        anchors {
            top: pageHeader.bottom;
            topMargin: 3;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        cellWidth: 160; cellHeight: 160
        focus: true
        visible: false

        // clipping needs to be true so that the size is limited to the container
        clip: true

        // define model and delegate
        model: galleryListModel
        delegate: galleryDelegate
    }


    // toolbar for the popular photos
    ToolBarLayout {
        id: popularPhotosToolbar
        visible: false
        ToolIcon {
            iconId: "toolbar-refresh";
            onClicked: {
                console.log("Refresh clicked")
                galleryGrid.reload = true;
            }
        }
        ToolIcon {
            iconId: "toolbar-settings";
            onClicked: {
                pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
    }
}
