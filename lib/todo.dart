import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:new_proj/models/model.dart';
import 'package:new_proj/services.dart/service.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<Task> _tasks = [];
  bool _loading = true;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Fetch tasks from API and update state
  Future<void> _loadTasks() async {
    try {
      List<Task> tasks = await apiService.fetchTasks();
      print('Tasks fetched: $tasks'); // Debugging line to see the fetched tasks
      setState(() {
        _tasks = tasks;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Error loading tasks: $e');
    }
  }

  // Dialog for adding new tasks
  void showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Task"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: "Enter Title"),
              ),
              TextField(
                decoration: InputDecoration(hintText: "Enter Priority"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
                _loadTasks();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void checkBoxChanged(Task task, bool? value) {
    setState(() {
      task.completed = value ?? false;
    });
  }

  void editTask(Task task) {
    TextEditingController taskEditCont =
        TextEditingController(text: task.content);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Task'),
            content: TextField(
              controller: taskEditCont,
              decoration: const InputDecoration(hintText: 'Edit Task'),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      task.content = taskEditCont.text;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Update')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Color.fromARGB(255, 0, 35, 150)],
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: Colors.red,
                          onPressed: (context) {
                            setState(() {
                              _tasks.removeAt(index); // Simulating delete
                            });
                          },
                          icon: Icons.delete,
                        ),
                        SlidableAction(
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: Colors.white,
                          onPressed: (context) => editTask(task),
                          icon: Icons.edit,
                        )
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 0, 35, 150),
                            Colors.blue
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            activeColor: Colors.white,
                            checkColor: Colors.black,
                            side: const BorderSide(
                                color: Colors.white, width: 1.5),
                            value: task.completed ?? false,
                            onChanged: (value) {
                              checkBoxChanged(task, value);
                            },
                          ),
                          Expanded(
                            child: Text(
                              task.content ?? "No Content",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                decoration: task.completed == true
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationThickness: 2,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
