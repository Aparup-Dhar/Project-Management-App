import 'package:flutter/material.dart';

import 'helperclass.dart';
import 'modelclass.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [];
  int _taskCounter = 1;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    tasks = await StorageService.loadTasks();
    if (tasks.isNotEmpty) {
      _taskCounter = tasks.length + 1;
    }
    setState(() {});
  }

  Future<void> _addTask() async {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Task"),
        content: TextField(controller: controller),
        actions: [
          ElevatedButton(
            onPressed: () async {
              tasks.add(Task(id: _taskCounter.toString(), name: controller.text));
              _taskCounter++;
              await StorageService.saveTasks(tasks);
              _loadTasks();
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTask(String id) async {
    tasks.removeWhere((task) => task.id == id);
    await StorageService.saveTasks(tasks);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tasks")),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(tasks[index].name),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteTask(tasks[index].id),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
      ),
    );
  }
}
