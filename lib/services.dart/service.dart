import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_proj/models/model.dart';

class ApiService {
  final String apiToken = '827a71f03b0fda9df5f71e6bcdc36d1dd107775e';

  Future<List<Task>> fetchTasks() async {
    final url = Uri.parse('https://api.todoist.com/rest/v2/tasks');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Task> tasks = [];
      for (var item in body) {
        tasks.add(Task.fromJson(item));
      }
      return tasks;
    } else {
      throw Exception('Failed to load tasks');
    }
  }
}
