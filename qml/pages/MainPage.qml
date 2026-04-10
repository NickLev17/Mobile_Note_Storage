import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components" as MyDatabase
Page {
  objectName: "mainPage"
  allowedOrientations: Orientation.All

  backgroundColor: "#2d2d2d"

  MyDatabase.Database
  {
    id:database
  }

  SilicaListView {
    header: PageHeader {

      objectName: "pageHeader"
      title: qsTr("Notes")+"("+listModel.count+")"
    }

    anchors.fill: parent
    model: ListModel { id: listModel }
    delegate: ListItem
    {
      id:listItem

      _backgroundColor:"#effd5f"
      contentHeight:content.implicitHeight

      Column{
        id:content

        anchors {
          left: parent.left
          right: parent.right
          margins: Theme.horizontalPageMargin
        }
        Rectangle
        {

          id:rec

          property int id_db:db_id
          width: parent.width
          height:30
          color:"white"
          Text
          {
            anchors.fill: rec
            font.pixelSize: 25
            text:(index+1)+") "+date
          }
        }
        Row{

          anchors.fill: listItem
          height: labelNote.height
          id:layautNote
          anchors.margins: Theme.horizontalPageMargin
          spacing: 20

          Label {
            id:labelNote
            color: "black"
            height: Math.max(implicitHeight,90)
            width: 480
            wrapMode: Text.WordWrap
            x: Theme.horizontalPageMargin
            text: note
          }

          Button
          {
            id:btn_сorrect
            icon.source: "../icons/pen.png"
            icon.width: 60
            icon.height: 60
            width:70
            onClicked:
            {
              var item=listModel.get(index)
              var dialog = pageStack.push(Qt.resolvedUrl("NoteDialog.qml"),{"note":labelNote.text})
              dialog.accepted.connect(function () {
                listModel.setProperty(index,"note", dialog.note)
                listModel.setProperty(index,"date", dialog.dateNote)
                database.updateById(rec.id_db, dialog.note, dialog.dateNote)
              })

            }
          }

          Button
          {
            id: btn_remove

            icon.source: "../icons/basket.png"
            icon.width: 60
            icon.height: 60
            width:70
            onClicked: {
              listModel.remove(index)
              database.deleteById(rec.id_db)
            }
          }
        }
      }
      onClicked:
      {
        var row=  database.readNote(note,date)
        rec.id_db=row.id
        console.log(row.id,row.note,row.date)
      }
    }

    PullDownMenu {
      id:menu
      MenuItem {
        id:menuItem
        text: "Удалить все заметки"

        onClicked: {
          database.deleteTable()
          listModel.clear()

        }
      }

      Rectangle
      {
        color: menuItem.palette.backgroundGlowColor
        height:50
        width:menu.width
      }

      MenuItem {
        text: "Добавить заметку"
        onClicked: {
          database.createTable()
          var dialog = pageStack.push(Qt.resolvedUrl("NoteDialog.qml"))
          dialog.accepted.connect(function () {
            database.insertNote(dialog.note,dialog.dateNote)
            console.log("Data",dialog.dateNote)
            var row=  database.readNote(dialog.note,dialog.dateNote)
            listModel.append({'db_id':row.id,'note': dialog.note,'date':dialog.dateNote})
          })
        }
      }


    }
  }

  Component.onCompleted:   database.createTable()
}
