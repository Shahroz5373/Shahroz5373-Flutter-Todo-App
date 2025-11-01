import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/add_todo_task/add_todo.dart';
import 'package:todo_list/hive_db/hive_db.dart';
import 'package:todo_list/todo_widgets/todo.dart';
import 'package:todo_list/todo_widgets/todo_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Data> todoBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    todoBox = await Hive.openBox<Data>('todoBox');
    setState(() {});
  }

  // Delete a specific todo from Hive
  void _deleteTodoAt(int index) {
    todoBox.deleteAt(index);
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Todo deleted ❌')));
    }
  }

  // Complete a todo → also remove from Hive
  void _completeTodoAt(int index) {
    todoBox.deleteAt(index);
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Todo completed ✔')));
    }
  }

  // Convert stored String → Priority enum
  Priority _convertStringToPriority(String? priority) {
    switch (priority) {
      case 'urgent':
        return Priority.urgent;
      case 'high':
        return Priority.high;
      case 'medium':
        return Priority.medium;
      default:
        return Priority.low;
    }
  }

  // Navigate to AddTodo screen
  void _navigateToAddTodo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTodo()),
    ).then((_) {
      if (mounted) {
        setState(() {}); // refresh on return
      }
    });
  }

  // Show Confirmation Dialog to Clear All Todos
  void _clearAllTodos() {
    if (todoBox.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No todos to delete!")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete All Todos?"),
        content: const Text("Are you sure you want to delete all todos?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              todoBox.clear(); // Deletes all from Hive
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All todos deleted ')),
              );
            },
            child: const Text("Delete All", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        actions: [
          // Button to Clear All Todos
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: "Delete All Todos",
            onPressed: _clearAllTodos,
          ),
        ],
      ),

      body: todoBox.isEmpty
          ? const Center(
        child: Text(
          "No Todos yet! Add some using + button",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: todoBox.length,
        itemBuilder: (context, index) {
          final data = todoBox.getAt(index);
          if (data == null) return const SizedBox();

          final todo = Todo(
            title: data.title ?? "Untitled",
            description: data.description ?? "",
            priority: _convertStringToPriority(data.priority),
          );

          return _buildDismissibleTile(todo, index);
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddTodo,
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  // Dismissible TodoTile with Swipe Actions
  Widget _buildDismissibleTile(Todo todo, int index) {
    return Dismissible(
      key: Key('${todo.title}$index'),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.check, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _completeTodoAt(index);
          return false; // Don't dismiss since we're handling it
        } else {
          _deleteTodoAt(index);
          return false; // Don't dismiss since we're handling it
        }
      },
      child: TodoTile(todo: todo),
    );
  }
}