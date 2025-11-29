import Quickshell
import QtQuick

Item {
    implicitHeight: text.implicitHeight
    implicitWidth: text.implicitWidth

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Text {
        id: text
        text: Qt.formatDateTime(clock.date, "hh:mm")
    }
}
