import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'helperclass.dart';
import 'modelclass.dart';

class TimersScreen extends StatefulWidget {
  @override
  _TimersScreenState createState() => _TimersScreenState();
}

class _TimersScreenState extends State<TimersScreen> {
  List<TimerEntry> timers = [];
  List<Project> projects = [];
  List<Task> tasks = [];
  String? selectedProject;
  String? selectedTask;
  DateTime selectedDate = DateTime.now();
  TextEditingController totalTimeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  int _timerCounter = 1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    projects = await StorageService.loadProjects();
    tasks = await StorageService.loadTasks();
    timers = await StorageService.loadTimers();
    if (timers.isNotEmpty) {
      _timerCounter = timers.length + 1;
    }
    setState(() {});
  }

  Future<void> _addTimer() async {
    if (selectedProject == null || selectedTask == null || totalTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required")));
      return;
    }

    timers.add(TimerEntry(
      id: _timerCounter.toString(),
      projectId: selectedProject!,
      taskId: selectedTask!,
      date: DateFormat('yyyy-MM-dd').format(selectedDate),
      totalTime: double.tryParse(totalTimeController.text) ?? 0,
      note: noteController.text,
    ));
    _timerCounter++;

    await StorageService.saveTimers(timers);
    _loadData();
    Navigator.pop(context);
  }

  Future<void> _showAddTimerDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Timer"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField(
              items: projects.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
              onChanged: (value) => setState(() => selectedProject = value),
              decoration: InputDecoration(labelText: "Select Project"),
            ),
            DropdownButtonFormField(
              items: tasks.map((t) => DropdownMenuItem(value: t.id, child: Text(t.name))).toList(),
              onChanged: (value) => setState(() => selectedTask = value),
              decoration: InputDecoration(labelText: "Select Task"),
            ),
            TextFormField(
              controller: totalTimeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Total Time (hours)"),
            ),
            TextFormField(
              controller: noteController,
              decoration: InputDecoration(labelText: "Note"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: Text("Select Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(onPressed: _addTimer, child: Text("Save")),
        ],
      ),
    );
  }

  Future<void> _deleteTimer(String id) async {
    timers.removeWhere((t) => t.id == id);
    await StorageService.saveTimers(timers);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Timers")),
      body: ListView.builder(
        itemCount: timers.length,
        itemBuilder: (context, index) => ListTile(
          title: Text("Project: ${timers[index].projectId}, Task: ${timers[index].taskId}"),
          subtitle: Text("Date: ${timers[index].date}, Time: ${timers[index].totalTime} hours\nNote: ${timers[index].note}"),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteTimer(timers[index].id),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTimerDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
