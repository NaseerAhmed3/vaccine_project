import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_project/constants.dart';

class ChildVaccineDetailAdmin extends StatefulWidget {
  final Map<String, dynamic> child;
  const ChildVaccineDetailAdmin({Key? key, required this.child})
      : super(key: key);

  @override
  State<ChildVaccineDetailAdmin> createState() =>
      _ChildVaccineDetailAdminState();
}

class _ChildVaccineDetailAdminState extends State<ChildVaccineDetailAdmin> {
  List<Map<String, dynamic>> vaccinesRecord = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? status;
  String? gender;
  QuerySnapshot<Map<String, dynamic>>? snapshot;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  _initialize() {
    dateController.text = "";
    idController.text = "";
    nameController.text = "";
    vaccinesRecord = [];
    FirebaseFirestore.instance
        .collection('vaccines')
        .where("child_nic", isEqualTo: widget.child["nic"])
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> newSnapshot) {
      if (newSnapshot.docs.isNotEmpty) {
        for (var docs in newSnapshot.docs) {
          vaccinesRecord.add(
            docs.data(),
          );
        }
        snapshot = newSnapshot;
        setState(() {});
      }
    });
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

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  _createVaccine() {
    FirebaseFirestore.instance.collection('vaccines').doc().set({
      'name': nameController.text,
      'id': idController.text,
      'status': calculateDifference(DateTime.parse(dateController.text)) < 0
          ? 'due'
          : 'upcoming',
      'child_nic': widget.child["nic"],
      'date': dateController.text.isNotEmpty
          ? DateTime.parse(dateController.text)
          : DateTime.now(),
    }).then((value) => {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("New Vaccine added successfully"),
          )),
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const Admin(),
          //   ),
          // )
          _initialize(),
          Navigator.pop(context)
        });
  }

  _updateVaccine(Map<String, dynamic> map) {
    if (snapshot != null && snapshot!.docs.isNotEmpty) {
      if (snapshot!.docs.any((element) => element["id"] == map["id"])) {
        FirebaseFirestore.instance
            .collection('vaccines')
            .doc(snapshot!.docs
                .where((element) => element["id"] == map["id"])
                .first
                .id)
            .set({
          'name': map["name"],
          'id': map["id"],
          'status': "done",
          'child_nic': widget.child["nic"],
          'date': dateController.text.isNotEmpty
              ? DateTime.parse(dateController.text)
              : DateTime.now(),
        }).then((value) => {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("vaccine Completed successfully"),
                  )),
                  _initialize(),
                  Navigator.pop(context)
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const Admin(),
                  //   ),
                  // )
                });
      }
    }
  }

  _addNewVaccineBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            const Text(
              "Add new vaccine",
              style: TextStyle(
                  color: Color.fromARGB(255, 12, 11, 11),
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
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
                  hintText: 'Enter your ID',
                  hintStyle: TextStyle(
                    color: Color(0xFF000100),
                    fontSize: 15,
                  ),
                ),
                controller: idController,
                keyboardType: TextInputType.streetAddress,
              ),
            ),
            SizedBox(
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
                keyboardType: TextInputType.streetAddress,
              ),
            ),
            SizedBox(
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
                    hintText: 'Date',
                    prefixIcon: Icon(Icons.calendar_today),
                    hintStyle: TextStyle(
                      color: Color(0xFF000100),
                      fontSize: 15,
                    ),
                  ),
                  controller: dateController,
                  onTap: () {
                    _date();
                  }),
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
                  "Proceed",
                  style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
                onPressed: () {
                  _createVaccine();
                },
              ),
            )
          ],
        );
      },
    );
  }

  _vaccineStatusBottomSheet(Map<String, dynamic> map) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            Text("Vaccine ${map["id"] ?? ""}"),
            Text(" ${map["name"] ?? ""}"),
            const Text("Completed"),
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
            ElevatedButton(
                onPressed: () {
                  _updateVaccine(map);
                },
                child: const Text("Proceed"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Admin"),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Name"),
                          Text(
                              "${widget.child["fname"] ?? ""}${widget.child["lname"] ?? ""}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Gender"),
                          Text(widget.child["gender"] ?? ""),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("DoB"),
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
                          Text(widget.child["nic"] ?? ""),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Age"),
                          Text(
                            Constants.age(
                              widget.child["dob"].toDate(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                child: Container(
                  width: 150,
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
                      "Add Vaccination",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      _addNewVaccineBottomSheet();
                    },
                  ),
                ),
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
                                .map((e) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          _vaccineStatusBottomSheet(e);
                                        },
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
                                      _vaccineStatusBottomSheet(e);
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
