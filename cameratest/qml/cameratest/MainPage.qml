import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1

Page {
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    Rectangle {
        id : rctCameraUI
        color: "black"
        visible: true
//        anchors.centerIn: parent
        width: 460
        height: 460
        x: 10
        y: 10
        rotation: 90

        Camera {
            id: camCameraElement
            x: 0
            y: 0
            width: parent.width
            height: parent.height
            focus: visible //to receive focus and capture key events
            captureResolution : "460x460"

            flashMode: Camera.FlashAuto
            whiteBalanceMode: Camera.WhiteBalanceAuto
            exposureCompensation: 0

            onImageCaptured : {
//                photoPreview.source = preview
//                stillControls.previewAvailable = true
//                cameraUI.state = "PhotoPreview"
            }
        }
    }

    Button{
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: rctCameraUI.bottom
            topMargin: 10
        }
        text: qsTr("Capture Image!")
        onClicked: camCameraElement.captureImage()
    }
}
