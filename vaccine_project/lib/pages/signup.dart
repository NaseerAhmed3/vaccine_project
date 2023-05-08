import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_project/constants.dart';
import 'login.dart';
// import 'model.dart';

class SignUpPage extends StatefulWidget {
  final String role;
  const SignUpPage({
    super.key,
    required this.role,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  _SignUpPageState();
  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();

  final TextEditingController hospitalAddressController =
      TextEditingController();

  List<String> hospitals = [];
  String cityName = Constants.cities.first;
  String hospitalName = "";

  @override
  void initState() {
    super.initState();
    if (Constants.hospitals.containsKey(cityName)) {
      for (var element in Constants.hospitals.entries) {
        if (element.key == cityName) {
          hospitals = element.value.map((e) => e["name"] as String).toList();
        }
      }
      hospitalName = hospitals.first;
    }
  }

  Widget _parentSignupView() {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Register with us !",
            style: TextStyle(
                color: Color(0xFF000100),
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Your information is safe with us",
            style: TextStyle(
                color: Color(0xFF000100),
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 300,
            decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20)),
            child: TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.cyan),
                ),
                hintText: 'Enter your Name',
                hintStyle: TextStyle(
                  color: Color(0xFF000100),
                  fontSize: 15,
                ),
              ),
              controller: nameController,
              keyboardType: TextInputType.name,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 300,
            decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20)),
            child: TextFormField(
              controller: cnicController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.cyan),
                ),
                hintText: 'Enter your CNIC',
                hintStyle: TextStyle(
                  color: Color(0xFF000100),
                  fontSize: 15,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              width: 300,
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20)),
              child: TextFormField(
                controller: mobileController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  hintText: 'Enter your Mobile',
                  hintStyle: TextStyle(
                    color: Color(0xFF000100),
                    fontSize: 15,
                  ),
                ),
                keyboardType: TextInputType.number,
              )),
          const SizedBox(
            height: 10,
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
                      borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  hintText: 'Enter your Email',
                  hintStyle: TextStyle(
                    color: Color(0xFF000100),
                    fontSize: 15,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
              width: 300,
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20)),
              child: TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  hintText: 'Enter your Address',
                  hintStyle: TextStyle(
                    color: Color(0xFF000100),
                    fontSize: 15,
                  ),
                ),
                keyboardType: TextInputType.streetAddress,
              )),
          const SizedBox(
            height: 20,
          ),
          DropdownButton(
              value: cityName,
              hint: const Text("City"),
              items: Constants.cities
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Row(
                        children: [
                          Text(e),
                        ],
                      )))
                  .toList(),
              onChanged: (value) {
                cityName = value.toString();
                setState(() {});
              }),
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
                      borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  hintText: 'Enter your Password',
                  hintStyle: TextStyle(
                    color: Color(0xFF000100),
                    fontSize: 15,
                  ),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
              width: 300,
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20)),
              child: TextFormField(
                controller: confirmpassController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  hintText: 'Please Confirm your Password',
                  hintStyle: TextStyle(
                    color: Color(0xFF000100),
                    fontSize: 15,
                  ),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 100,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(
                          role: "Parent",
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                  width: 100,
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
                      "SignUp",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      signUp(emailController.text, passwordController.text,
                          "Parent");
                    },
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _adminSignupView() {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Register with us !",
            style: TextStyle(
                color: Color(0xFF000100),
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Your information is safe with us",
            style: TextStyle(
                color: Color(0xFF000100),
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 300,
            decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20)),
            child: TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.cyan),
                ),
                hintText: 'Enter your Name',
                hintStyle: TextStyle(
                  color: Color(0xFF000100),
                  fontSize: 15,
                ),
              ),
              controller: nameController,
              keyboardType: TextInputType.name,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 300,
            decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20)),
            child: TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.cyan),
                ),
                hintText: 'Enter your Address',
                hintStyle: TextStyle(
                  color: Color(0xFF000100),
                  fontSize: 15,
                ),
              ),
              controller: addressController,
              keyboardType: TextInputType.streetAddress,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 300,
            decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20)),
            child: TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.cyan),
                ),
                hintText: 'Enter your Mobile',
                hintStyle: TextStyle(
                  color: Color(0xFF000100),
                  fontSize: 15,
                ),
              ),
              controller: mobileController,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              width: 300,
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20)),
              child: TextFormField(
                controller: cnicController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  hintText: 'Enter your CNIC',
                  hintStyle: TextStyle(
                    color: Color(0xFF000100),
                    fontSize: 15,
                  ),
                ),
                keyboardType: TextInputType.number,
              )),
          const SizedBox(
            height: 10,
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
                      borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  hintText: 'Enter your Email',
                  hintStyle: TextStyle(
                    color: Color(0xFF000100),
                    fontSize: 15,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
              width: 300,
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20)),
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  hintText: 'Enter your Password',
                  hintStyle: TextStyle(
                    color: Color(0xFF000100),
                    fontSize: 15,
                  ),
                ),
                controller: passwordController,
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
              width: 300,
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20)),
              child: TextFormField(
                controller: confirmpassController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  hintText: 'Please Confirm your Password',
                  hintStyle: TextStyle(
                    color: Color(0xFF000100),
                    fontSize: 15,
                  ),
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          DropdownButton(
              value: cityName,
              hint: const Text("City"),
              items: Constants.cities
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Row(
                        children: [
                          Text(e),
                        ],
                      )))
                  .toList(),
              onChanged: (value) {
                cityName = value.toString();
                if (Constants.hospitals.containsKey(cityName)) {
                  for (var element in Constants.hospitals.entries) {
                    if (element.key == cityName) {
                      hospitals = element.value
                          .map((e) => e["name"] as String)
                          .toList();
                    }
                  }
                  hospitalName = hospitals.first;
                }
                setState(() {});
              }),
          hospitals.isNotEmpty
              ? DropdownButton(
                  value: hospitalName,
                  hint: const Text("Hospital"),
                  items: hospitals
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Row(
                            children: [
                              Text(e),
                            ],
                          )))
                      .toList(),
                  onChanged: (value) {
                    hospitalName = value.toString();
                    setState(() {});
                  })
              : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                  width: 100,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(
                            role: widget.role,
                          ),
                        ),
                      );
                    },
                  )),
              Container(
                  width: 100,
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
                      "SignUp",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      signUp(emailController.text, passwordController.text,
                          "Admin");
                    },
                  )),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                          image:
                              AssetImage('assets/images/comment-medical.png'))),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 700,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0x36489771),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: widget.role == "Admin"
                    ? _adminSignupView()
                    : _parentSignupView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password, String role) async {
    const CircularProgressIndicator();
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(email, role)});
    }
  }

  postDetailsToFirestore(String email, String role) async {
    var user = _auth.currentUser;
    if (user != null) {
      if (role == 'Parent') {
        CollectionReference ref =
            FirebaseFirestore.instance.collection('parent_info');
        ref.doc(user.uid).set({
          'name': nameController.text,
          'mobile': int.parse(mobileController.text),
          'cnic': cnicController.text,
          'address': addressController.text,
          'city': cityName
        });
      } else if (role == "Admin") {
        CollectionReference ref =
            FirebaseFirestore.instance.collection('admin_info');
        ref.doc(user.uid).set({
          'name': nameController.text,
          'mobile': int.parse(mobileController.text),
          'cnic': cnicController.text,
          'address': addressController.text,
          'hospital_city': cityName,
          'hospital_name': hospitalName,
        });
      }
      CollectionReference ref =
          FirebaseFirestore.instance.collection('user_roles');
      ref.doc(user.uid).set({'email': emailController.text, 'role': role});

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            role: role,
          ),
        ),
      );
    }
  }
}
