import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskForm extends StatefulWidget {
  @override
  TaskFormState createState() => TaskFormState();
}

class TaskFormState extends State<TaskForm> {
  static Map<String, dynamic> taskData = {};

  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _submitForm() {
    if (_titleController.text.isEmpty) {
      return;
    }
    taskData = {
      'title': _titleController.text,
      'date': DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day),
      'isDone': false,
    };
    Navigator.of(context).pop(taskData);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Task Title',
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Date: ${DateFormat.yMd().format(_selectedDate)}',
              ),
            ),
            TextButton(
              onPressed: _presentDatePicker,
              child: const Text('Select Date',
              style: TextStyle(
                color: Color(0xFFCD3271)
              ),),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Add Task',
          style: TextStyle(
                color: Color(0xFFCD3271),
          ),),
        ),
      ],
    );
  }
}