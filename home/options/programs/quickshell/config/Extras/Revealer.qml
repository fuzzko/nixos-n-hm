import QtQuick

Item {
    id: root
    
    enum TransitionType {
        None,
        CrossFade,
        SlideDown,
        SlideUp,
        SlideLeft,
        SlideRight
    }

    property alias container: content.data
    required property bool reveal
    property Revealer.TransitionType transitionType: Revealer.TransitionType.CrossFade
    property int duration
    property var easing

    Item {
        id: content

        states: [
            State {
                name: "crossfade"
                when: reveal && transi
            }
        ]
    }
}
