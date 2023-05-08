import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_project/pages/admin/child_vaccine_detail_Admin.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController searchText = TextEditingController();
  String name = "";
  List<Map<String, dynamic>> children = [];
  List<Map<String, dynamic>> filteredChildren = [];

  @override
  void initState() {
    super.initState();

    getChilds();
  }

  getChilds() {
    if (user != null) {
      FirebaseFirestore.instance
          .collection('children')
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            children.add({
              ...doc.data(),
            });
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
                      (e) => InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChildVaccineDetailAdmin(
                                child: e,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Color(0xf52FB176),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 104, 99, 99),
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(-2.0,
                                        2.0), // shadow direction: bottom right
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text((e["fname"] ?? "") +
                                                " " +
                                                e["lname"] ??
                                            ""),
                                        Text(e["nic"] ?? ""),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.arrow_right)
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
