// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1
import "js/instago/instagramfunctions.js" as Instagram


// https://api.instagram.com/v1/media/popular?client_id=3bbd61a332384e66a46026c3dbbfaadc

Page {
    tools: commonTools

    MouseArea {
            Image {
                id: currentImage
                width: 480
                height: 480
                smooth: true
                anchors.centerIn: parent

                enabled: {
                    Instagram.loadPopularImages();
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
                    Instagram.nextPopularImage();
                    console.log("left");
                } else {
//                    onRightSwipe();
                    Instagram.prevPopularImage();
                    console.log("right");
                }
            } else {
                if( oldY > mouseY) {/*up*/ }
                else {/*down*/ }
            }
        }
    }
}
