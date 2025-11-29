import Quickshell
import QtQuick

Item {
    anchors.centerIn: parent
    
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Text {
        text: Qt.formatDateTime(clock.date, "hh:mm")
    }
}
