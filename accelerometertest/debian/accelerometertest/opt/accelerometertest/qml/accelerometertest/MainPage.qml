import QtQuick 1.1
import QtMobility.sensors 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    OrientationSensor {
        id: oriData
        active: true

        onReadingChanged: {
                txtOrientation.text = "Orientation: " + reading.orientation;
            }
     }

    Accelerometer {
        id: accData
        active: true

        onReadingChanged: {
            txtAccelerometer.text = "Accelerometer: \nX: " + reading.x + "\nY: " + reading.y + "\nZ: " + reading.z;
        }
    }

    Text {
        id: txtOrientation
        anchors.centerIn: parent
        text: "Orientation  starting.."
        font.pointSize: 25
    }

    Text {
        id: txtAccelerometer
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: txtOrientation.bottom
            topMargin: 10
        }
        text: "Accelerometer starting.."
        font.pointSize: 25
    }

}
