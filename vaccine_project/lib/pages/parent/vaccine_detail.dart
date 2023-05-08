import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_project/constants.dart';
import 'package:vaccine_project/pages/parent/request_vaccination.dart';

class ChildVaccineDetail extends StatefulWidget {
  final Map<String, dynamic> child;
  const ChildVaccineDetail({Key? key, required this.child}) : super(key: key);

  @override
  State<ChildVaccineDetail> createState() => _ChildVaccineDetailState();
}

class _ChildVaccineDetailState extends State<ChildVaccineDetail> {
  List<Map<String, dynamic>> vaccinesRecord = [];
  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('vaccines')
        .where("child_nic", isEqualTo: widget.child["nic"])
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> newSnapshot) {
      if (newSnapshot.docs.isNotEmpty) {
        for (var docs in newSnapshot.docs) {
          vaccinesRecord.add(docs.data());
        }
        // vaccinesRecord.sort((a, b) => a["id"] - (b["id"]));
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Parent",
            style: TextStyle(
              color: Color(0xff2FB176),
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Name"),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                      "${widget.child["fname"] ?? ""}${widget.child["lname"] ?? ""}"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Gender"),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(widget.child["gender"] ?? ""),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("DoB"),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.child["dob"] != null
                        ? "${widget.child["dob"].toDate().day}/${widget.child["dob"].toDate().month}/${widget.child["dob"].toDate().year}"
                        : "",
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Nic"),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(widget.child["nic"] ?? ""),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Age"),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    Constants.age(
                      widget.child["dob"].toDate(),
                    ),
                  ),
                ],
              ),
              Container(
                height: 2,
                width: 300,
                color: Colors.grey,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 200),
                child: Text(
                  "Due Vaccine",
                  style: TextStyle(
                    color: Color(0xFF000100),
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                  visible: vaccinesRecord.isNotEmpty &&
                      vaccinesRecord
                          .any((element) => element["status"] == "due"),
                  child: Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Color(0xf982FD2D2D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text("Due Date"),
                            ...vaccinesRecord
                                .where((element) => element["status"] == "due")
                                .map((e) => Column(
                                      children: [
                                        Text("Vaccine ${e["id"] ?? ""}"),
                                        Text("${e["name"] ?? ""}"),
                                        Text(
                                          e["date"] != null
                                              ? "Date ${e["date"].toDate().day}/${e["date"].toDate().month}/${e["date"].toDate().year}"
                                              : "",
                                        )
                                      ],
                                    ))
                                .toList()
                          ],
                        ),
                        Icon(Icons.arrow_right)
                      ],
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 200),
                child: Text(
                  "Upcoming Vaccine",
                  style: TextStyle(
                    color: Color(0xFF000100),
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: vaccinesRecord.isNotEmpty &&
                    vaccinesRecord
                        .any((element) => element["status"] == "upcoming"),
                child: Container(
                  width: 350,
                  decoration: BoxDecoration(
                    color: Color(0xf982FD2D2D),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text("Upcoming"),
                          ...vaccinesRecord
                              .where(
                                  (element) => element["status"] == "upcoming")
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RequestVaccination(
                                            child: widget.child,
                                            vaccine: e,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text("Vaccine ${e["id"] ?? ""}"),
                                          Text("${e["name"] ?? ""}"),
                                          Text(
                                            e["date"] != null
                                                ? "Date ${e["date"].toDate().day}/${e["date"].toDate().month}/${e["date"].toDate().year}"
                                                : "",
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList()
                        ],
                      ),
                      Icon(Icons.arrow_right),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 200),
                child: Text(
                  "Past Vaccine",
                  style: TextStyle(
                    color: Color(0xFF000100),
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Visibility(
              //   visible: vaccinesRecord.isNotEmpty &&
              //       vaccinesRecord
              //           .any((element) => element["status"] == "done"),
              //   child: Container(
              //     color: Colors.purple,
              //     child: Column(
              //       children: [
              //         const Text("Past Records"),
              //         ...vaccinesRecord
              //             .where((element) => element["status"] == "done")
              //             .map((e) => Column(
              //                   children: [
              //                     Text("Vaccine ${e["id"] ?? ""}"),
              //                     Text("${e["name"] ?? ""}"),
              //                     Text(
              //                       e["date"] != null
              //                           ? "Date ${e["date"].toDate().day}/${e["date"].toDate().month}/${e["date"].toDate().year}"
              //                           : "",
              //                     )
              //                   ],
              //                 ))
              //             .toList()
              //       ],
              //     ),
              //   ),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => RequestVaccination(child: widget.child),
              //       ),
              //     );
              //   },
              //   child: const Text("Request Vaccination"),
              // ),
              Visibility(
                visible: vaccinesRecord.isNotEmpty &&
                    vaccinesRecord
                        .any((element) => element["status"] == "done"),
                child: GestureDetector(
                  child: Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Color(0xf982FD2D2D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text("Past Records"),
                            ...vaccinesRecord
                                .where((element) => element["status"] == "done")
                                .map((e) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text("Vaccine ${e["id"] ?? ""}"),
                                          Text("${e["name"] ?? ""}"),
                                          Text(
                                            e["date"] != null
                                                ? "Date ${e["date"].toDate().day}/${e["date"].toDate().month}/${e["date"].toDate().year}"
                                                : "",
                                          )
                                        ],
                                      ),
                                    ))
                                .toList()
                          ],
                        ),
                        Icon(Icons.arrow_right),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
