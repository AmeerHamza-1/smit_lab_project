import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoListWidget extends StatelessWidget {
  const ToDoListWidget(
      {super.key,
      required this.taskName,
      required this.taskStatus,
      required this.onChanged,
      required this.deleteFunction,
      required this.editFunction});
  final String taskName;
  final bool taskStatus;
  final Function(bool?) onChanged;
  final Function(BuildContext) deleteFunction;
  final Function(BuildContext) editFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 0),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.red,
            onPressed: deleteFunction,
            icon: Icons.delete,
          ),
          SlidableAction(
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.white,
            onPressed: editFunction,
            icon: Icons.edit,
          )
        ]),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 0, 35, 150), Colors.blue],
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Checkbox(
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                  side: const BorderSide(color: Colors.white, width: 1.5),
                  value: taskStatus,
                  onChanged: onChanged),
              Expanded(
                child: Text(
                  taskName,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      decoration: taskStatus
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationThickness: 1.5,
                      decorationColor: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}