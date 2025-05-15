import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'modelclass.dart';

class StorageService {
  static Future<void> saveProjects(List<Project> projects) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(projects.map((p) => p.toJson()).toList());
    await prefs.setString('projects', jsonString);
  }

  static Future<List<Project>> loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('projects');
    if (jsonString == null || jsonString.isEmpty) return [];
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => Project.fromJson(e)).toList();
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString('tasks', jsonString);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('tasks');
    if (jsonString == null || jsonString.isEmpty) return [];
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => Task.fromJson(e)).toList();
  }

  static Future<void> saveTimers(List<TimerEntry> timers) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(timers.map((t) => t.toJson()).toList());
    await prefs.setString('timers', jsonString);
  }

  static Future<List<TimerEntry>> loadTimers() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('timers');
    if (jsonString == null || jsonString.isEmpty) return [];
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => TimerEntry.fromJson(e)).toList();
  }
}
