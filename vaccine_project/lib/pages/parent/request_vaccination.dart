import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_project/constants.dart';
import 'package:vaccine_project/pages/parent/parent.dart';

class RequestVaccination extends StatefulWidget {
  final Map<String, dynamic> child;
  final Map<String, dynamic> vaccine;
  const RequestVaccination({
    Key? key,
    required this.vaccine,
    required this.child,
  }) : super(key: key);

  @override
  State<RequestVaccination> createState() => _RequestVaccinationState();
}

class _RequestVaccinationState extends State<RequestVaccination> {
  String cityName = Constants.cities.first;
  String hospitalName = "";
  List<Map<String, dynamic>> hospitalsDetails = [];

  List<String> hospitals = [];
  _sendRequest() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('request').doc().set({
        'city_name': cityName,
        'hos_name': hospitalName,
        'status': "pending",
        'vaccine_name': widget.vaccine["name"],
        'vaccine_id': widget.vaccine["id"],
        'child_nic': widget.child["nic"],
        'child_name': "${widget.child["fname"]} ${widget.child["lname"]}",
        'child_gender': widget.child["gender"],
        'dob': widget.child["dob"],
        'parent': user.uid
      }).then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Request sended Successfully"),
              )));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Parent(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (Constants.hospitals.containsKey(cityName)) {
      for (var element in Constants.hospitals.entries) {
        if (element.key == cityName) {
          hospitals = element.value.map((e) => e["name"] as String).toList();
          hospitalsDetails = element.value.toList();
        }
      }
      hospitalName = hospitals.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
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
                        hospitalsDetails = element.value.toList();
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
            Visibility(
              visible: hospitalName.isNotEmpty,
              child: hospitalsDetails
                  .where((element) => element["name"] == hospitalName)
                  .map(
                    (e) => Column(
                      children: [
                        Row(
                          children: [
                            const Text("Hospital name "),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(e["name"].toString()),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Hospital Address "),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(e["hos_address"].toString()),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Hospital lic "),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(e["lic"].toString()),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Hospital days "),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(e["days"].toString()),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Hospital hours "),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(e["hours"].toString()),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _sendRequest();
                            },
                            child: const Text("Apply"))
                      ],
                    ),
                  )
                  .first,
            )
          ],
        ),
      ),
    );
  }
}
