import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.sensors 1.1

Page {
    tools: commonTools
    orientationLock: PageOrientation.LockLandscape

    property real speedX: 0
    property real speedY: 0

    RotationSensor {
        id: rotSensor
    }

    Timer {
        id: timer
        repeat: true
        interval: 50

        onTriggered: {
            var reading = rotSensor.reading;

            var xVar = rctDot.x;
            xVar = xVar + (reading.x / 1);
            if (xVar > 834) xVar = 834;
            if (xVar < 0) xVar = 0;
            rctDot.x = xVar;

            var yVar = rctDot.y;
            yVar = yVar - ( reading.y / 2 );
            if (yVar > 420) yVar = 420;
            if (yVar < 0) yVar = 0;
            rctDot.y = yVar;
        }
    }

    Rectangle {
        id: rctDot
        width: 20
        height: 20
        color: "red"
        border.color: "black"
        border.width: 5
        radius: 20
        x: 425
        y: 240
    }

    Component.onCompleted: {
        rotSensor.start();
        timer.start()
    }

}
