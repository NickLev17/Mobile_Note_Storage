import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    property string note
    property string dateNote
    backgroundColor: "#2d2d2d"
    DialogHeader {
        id:header
        acceptText: "Сохранить"
        cancelText: "Отменить"
    }

    DatePicker
    {
        id:dataPicker
        anchors.top: header.bottom
        cellHeight: 60
    }
    Rectangle
    {
        id:spacer
        anchors.top: dataPicker.bottom
        height:100
        width: dataPicker.width
        color:"#2d2d2d"
        Rectangle
        {
            anchors.top: spacer.top
            width: dataPicker.width
            height: 10
            color: "red"
        }
    }

    TextArea {
        id: noteArea
        anchors.top: spacer.bottom
        placeholderText: "Текст заметки"
        label: "Текст заметки"
        text: note
    }
    onAccepted:
    {
        note = noteArea.text
        dateNote=dataPicker.dateText
    }
}
