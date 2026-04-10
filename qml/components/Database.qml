import QtQuick 2.0
import QtQuick.LocalStorage 2.0

QtObject {
    property var db;

    function createTable() {
        db.transaction(function(tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS notes(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                note TEXT NOT NULL,
                date TEXT NOT NULL);");
        });
        console.log("Таблица создана");
    }

    function insertNote(note, date) {
        db.transaction(function(tx) {
            tx.executeSql("INSERT INTO notes (note, date) VALUES (?, ?)", [note, date]);
        });
        console.log("Добавлено:", note, date);
    }

    function readNote(note,date) {
        var result = null;
        db.readTransaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM notes WHERE note = ? AND date = ?", [note,date]);
            if (rs.rows.length > 0) {
                result = rs.rows.item(0);
                console.log("Найдено:", result.id, result.note, result.date);
            }
        });
        return result;
    }

    function deleteById(id) {
        db.transaction(function(tx) {
            tx.executeSql("DELETE FROM notes WHERE id = ?", [id]);
        });
        console.log("Удалено id:", id);
    }
    function deleteTable() {
        db.transaction(function(tx) {
            tx.executeSql("DROP TABLE IF EXISTS notes");
        });
        console.log("Таблица удалена полностью");
    }

    function updateById(id, newNote, newDate) {
        db.transaction(function(tx) {
            tx.executeSql("UPDATE notes SET note = ?, date = ? WHERE id = ?",
                         [newNote, newDate, id]);
        });
        console.log("Обновлено id:", id);
    }

    Component.onCompleted: {
        db = LocalStorage.openDatabaseSync("notes", "1.0");
        console.log("База данных открыта");
    }
}
