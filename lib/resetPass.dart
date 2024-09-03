import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({super.key});

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final _emailcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();
    super.dispose();
  }

  Future passwordreset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailcontroller.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

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
              const SizedBox(height: 100),
              const Text('Enter email to receive reset link'),
              const SizedBox(height: 10),
              // Email Input Field
              TextField(
                controller: _emailcontroller,
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
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    passwordreset();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCD3271), // Button color
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Send Reset Link',
                    style: TextStyle(fontSize: 16, color: Color(0xFFFDF7F9)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
