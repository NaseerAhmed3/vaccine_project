import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_project/constants.dart';
import 'package:vaccine_project/pages/parent/parent.dart';

class CreateChild extends StatefulWidget {
  const CreateChild({Key? key}) : super(key: key);

  @override
  State<CreateChild> createState() => _CreateChildState();
}

class _CreateChildState extends State<CreateChild> {
  final TextEditingController fnameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();
  String? gender;
  create() {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('children').add({
        "fname": fnameController.text,
        "dob": dobController.text.isNotEmpty
            ? DateTime.parse(dobController.text)
            : "",
        "gender": gender,
        "nic": nicController.text,
        "lname": lnameController.text,
        "parent": user.uid
      });

      _insertDueVaccines();
    }
  }

  _insertDueVaccines() {
    List<Map<String, dynamic>> dueVaccines =
        Vaccine.getDueVaccines(dobController.text);
    if (dueVaccines.isNotEmpty) {
      for (var vaccine in dueVaccines) {
        FirebaseFirestore.instance.collection('vaccines').doc().set({
          'name': vaccine["name"],
          'id': vaccine["id"],
          'month': vaccine["month"],
          'status': 'due',
          'child_nic': nicController.text,
        });
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Parent(),
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
  }

  _dob() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      pickedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );
    }

    dobController.text = pickedDate.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor: Color(0xFF2FB176),
        title: const Text(
          "Add Child",
          style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
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
                hintText: 'Enter your First Name',
                hintStyle: TextStyle(
                  color: Color(0xFF000100),
                  fontSize: 15,
                ),
              ),
              controller: fnameController,
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
                hintText: 'Enter Last Name ',
                hintStyle: TextStyle(
                  color: Color(0xFF000100),
                  fontSize: 15,
                ),
              ),
              controller: lnameController,
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
                  prefixIcon: Icon(
                    Icons.calendar_today,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  hintText: 'Select Date of Birth',
                  hintStyle: TextStyle(
                    color: Color(0xFF000100),
                    fontSize: 15,
                  ),
                ),
                controller: dobController,
                onTap: () {
                  _dob();
                }),
          ),
          RadioListTile(
            title: const Text("Male"),
            value: "male",
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text("Female"),
            value: "female",
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value.toString();
              });
            },
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
                hintText: 'Enter your CNIC',
                hintStyle: TextStyle(
                  color: Color(0xFF000100),
                  fontSize: 15,
                ),
              ),
              controller: nicController,
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 200,
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
                "Create Child",
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                create();
              },
            ),
          ),
        ]),
      ),
    );
  }
}
