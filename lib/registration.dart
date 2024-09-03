import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todolist_team/login.dart';
import 'homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var password = '';
  var emailAddress = '';
  var confirmpassword = '';
  var name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9E6EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9E6EE),
        elevation: 0,
        title: const Text(
          'To-D0 App',
          style: TextStyle(
            fontFamily: 'fingerPaint',
            fontSize: 38,
            color: Color(0xFFCD3271),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/Frame.svg',
                width: 320,
                height: 320,
                color: const Color(0xFFCD3271),
              ),
              const SizedBox(height: 20),

              // email input
              TextField(
                onChanged: (value) {
                  emailAddress = value;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Color(0xFFD03E7A)),
                  hintText: 'Email',
                  filled: true,
                  fillColor: const Color(0xFFFDF7F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // name input
              TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Color(0xFFD03E7A)),
                  hintText: 'Name',
                  filled: true,
                  fillColor: const Color(0xFFFDF7F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Password Input
              TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.key, color: Color(0xFFD03E7A)),
                  hintText: 'Password',
                  filled: true,
                  fillColor: const Color(0xFFFDF7F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // confirm password also checks for same as above
              TextField(
                onChanged: (value) {
                  confirmpassword = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.key, color: Color(0xFFD03E7A)),
                  hintText: 'Confirm Password',
                  filled: true,
                  fillColor: const Color(0xFFFDF7F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // Log In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      if (password == confirmpassword) {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailAddress,
                          password: password,
                          // name: name,
                        );
                        final DatabaseReference database = FirebaseDatabase.instance.ref();
                        await database.child('users/${credential.user!.uid}').set({
                          'name': name,
                          'email': emailAddress,
                        });

                        // Navigate to the HomePage when pressed
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      } else {
                        const snackBar = SnackBar(
                          content: Text('Password Does Not Match'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        print('Password does not match');
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCD3271), // Button color
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Register',
                      style: TextStyle(fontSize: 16, color: Color(0xFFFDF7F9))),
                ),
              ),
              const SizedBox(height: 10),
              // Sign Up Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have account? ",
                    style: TextStyle(color: Color(0xFFCD3271)),
                  ),
                  TextButton(
                    onPressed: () {
                      // new user registration page opens
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(color: Color(0xFFD03E7A)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
