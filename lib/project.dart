import 'package:flutter/material.dart';

import 'helperclass.dart';
import 'modelclass.dart';

class ProjectsScreen extends StatefulWidget {
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  List<Project> projects = [];
  int _projectCounter = 1;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    projects = await StorageService.loadProjects();
    if (projects.isNotEmpty) {
      _projectCounter = projects.length + 1;
    }
    setState(() {});
  }

  Future<void> _addProject() async {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Project"),
        content: TextField(controller: controller),
        actions: [
          ElevatedButton(
            onPressed: () async {
              projects.add(Project(id: _projectCounter.toString(), name: controller.text));
              _projectCounter++;
              await StorageService.saveProjects(projects);
              _loadProjects();
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProject(String id) async {
    projects.removeWhere((proj) => proj.id == id);
    await StorageService.saveProjects(projects);
    _loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Projects")),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(projects[index].name),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteProject(projects[index].id),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProject,
        child: Icon(Icons.add),
      ),
    );
  }
}
