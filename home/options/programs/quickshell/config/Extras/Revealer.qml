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
    property Transition transitionType: Revealer.TransitionType.CrossFade
    property int duration
    property var easing

    Item {
        id: content
    }
}
