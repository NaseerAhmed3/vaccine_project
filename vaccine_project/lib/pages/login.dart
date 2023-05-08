import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_project/pages/admin/admin.dart';
import 'package:vaccine_project/pages/parent/parent.dart';
import 'package:vaccine_project/pages/signup.dart';

class LoginPage extends StatefulWidget {
  final String role;
  const LoginPage({
    Key? key,
    required this.role,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 35,
              ),
              child: SizedBox(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 150,
                      ),
                      child: Container(
                        height: 80,
                        width: 100,
                        decoration: BoxDecoration(
                            // color: Colors.amber,
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/comment-medical.png'))),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 550,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color(0x36489771),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Welcome Back",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                  // color: Colors.amber,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/loginp1.png'))),
                            ),
                            const SizedBox(
                              height: 0,
                            ),
                            Container(
                              width: 300,
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFFFFF))),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.cyan),
                                  ),
                                  hintText: 'Enter your email',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF000100),
                                    fontSize: 15,
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Email cannot be empty";
                                  }
                                  if (!RegExp(
                                          "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                      .hasMatch(value)) {
                                    return ("Please enter a valid email");
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 300,
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFFFFF))),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.cyan),
                                  ),
                                  hintText: 'Enter your password',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF000100),
                                    fontSize: 15,
                                  ),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SignUpPage(role: widget.role),
                                  ),
                                );
                              },
                              child: const Text(
                                "Forget password?",
                                style: TextStyle(
                                    color: Color(0xFF2FB176),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: 280,
                              // decoration: BoxDecoration(
                              //     color: Color(0xFF2FB176),
                              //     borderRadius: BorderRadius.circular(20)),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 5.0,
                                  backgroundColor: Color(0xFF2FB176),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    // side: BorderSide(color: Colors.white),
                                  ),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                                onPressed: () {
                                  signIn(emailController.text,
                                      passwordController.text);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 50,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'Don’t have an account?',
                                    style: TextStyle(
                                        color: Color(0xFF000100),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SignUpPage(role: widget.role),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "SignUp",
                                      style: TextStyle(
                                          color: Color(0xFF2FB176),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('user_roles')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.get('role') == "Admin") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Admin(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Parent(),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(""),
          ));
          // print('Document does not exist on the database');
        }
      });
    }
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("No user found for that email."),
          ));
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Wrong password provided for that user."),
          ));
        }
      }
    }
  }
}
