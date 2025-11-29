import Quickshell
import QtQuick

Item {    
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Text {
        Layout.alignment: Qt.AlignVCenter
        text: Qt.formatDateTime(clock.date, "hh:mm")
    }
}
