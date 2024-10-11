import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_proj/models/model.dart';

class ApiService {
  final String apiToken = '827a71f03b0fda9df5f71e6bcdc36d1dd107775e';

  Future<List<Task>> fetchTasks() async {
    List<Task> tasks = [];
    final url = Uri.parse('https://api.todoist.com/rest/v2/tasks/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      for (var item in body) {
        tasks.add(Task.fromJson(item));
      }
      return tasks;
    } else {
      throw Exception('Failed to load tasks');
    }

  }


  Future<void> addTask(String content, int priority) async {
    final url = Uri.parse('https://api.todoist.com/rest/v2/tasks');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'content': content,
        'priority': priority,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add task');
    }
  }
  
    Future<void> updateTask(String id, String content, int priority) async {
    final url = Uri.parse('https://api.todoist.com/rest/v2/tasks/$id');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $apiToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'content': content,
        'priority': priority,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(String id) async {
    final url = Uri.parse('https://api.todoist.com/rest/v2/tasks/$id');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $apiToken',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }
}
