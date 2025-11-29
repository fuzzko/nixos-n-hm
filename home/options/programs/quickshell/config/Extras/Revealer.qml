import QtQuick

Item {
    enum Transition {
        None,
        CrossFade,
        SlideDown,
        SlideUp,
        SlideLeft,
        SlideRight
    }
    
    required property bool reveal
    property Transition transition: Revealer.Transition
}
