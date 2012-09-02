// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "js/instago/globals.js" as Globals
import "js/instago/popularphotos.js" as PopularPhotos

// https://api.instagram.com/v1/media/popular?client_id=3bbd61a332384e66a46026c3dbbfaadc

Page {
    tools: overviewToolbar

    Component.onCompleted: {
        PopularPhotos.showDetailImageFromGallery(Globals.currentGalleryContent, Globals.currentGalleryIndex);
    }

    BusyIndicator {
        id: loadingIndicator
        platformStyle: BusyIndicatorStyle { size: "large" }
        running:  true
        visible: true
        anchors.centerIn: parent
    }


    Rectangle {
        id: detailImageContainer
        width: 480
        height: 600
        visible: false
        anchors.topMargin: 50
        color: "#000000"

        Image {
            id: detailImage
            width: 480
            height: 480
            smooth: true
            anchors.top: detailImageContainer.top
        }

        Text {
            id: imageCaption
            text: ""
            color: "#ffffff"
            // Use for headlines
            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.Wrap

            // Use for regular text
//            font.family: "Nokia Pure Text"
            anchors {
                top: detailImage.bottom
                topMargin: 10
            }
        }
    }

    /*
    MouseArea {
            Image {
                id: currentImage
                width: 480
                height: 480
                smooth: true
                anchors.centerIn: parent
                visible: false

                enabled: {
                    PopularPhotos.test(Globals.sPressedImage);
                }
        }

        id: mouseArea
        anchors.fill: parent;

        property int oldX: 0
        property int oldY: 0

        onPressed: {
            oldX = mouseX;
            oldY = mouseY;
        }

        onReleased: {
            var xDiff = oldX - mouseX;
            var yDiff = oldY - mouseY;
            if( Math.abs(xDiff) > Math.abs(yDiff) ) {
                if( oldX > mouseX) {
//                    onLeftSwipe();
                    PopularPhotos.nextPopularImage();
                    console.log("left");
                } else {
//                    onRightSwipe();
                    PopularPhotos.prevPopularImage();
                    console.log("right");
                }
            } else {
                if( oldY > mouseY) {}
                else { }
            }
        }
    }
*/
}
