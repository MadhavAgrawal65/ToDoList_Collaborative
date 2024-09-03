import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'teamdashboard.dart';

class TeamPage extends StatefulWidget {
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamCodeController = TextEditingController();

  Future<void> _createTeam() async {
    final teamName = _teamNameController.text.trim();
    if (teamName.isEmpty) {
      _showError('Team name cannot be empty');
      return;
    }

    final random = Random();
    final teamCode = (random.nextInt(900000) + 100000).toString();
    final userId = _auth.currentUser?.uid;

    if (userId == null) {
      _showError('User is not authenticated');
      return;
    }

    final teamData = {
      'teamName': teamName,
      'members': {userId: true},
      'tasks': {}
    };

    try {
      await _dbRef.child('teams/$teamCode').set(teamData);
      await _dbRef.child('users/$userId/teams/$teamCode').set(true);

      _navigateToTeamDashboard(teamCode);
    } catch (error) {
      print('Error creating team: $error');
      _showError('Failed to create team');
    }
  }

  void _joinTeam() async {
    final teamCode = _teamCodeController.text.trim();
    print('Entered Team Code: $teamCode');

    if (teamCode.isEmpty) {
      _showError('Please enter a team code');
      return;
    }

    DatabaseReference teamRef = FirebaseDatabase.instance.ref().child('teams').child(teamCode);

    try {
      final snapshot = await teamRef.get();

      if (snapshot.exists) {
        print('Team found in database');
        _navigateToTeamDashboard(teamCode);
      } else {
        print('Team not found in database');
        _showError('Team not found');
      }
    } catch (error) {
      print('Error checking team existence: $error');
      _showError('An error occurred');
    }
  }

  void _navigateToTeamDashboard(String teamCode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamDashboardPage(teamCode: teamCode),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9E6EE),
      body: 
      SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // color: const Color(0xFFE594B5),
                    width: double.infinity,
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          'Team Dashboard',
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: 'fingerPaint',
                            color: Color(0xFFCD3271),
                          ),
                        ),
                      ),
                    ),
                  ),
                
                  const SizedBox(height: 70,),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _teamNameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.key, color: Color(0xFFD03E7A)),
                        labelText: 'Enter Team Name to Create',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: _createTeam,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCD3271),
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                    ),
                    child: const Text(
                      'Create Team',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _teamCodeController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.key, color: Color(0xFFD03E7A)),
                        labelText: 'Enter Team Code to Join',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _joinTeam,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCD3271),
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                    ),
                    child: const Text(
                      'Join Team',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
