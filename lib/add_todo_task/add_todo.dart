import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/hive_db/hive_db.dart';
import 'package:todo_list/todo_widgets/todo.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _formKey = GlobalKey<FormState>();
  Priority _priority = Priority.low;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  /// Converts Priority enum to simple string
  String convertPriorityToString(Priority p) => p.title;

  /// Saves a todo into Hive and then returns to HomeScreen
  Future<void> _saveTodo() async {
    if (_formKey.currentState!.validate()) {
      // 1) Collect input values
      String title = _titleController.text.trim();
      String description = _descriptionController.text.trim();
      String priorityString = convertPriorityToString(_priority);

      // 2) Create Data object
      Data newTodo = Data(
        title: title,
        description: description,
        priority: priorityString,
      );

      try {
        // 3) Save to Hive
        var box = Hive.box<Data>('todoBox');
        await box.add(newTodo);

        // 4) Show a confirmation SnackBar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Todo Added: $title")),
          );
        }

        // 5) Clear fields
        _titleController.clear();
        _descriptionController.clear();
        setState(() => _priority = Priority.low);

        // 6) Go back to HomeScreen
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error saving todo: $e")),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInputField("Title", _titleController, len: 20, lines: 1),
              const SizedBox(height: 20),

              _buildInputField("Description", _descriptionController, len: 60, lines: 2),
              const SizedBox(height: 20),

              DropdownButtonFormField<Priority>(
                value: _priority,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  hintText: 'Select priority level',
                  filled: true,
                  fillColor: Colors.blue.shade50,
                  labelStyle: TextStyle(color: Colors.blue.shade800),
                  hintStyle: TextStyle(color: Colors.blue.shade400),
                  floatingLabelStyle: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade300),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade700, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                ),
                dropdownColor: Colors.blue.shade50,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                items: Priority.values.map((p) {
                  return DropdownMenuItem<Priority>(
                    value: p,
                    child: Text(
                      p.title,
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _priority = value);
                  }
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveTodo,
                child: const Text('Add Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildInputField(String val, TextEditingController controller,
      {int len = 1, int lines = 1}) {
    return TextFormField(
      controller: controller,
      maxLength: len,
      maxLines: lines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: val,
        hintText: 'Enter the $val of the todo',
        filled: true,
        fillColor: Colors.blue.shade50,
        labelStyle: TextStyle(color: Colors.blue.shade800),
        hintStyle: TextStyle(color: Colors.blue.shade400),
        floatingLabelStyle: TextStyle(
          color: Colors.blue.shade900,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(val == "Title" ? Icons.title : Icons.description),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => controller.clear(),
        ),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade300),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      validator: (value) =>
      (value == null || value.isEmpty || value.length < 3)
          ? 'Please enter a todo $val'
          : null,
    );
  }
}