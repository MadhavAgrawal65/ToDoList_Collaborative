import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:todolist_team/homepage.dart';
import 'taskform.dart';
import 'homepage.dart';

class TeamDashboardPage extends StatefulWidget {
  final String teamCode;

  TeamDashboardPage({required this.teamCode});

  @override
  _TeamDashboardPageState createState() => _TeamDashboardPageState();
}

class _TeamDashboardPageState extends State<TeamDashboardPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  late DatabaseReference _tasksRef;
  List<Map<String, dynamic>> _tasks = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tasksRef = _dbRef.child('teams/${widget.teamCode}/tasks');
    _fetchTasks();
  }

  void _fetchTasks() {
    _tasksRef.onValue.listen((event) {
      final tasksMap = event.snapshot.value as Map?;
      final List<Map<String, dynamic>> loadedTasks = [];
      if (tasksMap != null) {
        tasksMap.forEach((key, value) {
          loadedTasks.add({
            'key': key,
            'title': value['title'],
            'date': DateTime.parse(value['date']),
            'isDone': value['isDone'],
          });
        });
      }
      setState(() {
        _tasks = loadedTasks;
      });
    });
  }


  void _addNewTask(BuildContext ctx) async {
    final taskData = await showModalBottomSheet<Map<String, dynamic>>(
      context: ctx,
      builder: (_) {
        return TaskForm();
      },
    );

    if (taskData != null) {
      _saveTaskToDatabase(taskData);
    }
  }

  void _saveTaskToDatabase(Map<String, dynamic> taskData) async {
    try {
      taskData['date'] = (taskData['date'] as DateTime).toIso8601String();
      await _tasksRef.push().set(taskData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task added successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task: $error')),
      );
    }
  }

  void _toggleTaskDone(String key, bool isDone) async {
    try {
      await _tasksRef.child(key).update({'isDone': isDone});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $error')),
      );
    }
  }

  void _deleteTask(String key) async {
    try {
      await _tasksRef.child(key).remove();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete task: $error')),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFFF9E6EE),
          elevation: 0,
          title: const Column(
            children: [
              Text(
                'To-D0 App',
                style: TextStyle(
                  fontFamily: 'fingerPaint',
                  fontSize: 38,
                    color: Color(0xFFCD3271),
                ),
              ),
            ],
          ),

                  centerTitle: true,

        ),
      body: Column(
        children: [
          Text(
              'Team Code: ${widget.teamCode}',
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFFCD3271),
              ),
            ),
          const SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (ctx, index) {
                final task = _tasks[index];
                return Dismissible(
                  key: ValueKey(task['key']),
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    _deleteTask(task['key']);
                  },
                  child: ListTile(
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        decoration: task['isDone']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                        'Due: ${DateFormat.yMd().format(task['date'])}'),
                    trailing: Checkbox(
                      value: task['isDone'],
                      onChanged: (value) {
                        _toggleTaskDone(task['key'], value ?? false);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  
                  );
                },
                child: const Text(
                  'Home',
                  style: TextStyle(color: Color(0xFFD03E7A)),
                ),
              ),
            ),
            
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton(
          onPressed: () { _addNewTask(context); },
          backgroundColor: const Color(0xFFCD3271),
          child: const Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
    );
    
  }
}
