import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'taskform.dart';



class HomeDashboardPage extends StatefulWidget {
  @override
  _HomeDashboardPageState createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  final List<Map<String, dynamic>> _tasks = [];
  String _quote = "Loading a random quote...";
  Timer? _timer;
  DatabaseReference _tasksRef = FirebaseDatabase.instance.ref().child('users').child(FirebaseAuth.instance.currentUser!.uid);

  @override
  void initState() {
    super.initState();
    _getRandomQuote();
    _fetchTasksFromFirebase();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _getRandomQuote();
    });
  }

  Future<void> _fetchTasksFromFirebase() async {
  _tasksRef.onValue.listen((event) {
    final data = event.snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      print('Data fetched from Firebase: $data');
      final List<Map<String, dynamic>> loadedTasks = [];

      data.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          loadedTasks.add({
            'key': key,
            'title': value['title'],
            'isDone': value['isDone'],
            'date': DateTime.parse(value['date']),
          });
        }
      });

      setState(() {
        if (mounted) {
          _tasks.clear();
          _tasks.addAll(loadedTasks);
        }
      });
    } else {
      print('No data available');
    }
  });
}


  // Future<void> _fetchTasksFromFirebase() async {
  //   _tasksRef.onValue.listen((event) {
  //     final data = event.snapshot.value as Map<dynamic, dynamic>?;

  //     if (data != null) {
  //       final List<Map<String, dynamic>> loadedTasks = [];

  //       data.forEach((key, value) {
  //         loadedTasks.add({
  //           'key': key, 
  //           'title': value['title'],
  //           'isDone': value['isDone'],
  //           'date': DateTime.parse(value['date']),
  //         });
  //       });

  //       setState(() {
  //         _tasks.clear();
  //         _tasks.addAll(loadedTasks);
  //       });
  //     }
  //   });
  // }

  Future<void> _getRandomQuote() async {
  bool validQuote = false;

  while (!validQuote) {
    try {
      final response = await http.get(Uri.parse('http://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final quoteText = data['quoteText'];

        if (!quoteText.contains("'")) {
          setState(() {
            _quote = quoteText;
            validQuote = true; 
          });
        }
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (error) {
      setState(() {
        _quote = 'Madhav have succesfully made an app';
      });
      validQuote = true;
    }
  }
}

  void _addTask() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Task'),
        content: TaskForm(),
        actions: [],
      ),
    );

    if (result != null) {
      setState(() {
        if (!result.containsKey('isDone')) {
          result['isDone'] = false;
        }
        if (result['title'] == null) {
          result['title'] = 'Untitled Task';
        }
        _tasks.add(result);
      });

      DatabaseReference newTaskRef = _tasksRef.push();
      newTaskRef.set({
        'title': result['title'],
        'isDone': result['isDone'],
        'date': result['date'].toIso8601String(),
      });
    }
  }

  void _toggleTaskStatus(int index) {
    setState(() {
      _tasks[index]['isDone'] = !_tasks[index]['isDone'];
    });

    String taskKey = _tasks[index]['key'];
    _tasksRef.child(taskKey).update({'isDone': _tasks[index]['isDone']});
  }

  void _deleteTask(int index) {
    String taskKey = _tasks[index]['key'];

    setState(() {
      _tasks.removeAt(index);
    });

    _tasksRef.child(taskKey).remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (ctx, index) {
                final task = _tasks[index];
                return Dismissible(
                  key: ValueKey(task['title'] ?? 'Unknown Task'),
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
                    _deleteTask(index);
                  },
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(
                        task['isDone'] == true ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: const Color(0xFFCD3271),
                      ),
                      onPressed: () => _toggleTaskStatus(index),
                    ),
                    title: Text(
                      task['title'] ?? 'Untitled Task',
                      style: TextStyle(
                        color: const Color(0xFFCD3271),
                        decoration: task['isDone'] == true ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm').format(task['date'] ?? DateTime.now())),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _quote,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Color(0xFFCD3271)),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton(
          onPressed: _addTask,
          backgroundColor: const Color(0xFFCD3271),
          child: const Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}
