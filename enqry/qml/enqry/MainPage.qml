import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import "js/globals.js" as Globals

Page {
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    Header {
        id: rctMainHeader
        text: qsTr("enQRy")
    }


    Rectangle {
        id : rctCameraUI
        visible: true

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: rctMainHeader.bottom
            topMargin: 20
        }

        color: "black"

        width: 460
        height: 460
        rotation: 90

        Camera {
            id: camQRCamera
            x: 0
            y: 0
            width: parent.width
            height: parent.height
            focus: visible
            captureResolution : "460x460"

            flashMode: Camera.FlashOff
            whiteBalanceMode: Camera.WhiteBalanceAuto
            exposureCompensation: 0

            onImageCaptured: {
                console.log("Image captured");
                pageStack.push(Qt.resolvedUrl("UploadPage.qml"))
            }

            onImageSaved: {
                console.log("Image saved here:" + path);
                Globals.imagePath = path;
                Globals.imageProcessed = 0;
                console.log("Globals.imagePath is set to " + path);
            }
        }
    }


    Switch {
        id: chkCameraFlash

        anchors {
            left: rctCameraUI.left
            top: rctCameraUI.bottom
            topMargin: 15
            leftMargin: 15
        }
    }


    Text {
        id: txtCameraFlash

        anchors {
            left: chkCameraFlash.right
            top: rctCameraUI.bottom
            topMargin: 15
            leftMargin: 10
        }

        color: "black"
        font.family: "Nokia Pure Text"
        font.pointSize: 20

        height: chkCameraFlash.height
        verticalAlignment: Text.AlignVCenter
        text: chkCameraFlash.checked ? "Camera flash active" : "Camera flash off"
    }


    Button{
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: txtCameraFlash.bottom
            topMargin: 30
        }

        text: qsTr("Capture QR Code")
        onClicked: {
            if (chkCameraFlash.checked) {
                camQRCamera.flashMode = Camera.FlashOn
            }
            else {
                camQRCamera.flashMode = Camera.FlashOff
            }

            camQRCamera.captureImage();
        }
    }
}
