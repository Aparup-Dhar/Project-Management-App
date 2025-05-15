import 'package:flutter/material.dart';

import 'helperclass.dart';
import 'modelclass.dart';

class GroupByProjectScreen extends StatefulWidget {
  @override
  _GroupByProjectScreenState createState() => _GroupByProjectScreenState();
}

class _GroupByProjectScreenState extends State<GroupByProjectScreen> {
  List<TimerEntry> timers = [];
  List<Project> projects = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    projects = await StorageService.loadProjects();
    timers = await StorageService.loadTimers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<TimerEntry>> groupedTimers = {};

    for (var timer in timers) {
      if (!groupedTimers.containsKey(timer.projectId)) {
        groupedTimers[timer.projectId] = [];
      }
      groupedTimers[timer.projectId]!.add(timer);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Group By Project")),
      body: ListView(
        children: groupedTimers.keys.map((projectId) {
          Project? project = projects.firstWhere((p) => p.id == projectId, orElse: () => Project(id: "Unknown", name: "Unknown Project"));

          return Card(
            margin: EdgeInsets.all(8),
            child: ExpansionTile(
              title: Text(project.name),
              children: groupedTimers[projectId]!.map((timer) {
                return ListTile(
                  title: Text("Task: ${timer.taskId}, Time: ${timer.totalTime} hrs"),
                  subtitle: Text("Date: ${timer.date}\nNote: ${timer.note}"),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
