import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_project/pages/parent/vaccine_detail.dart';
import 'package:vaccine_project/widgets/create_child.dart';

class ParentHome extends StatefulWidget {
  const ParentHome({Key? key}) : super(key: key);

  @override
  State<ParentHome> createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController searchText = TextEditingController();
  String name = "";
  List<Map<String, dynamic>> children = [];
  List<Map<String, dynamic>> filteredChildren = [];

  @override
  void initState() {
    super.initState();
    if (user != null) {
      FirebaseFirestore.instance
          .collection('parent_info')
          .doc(user?.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.get('name') != null) {
            name = documentSnapshot.get('name');
          }
        }
      });
    }
    getChilds();
  }

  getChilds() {
    if (user != null) {
      FirebaseFirestore.instance
          .collection('children')
          .where("parent", isEqualTo: user!.uid)
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            children.add({...doc.data(), "child": doc.id});
          }
          filteredChildren = children;
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            width: 300,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 104, 99, 99),
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(-2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child: TextFormField(
              controller: searchText,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFFFFFFFF))),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.cyan),
                ),
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                hintStyle: TextStyle(
                  color: Color(0xFF000100),
                  fontSize: 15,
                ),
              ),
              onChanged: (value) => {
                if (value.isEmpty)
                  {
                    filteredChildren = children,
                  }
                else
                  {
                    filteredChildren = children
                        .where((element) {
                          if (element["fname"] != null &&
                                  (element["fname"] as String)
                                      .contains(searchText.text) ||
                              element["lname"] != null &&
                                  (element["lname"] as String)
                                      .contains(searchText.text) ||
                              element["gender"] != null &&
                                  (element["gender"] as String)
                                      .contains(searchText.text) ||
                              element["nic"] != null &&
                                  (element["nic"] as String)
                                      .contains(searchText.text) ||
                              element["dob"] != null &&
                                  (element["dob"] as String)
                                      .contains(searchText.text)) {
                            return true;
                          } else {
                            return false;
                          }
                        })
                        .map((e) => e)
                        .toList(),
                  },
                setState(() {}),
              },
              keyboardType: TextInputType.text,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          const Text(
            "Childrens Records",
            style: TextStyle(
                color: Color(0xFF000100),
                fontSize: 25,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: filteredChildren.isNotEmpty,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: children
                    .map(
                      (e) => Column(
                        children: [
                          Container(
                            height: 200,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Name : ",
                                      style: TextStyle(
                                          color: Color(0xFF000100),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                        (e["fname"] ?? "") + " " + e["lname"] ??
                                            ""),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Gender : ",
                                      style: TextStyle(
                                          color: Color(0xFF000100),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(e["gender"] ?? ""),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "DOB : ",
                                      style: TextStyle(
                                          color: Color(0xFF000100),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      e["dob"] != null
                                          ? "${e["dob"].toDate().day}/${e["dob"].toDate().month}/${e["dob"].toDate().year}"
                                          : "",
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "CNIC : ",
                                      style: TextStyle(
                                          color: Color(0xFF000100),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(e["nic"] ?? ""),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 150),
                                  child: Container(
                                    width: 100,
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
                                        "Details",
                                        style: TextStyle(
                                            color: Color(0xFFFFFFFF),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChildVaccineDetail(
                                              child: e,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 200,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateChild(),
                  ),
                );
              },
            ),
          ),
          // Visibility(
          //   visible: filteredChildren.isNotEmpty,
          //   child: SizedBox(
          //     width: MediaQuery.of(context).size.width,
          //     child: Column(
          //       children: children
          //           .map(
          //             (e) => InkWell(
          //               onTap: () {
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (context) => ChildVaccineDetail(
          //                       child: e,
          //                     ),
          //                   ),
          //                 );
          //               },
          //               child: Container(
          //                 height: 100,
          //                 width: 200,
          //                 decoration: BoxDecoration(
          //                   color: Colors.greenAccent,
          //                   borderRadius: BorderRadius.circular(20),
          //                 ),
          //                 child: Column(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     Text((e["fname"] ?? "") + " " + e["lname"] ?? ""),
          //                     Text(e["gender"] ?? ""),
          //                     Text(
          //                       e["dob"] != null
          //                           ? "${e["dob"].toDate().day}/${e["dob"].toDate().month}/${e["dob"].toDate().year}"
          //                           : "",
          //                     ),
          //                     Text(e["nic"] ?? ""),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           )
          //           .toList(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
