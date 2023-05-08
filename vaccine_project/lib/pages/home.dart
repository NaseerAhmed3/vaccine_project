import 'package:flutter/material.dart';

import 'package:vaccine_project/pages/login.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 50,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                          image:
                              AssetImage('assets/images/comment-medical.png'))),
                ),
              ),
              Container(
                height: 300,
                width: 400,
                decoration: BoxDecoration(
                    // color: Colors.amber,
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/undraw_doctors_hwty 1.png'))),
              ),
              SizedBox(
                height: 200,
              ),
              SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    backgroundColor: Color(0xFF2FB176),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(
                          role: "Admin",
                        ),
                      ),
                    );
                  },
                  child: const Text("Health Care Officer"),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: 250,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(
                          role: "Parent",
                        ),
                      ),
                    );
                  },
                  child: const Text("Parent"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
