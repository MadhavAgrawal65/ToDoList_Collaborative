import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todolist_team/resetPass.dart';
import 'homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'registration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
// // Google sign in 
// signinwithgoogle() async {
// //pop up for google sign in
// final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
// // if cancels
// if( gUser==null) return;
// // obtain details from google sign in
// final GoogleSignInAuthentication? gAuth = await gUser!.authentication;

// // get credentials for new user
// final credential = GoogleAuthProvider.credential(
//   accessToken: gAuth?.accessToken,
//   idToken: gAuth?.idToken,
//   );

//   // final sign in
//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }


class _LoginScreenState extends State<LoginScreen> {

  var password = '';
  var emailAddress = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
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
                
                // Email Input Field
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
                
                // Password Input Field
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
                const SizedBox(height: 5),
                
                // Forgot Password Text
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Handle Forgot Password
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResetPass()),
                    );
                    },
                    child: const Text(
                      'Forget Password?',
                      
                      style: TextStyle(color: Color(0xFFD03E7A)),
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
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: emailAddress,
                        password: password,
                      );
                    // Navigate to the HomePage when pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
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
                    child: const Text('Log In', style: TextStyle(fontSize: 16,
                    color: Color(0xFFFDF7F9))),
                  ),
                ),
                const SizedBox(height: 5),
                // // google sign in button
                // ElevatedButton(onPressed: signinwithgoogle,
                // child: Icon(
                //   (Icons.login)
                // )),
                // const SizedBox(height: 5),
                
                // Sign Up Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have account? ",
                    style: TextStyle(color: Color(0xFFCD3271)),),
                    TextButton(
                      onPressed: () {
                        // new user registration page opens
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationScreen()),
                    );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Color(0xFFD03E7A)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
