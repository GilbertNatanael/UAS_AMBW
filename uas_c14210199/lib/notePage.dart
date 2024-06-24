import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uas_c14210199/addEditNotePage.dart';
import 'package:uas_c14210199/editPin.dart';
import 'package:uas_c14210199/model/note.dart';

class Notepage extends StatefulWidget {
  const Notepage({super.key});

  @override
  State<Notepage> createState() => _NotepageState();
}

class _NotepageState extends State<Notepage> {
  late Box<Note> notesBox;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notesBox');
  }

  void _addNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditNotePage(onSave: _saveNote)),
    );
  }

  void _editNote(Note note, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditNotePage(
            note: note,
            onSave: (editedNote) {
              editedNote.lastEditedDate =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
              _updateNote(editedNote, index);
            }),
      ),
    );
  }

  void _saveNote(Note note) {
    note.lastEditedDate = note.createdDate;
    setState(() {
      notesBox.add(note);
    });
  }

  void _updateNote(Note note, int index) {
    note.lastEditedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    setState(() {
      notesBox.putAt(index, note);
    });
  }

  void _deleteNote(int index) {
    setState(() {
      notesBox.deleteAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditPinPage()),
              );
            },
            child: const Row(
              children: [
                Icon(Icons.edit),
                SizedBox(width: 4),
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text('Edit Pin'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[900],
        child: ValueListenableBuilder(
          valueListenable: notesBox.listenable(),
          builder: (context, Box<Note> box, _) {
            if (box.values.isEmpty) {
              return const Center(
                child: Text(
                  'No notes yet.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final note = box.getAt(index)!;
                return Dismissible(
                  key: Key(note.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _deleteNote(index),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical:
                            8), 
                    color: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), 
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12), 
                      title: Text(
                        note.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Created: ${note.createdDate}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                          Text(
                            'Last Edited: ${note.lastEditedDate}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                      onTap: () => _editNote(note, index),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
