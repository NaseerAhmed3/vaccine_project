import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_project/constants.dart';

class RequestApprovel extends StatefulWidget {
  const RequestApprovel({
    Key? key,
  }) : super(key: key);

  @override
  State<RequestApprovel> createState() => _RequestApprovelState();
}

class _RequestApprovelState extends State<RequestApprovel> {
  List<Map<String, dynamic>> allPendingRequests = [];
  List<Map<String, dynamic>> vaccines = [];

  _updateRequestStatus(
      String status, String date, String detail, Map<String, dynamic> map) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('request').doc().set({
        'city_name': map["city_name"],
        'hos_name': map["hos_name"],
        'status': status,
        'child_nic': map["child_nic"],
        'child_name': map["child_name"],
        'child_gender': map["child_gender"],
        'dob': map["dob"],
        'vaccine_name': map["vaccine_name"],
        'vaccine_id': map["vaccine_id"],
        'date': date.isNotEmpty ? DateTime.parse(date) : DateTime.now(),
        'parent': map["parent"],
        'detail': detail
      }).then((value) {
        FirebaseFirestore.instance
            .collection('request')
            .doc(map["id"])
            .delete()
            .then((value) {
          _initalize();

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Request sended Successfully"),
          ));
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initalize();
  }

  _initalize() {
    allPendingRequests = [];
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseFirestore.instance
          .collection('request')
          .where("status", isEqualTo: "pending")
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> newSnapshot) {
        if (newSnapshot.docs.isNotEmpty) {
          for (var docs in newSnapshot.docs) {
            allPendingRequests.add({
              ...docs.data(),
              "id": docs.id,
            });
          }
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Visibility(
          visible: allPendingRequests.isNotEmpty,
          child: Column(
            children: [
              ...allPendingRequests
                  .map((request) => Column(
                        children: [
                          OnePersonRequest(
                              onChange: (String status, String date,
                                  String detail, Map<String, dynamic> map) {
                                _updateRequestStatus(status, date, detail, map);
                              },
                              request: request)
                        ],
                      ))
                  .toList()
            ],
          )),
    );
  }
}

class OnePersonRequest extends StatefulWidget {
  final Function onChange;
  final Map<String, dynamic> request;

  const OnePersonRequest({
    Key? key,
    required this.onChange,
    required this.request,
  }) : super(key: key);

  @override
  State<OnePersonRequest> createState() => _OnePersonRequestState();
}

class _OnePersonRequestState extends State<OnePersonRequest> {
  final TextEditingController dateController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  String status = "";
  @override
  void initState() {
    super.initState();
  }

  _date() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2901),
    );
    if (context.mounted) {}
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedDate != null) {
      if (pickedTime != null) {
        pickedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }

    dateController.text = pickedDate.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text("Vaccine name"),
            const SizedBox(
              width: 10,
            ),
            Text(widget.request["vaccine_name"]),
          ],
        ),
        Row(
          children: [
            const Text("Name"),
            const SizedBox(
              width: 10,
            ),
            Text(widget.request["child_name"]
                // "${widget.child["fname"] ?? ""} ${widget.child["lname"] ?? ""}"),
                )
          ],
        ),
        Row(
          children: [
            const Text("Nic"),
            const SizedBox(
              width: 10,
            ),
            Text(widget.request["child_nic"] ?? ""),
          ],
        ),
        Row(
          children: [
            const Text("Gender"),
            const SizedBox(
              width: 10,
            ),
            Text(widget.request["child_gender"])
          ],
        ),
        Row(
          children: [
            const Text("Age"),
            const SizedBox(
              width: 10,
            ),
            Text(
              Constants.age(
                widget.request["dob"].toDate(),
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            status = "rejected";
          },
          child: const Text("Decline"),
        ),
        ElevatedButton(
          onPressed: () {
            status = "approved";
          },
          child: const Text("Approve"),
        ),
        TextFormField(
            controller: dateController,
            decoration: const InputDecoration(
              hintText: 'Date',
              prefixIcon: Icon(
                Icons.calendar_today,
              ),
              label: Text("Date"),
            ),
            onTap: () {
              _date();
            }),
        TextField(
          decoration: const InputDecoration(hintText: "Detail"),
          maxLines: 5,
          controller: detailController,
        ),
        ElevatedButton(
            onPressed: () {
              widget.onChange(
                status,
                dateController.text,
                detailController.text,
                widget.request,
              );
            },
            child: const Text("Proceed"))
      ],
    );
  }
}
