import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ParentSetting extends StatefulWidget {
  const ParentSetting({Key? key}) : super(key: key);

  @override
  State<ParentSetting> createState() => _ParentSettingState();
}

class _ParentSettingState extends State<ParentSetting> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  String profilePicLink = "";

  void pickUploadProfilePic() async {
    User? user = FirebaseAuth.instance.currentUser;
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );
    if (user != null) {
      Reference ref = FirebaseStorage.instance.ref().child("profilepic.jpg");

      await ref.putFile(File(image!.path));

      ref.getDownloadURL().then((value) async {
        if (value.isNotEmpty) {
          FirebaseFirestore.instance
              .collection("profile_pic")
              .doc(user.uid)
              .set({"profile_pic_url": value});
        }
        setState(() {
          profilePicLink = value;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('parent_info')
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          nameController.text = documentSnapshot.get('name') ?? "";
          addressController.text = documentSnapshot.get('address') ?? "";
          mobileController.text = "${documentSnapshot.get('mobile')} ";
          cnicController.text = "${documentSnapshot.get('cnic')} ";

          FirebaseFirestore.instance
              .collection('profile_pic')
              .doc(user.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              profilePicLink = "${documentSnapshot.get('profile_pic_url')} ";
              setState(() {});
            }
          });
          setState(() {});
        }
      });
    }
  }

  _update() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference ref =
          FirebaseFirestore.instance.collection('parent_info');
      ref.doc(user.uid).set({
        'name': nameController.text,
        'mobile': int.parse(mobileController.text),
        'cnic': cnicController.text,
        'address': addressController.text
      }).then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Updated Successfully"),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            pickUploadProfilePic();
          },
          child: Container(
            margin: const EdgeInsets.only(top: 80, bottom: 24),
            height: 120,
            width: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: profilePicLink.isEmpty
                  ? const Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 154, 140, 204),
                      size: 80,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(profilePicLink),
                    ),
            ),
          ),
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
              hintText: 'Enter Full Name',
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
              hintText: 'Enter your Mobile Number',
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
            controller: cnicController,
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
                "Update/Save",
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                _update();
              },
            ))
      ],
    );
  }
}
