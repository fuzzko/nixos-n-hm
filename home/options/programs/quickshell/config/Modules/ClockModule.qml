import Quickshell
import QtQuick
import QtQuick.Controls

Item {
    implicitHeight: text.implicitHeight
    implicitWidth: text.implicitWidth

    HoverHandler {
        id: device
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Text {
        id: text
        text: Qt.formatDateTime(clock.date, "hh:mm")
    }
    
    ToolTip.text: Qt.formatDateTime(clock.date, "dd/MM")
    ToolTip.delay: 500
    ToolTip.visible: device.hovered
}
