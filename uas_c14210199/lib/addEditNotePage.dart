// ignore: file_names
import 'package:flutter/material.dart';
import 'package:uas_c14210199/model/note.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;

  const AddEditNotePage({super.key, this.note, required this.onSave});

  @override
  // ignore: library_private_types_in_public_api
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final title = _titleController.text;
              final content = _contentController.text;

              if (title.isNotEmpty && content.isNotEmpty) {
                final note = Note(
                  title: title,
                  content: content,
                );

                if (widget.note != null) {
                  note.createdDate = widget.note!
                      .createdDate; 
                }

                widget.onSave(note);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[900], 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle:
                        TextStyle(color: Colors.white), 
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                flex:
                    4, 
                child: TextField(
                  controller: _contentController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    labelStyle:
                        TextStyle(color: Colors.white), 
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0),
                  ),
                  maxLines: null, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
