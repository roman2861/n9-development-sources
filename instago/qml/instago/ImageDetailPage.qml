// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "js/instago/globals.js" as Globals
import "js/instago/imagedetail.js" as PhotoDetailScript

Page {
    // use the detail view toolbar
    tools: detailViewToolbar

    Component.onCompleted: {
        PhotoDetailScript.showDetailImageFromGallery(Globals.currentGalleryContent, Globals.currentGalleryIndex);
    }

    // standard header for the current page
    Header {
        id: pageHeader
        source: "img/top_header.png"
        text: qsTr("Detail")
    }


    // main container for the detail image and content
    Rectangle {
        id: detailImageContainer

        anchors {
            top: pageHeader.bottom;
            topMargin: 3;
            left: parent.left;
            right: parent.right;
        }

        color: "#2B2B2B"

        // full width, height is 80 px
        width: parent.width;
        height: 480


        // show the loading indicator as long as the page is not ready
        BusyIndicator {
            id: loadingIndicator
            platformStyle: BusyIndicatorStyle { size: "large" }
            running:  true
            visible: true
            anchors.centerIn: parent
        }


        // the actual detail image
        // it's set to 480x480 px although the actual detail image size is 612x612
        Image {
            id: detailImage

            anchors.top: detailImageContainer.top

            width: 480
            height: 480
            smooth: true

            // invisible until loading is finished
            visible: false;

            // this listens to the loading progress
            // visibility properties are changed when finished
            onProgressChanged: {
                if (detailImage.progress == 1.0)
                {
                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;
                    detailImage.visible = true;
                }
            }
        }


        // image caption
        // this is pretty much unlimited length by instagram so it has to be cut
        Text {
            id: imageCaption
            text: ""
            color: "#ffffff"
            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25

            wrapMode: Text.Wrap

            anchors {
                top: detailImage.bottom
                topMargin: 10
            }
        }
    }

    // toolbar for the detail page
    ToolBarLayout {
        id: detailViewToolbar
        visible: false
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
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
