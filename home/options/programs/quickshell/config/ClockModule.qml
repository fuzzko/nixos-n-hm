import Quickshell
import QtQuick

Item {    
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Text {
        anchors.centerIn: parent.parent
        text: Qt.formatDateTime(clock.date, "hh:mm")
    }
}
