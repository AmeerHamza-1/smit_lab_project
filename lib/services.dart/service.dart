import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:new_proj/models/model.dart';

class ApiService {
  final String apiToken = '6bf5b3cd1b7c3a182aeb38160f977f59c9ccfe98';

  Future<List<Task>> fetchTasks() async {
    List<Task> tasks = [];
    final url = Uri.parse('https://api.todoist.com/rest/v2/tasks');
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
}
