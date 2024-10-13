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
  int _selectedPriority = 1; 

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      List<Task> tasks = await apiService.fetchTasks();
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

  // START ADD TASK FUNCTIONALITY
  void showAddDialog() {
    TextEditingController contentController = TextEditingController();
    int selectedPriority = _selectedPriority;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add Task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      hintText: "Enter Task Content",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Select Priority: "),
                      DropdownButton<int>(
                        value: selectedPriority,
                        items: const [
                          DropdownMenuItem(value: 1, child: Text("Priority 1")),
                          DropdownMenuItem(value: 2, child: Text("Priority 2")),
                          DropdownMenuItem(value: 3, child: Text("Priority 3")),
                          DropdownMenuItem(value: 4, child: Text("Priority 4")),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedPriority = value;
                            });
                          }
                        },
                      ),
                    ],
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
                    _addTask(contentController.text, selectedPriority);
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addTask(String content, int priority) async {
    if (content.isEmpty) return;

    Task newTask = Task(
      id: DateTime.now().toString(), 
      content: content,
      completed: false,
      priority: priority,
    );

    try {
     
      await apiService.addTask(content, priority); 
      setState(() {
        _tasks.add(newTask); 
      });
    } catch (e) {
      print('Error adding task: $e');
    }
  }
  // END ADD TASK FUNCTIONALITY

  void checkBoxChanged(Task task, bool? value) {
    setState(() {
      task.completed = value ?? false;
    });
  }

  // START EDIT TASK FUNCTIONALITY
  void showEditDialog(Task task) {
    TextEditingController contentController =
        TextEditingController(text: task.content);
    int selectedPriority = task.priority ?? 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Edit Task"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      hintText: "Enter Task Content",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Select Priority: "),
                      DropdownButton<int>(
                        value: selectedPriority,
                        items: const [
                          DropdownMenuItem(value: 1, child: Text("Priority 1")),
                          DropdownMenuItem(value: 2, child: Text("Priority 2")),
                          DropdownMenuItem(value: 3, child: Text("Priority 3")),
                          DropdownMenuItem(value: 4, child: Text("Priority 4")),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedPriority = value;
                            });
                          }
                        },
                      ),
                    ],
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
                    _updateTask(
                        task.id!, contentController.text, selectedPriority);
                    Navigator.pop(context);
                  },
                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateTask(String id, String content, int priority) async {
    if (content.isEmpty) return;

    try {
      
      await apiService.updateTask(id, content, priority);

     
      setState(() {
        final index = _tasks.indexWhere((task) => task.id == id);
        if (index != -1) {
          _tasks[index] = Task(
            id: id,
            content: content,
            completed: _tasks[index].completed,
            priority: priority,
          );
        }
      });
    } catch (e) {
      print('Error updating task: $e');
    }
  }
  // END EDIT TASK FUNCTIONALITY

  // START SORT FUNCTIONALITY
  void _sortTasks(bool ascending) {
    setState(() {
      _tasks.sort((a, b) {
        int aPriority = a.priority ?? 0; 
        int bPriority = b.priority ?? 0; 
        return ascending
            ? aPriority.compareTo(bPriority)
            : bPriority.compareTo(aPriority);
      });
    });
  }

  // END SORT FUNCTIONALITY

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To-Do App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Color.fromARGB(255, 0, 35, 150)],
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'low_to_high') {
                _sortTasks(true);
              } else if (value == 'high_to_low') {
                _sortTasks(false);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'low_to_high',
                child: Text('Low to High Priority'),
              ),
              const PopupMenuItem(
                value: 'high_to_low',
                child: Text('High to Low Priority'),
              ),
            ],
          ),
        ],
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
                        // START DELETE TASK FUNCTIONALITY
                        SlidableAction(
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: Colors.red,
                          onPressed: (context) async {
                            try {
                              await apiService.deleteTask(_tasks[index].id!);

                              setState(() {
                                _tasks.removeAt(index);
                              });
                            } catch (e) {
                              print('Error deleting task: $e');
                            }
                          },
                          icon: Icons.delete,
                        ),
                        // END DELETE TASK FUNCTIONALITY
                        SlidableAction(
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: Colors.white,
                          onPressed: (context) => showEditDialog(task),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
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
                                const SizedBox(height: 4),
                                Text(
                                  'Priority: ${task.priority}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
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
