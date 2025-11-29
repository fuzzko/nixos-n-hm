import QtQuick

Item {
    id: revealer
    
    enum TransitionType {
        None,
        CrossFade,
        SlideDown,
        SlideUp,
        SlideLeft,
        SlideRight
    }
    
    required property bool reveal
    property Transition transitionType: Revealer.TransitionType.CrossFade
    property int duration
    property var easing
    default property alias content: child.children

    states: [
        State {
            name: "reveal"
            when: revealer.transitionType === Revealer.TransitionType.CrossFade

            PropertyChanges {
                child.opacity: 0
            }
        }
    ]

    transitions: [
        Transition {
            reversible: true
            NumberAnimation {
                target: child
                property: "opacity"
                easing: easing
                duration: duration
            }
        }
    ]

    Item {
        id: child
    }
}
