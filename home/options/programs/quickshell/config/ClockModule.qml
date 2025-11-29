import Quickshell
import QtQuick

Item {
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    anchors: parent.anchors

    Text {
        text: Qt.formatDateTime(clock.date, "hh:mm")
    }
}
