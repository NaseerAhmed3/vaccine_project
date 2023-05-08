import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestInfo extends StatefulWidget {
  const RequestInfo({Key? key}) : super(key: key);

  @override
  State<RequestInfo> createState() => _RequestInfoState();
}

class _RequestInfoState extends State<RequestInfo> {
  List<Map<String, dynamic>> requestStatus = [];
  List<Map<String, dynamic>> childrenData = [];

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseFirestore.instance
          .collection('request')
          .where("parent", isEqualTo: user.uid)
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> newSnapshot) {
        if (newSnapshot.docs.isNotEmpty) {
          for (var docs in newSnapshot.docs) {
            requestStatus.add(docs.data());
          }
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Request panel"),
        Visibility(
            visible: requestStatus.isNotEmpty &&
                requestStatus.any((element) => element["status"] == "approved"),
            child: Column(
              children: [
                ...requestStatus
                    .where((element) => element["status"] == "approved")
                    .map((e) => Column(
                          children: [
                            const Text("sdf"),
                            Row(
                              children: [
                                Text(e["child_name"] ?? ""),
                                Container(
                                  width: 20,
                                  color: Colors.green,
                                  child: const Text(" "),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Vccine name"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(e["vaccine_name"] ?? ""),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Date to visit"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  e["date"] != null
                                      ? "${e["date"].toDate().day}/${e["date"].toDate().month}/${e["date"].toDate().year}"
                                      : "------------",
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Details"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(e["detail"] ?? ""),
                              ],
                            ),
                          ],
                        ))
                    .toList()
              ],
            )),
        const SizedBox(
          height: 40,
        ),
        Visibility(
            visible: requestStatus.isNotEmpty &&
                requestStatus.any((element) => element["status"] == "rejected"),
            child: Column(
              children: [
                ...requestStatus
                    .where((element) => element["status"] == "rejected")
                    .map((e) => Column(
                          children: [
                            Row(
                              children: [
                                Text(e["child_name"] ?? ""),
                                Container(
                                  width: 20,
                                  color: Colors.red,
                                  child: const Text("  "),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Vccine name"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(e["vaccine_name"] ?? ""),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Date to visit"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  e["date"] != null
                                      ? "${e["date"].toDate().day}/${e["date"].toDate().month}/${e["date"].toDate().year}"
                                      : "------------",
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Details"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(e["detail"] ?? ""),
                              ],
                            ),
                          ],
                        ))
                    .toList()
              ],
            ))
      ],
    );
  }
}
