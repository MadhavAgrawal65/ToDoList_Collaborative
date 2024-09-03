import 'package:flutter/material.dart';
import 'package:todolist_team/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? userName = 'Loading...';
  String? userEmail = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DatabaseReference database = FirebaseDatabase.instance.ref();
      final DatabaseReference userRef = database.child('users/${user.uid}');

      setState(() {
        userEmail = user.email ?? 'No email available';
      });

      final DataSnapshot snapshot = await userRef.child('name').get();
      if (snapshot.exists) {
        setState(() {
          userName = snapshot.value.toString();
        });
      } else {
        setState(() {
          userName = 'No name found';
        });
      }
    } else {
      setState(() {
        userName = 'Not logged in';
        userEmail = 'Not logged in';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircleAvatar(
                  radius: 150,
                  backgroundColor: Color(0xFFE594B5),
                  child: Icon(
                    Icons.person_4_outlined,
                    size: 250,
                    color: Color(0xFFCD3271),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                'Logged in as',
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'fingerPaint',
                  color: Color(0xFFCD3271),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Display the user's name and email
            Center(
              child: Column(
                children: [
                  Text(
                    userName ?? 'Name not available',
                    style: const TextStyle(fontSize: 28,
                    color: Color(0xFFE594B5),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      userEmail ?? 'Email not available',
                      style: const TextStyle(fontSize: 28,
                      color: Color(0xFFE594B5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  'Log out',
                  style: TextStyle(color: Color(0xFFD03E7A)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
