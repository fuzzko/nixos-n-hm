import Quickshell
import QtQuick

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Text {
        text: Qt.formatDateTime(clock.date, "hh:mm")
    }
