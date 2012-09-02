// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1
import "js/instago/globals.js" as Globals
import "js/instago/popularphotos.js" as PopularPhotos

Page {
    tools: overviewToolbar
    Component.onCompleted: {
        PopularPhotos.loadImages();
    }

    BusyIndicator {
        id: loadingIndicator
        platformStyle: BusyIndicatorStyle { size: "large" }
        running:  true
        visible: true
        anchors.centerIn: parent
    }

    Component {
        id: galleryDelegate

        Item {
            id: galleryItem
            width: 150
            height: 150

            MouseArea {
                anchors.fill: parent
                onClicked:
                {
                    Globals.currentGalleryContent = PopularPhotos.arrPopularImages;
                    Globals.currentGalleryIndex = galleryIndex.text;
                    console.log("Image tapped. Id was: " + galleryIndex.text + ", source file was: " + galleryThumbnail.source);
                    pageStack.push(Qt.resolvedUrl("PopularPhotosDetail.qml"))
                }
            }

            Text {
                id: galleryIndex
                text: index
                visible: false
            }

            Image {
                id: galleryThumbnail
                anchors.horizontalCenter: parent.horizontalCenter
                source: url
            }
        }
    }

    ListModel {
        id: galleryListModel
    }

    GridView {
        id: galleryGrid
        anchors.fill: parent
        cellWidth: 160; cellHeight: 160
        focus: true
        model: galleryListModel
        delegate: galleryDelegate
        visible: false
    }
}
