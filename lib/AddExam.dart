// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:student_exams_organizer/Models/ExamModel.dart';
import 'package:nanoid/nanoid.dart';
import 'package:intl/intl.dart';
import 'package:student_exams_organizer/MapWidget.dart';

class AddExam extends StatefulWidget {
  final Function addExam;
  final String username;
  final List<Marker> markers;
  AddExam(this.addExam, this.username, this.markers);
  @override
  State<StatefulWidget> createState() => AddExamState();
}

class AddExamState extends State<AddExam> {
  final subjectNameController = TextEditingController();
  final examDateController = TextEditingController();
  final examTimeController = TextEditingController();
  Marker marker = Marker();
  void submitData() {
    if (subjectNameController.text.isEmpty ||
        examDateController.text.isEmpty ||
        examTimeController.text.isEmpty) {
      return;
    }
    final subjName = subjectNameController.text;
    final examDateString = examDateController.text;
    final examTimeString = examTimeController.text;
    DateFormat formatter = new DateFormat("dd-MM-yyyy");
    var examDate = formatter.parse(examDateString);
    ExamModel exam = new ExamModel(
        nanoid(3), subjName, examDate, examTimeString, widget.username, marker);
    widget.addExam(exam);
    Navigator.of(context).pop();
  }

  void ShowMap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapWidget(AddMarker, [Marker()])),
    );
  }

  void AddMarker(LatLng point) {
    marker = Marker(
      width: 80.0,
      height: 80.0,
      point: point,
      builder: (ctx) => Container(
        child: Icon(
          Icons.location_on,
          color: Colors.red,
        ),
      ),
    );
    print("Closing maps");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: subjectNameController,
            decoration: InputDecoration(labelText: "Subject name"),
            onSubmitted: (_) => submitData(),
          ),
          TextField(
            controller: examDateController,
            decoration: InputDecoration(
              icon: Icon(Icons.calendar_today),
              labelText: "Exam date",
            ),
            readOnly: true,
            onTap: () async {
              DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100));
              if (date != null) {
                DateFormat formatter = new DateFormat("dd-MM-yyyy");
                String formattedDate = formatter.format(date);
                setState(() {
                  examDateController.text = formattedDate;
                });
              }
            },
            onSubmitted: (_) => submitData(),
          ),
          TextField(
            controller: examTimeController,
            decoration: InputDecoration(
              icon: Icon(Icons.timelapse),
              labelText: "Exam time",
            ),
            readOnly: true,
            onTap: () async {
              TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: 08, minute: 00),
              );
              if (time != null) {
                String txtTime =
                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                setState(() {
                  examTimeController.text = txtTime;
                });
              }
            },
          ),
          IconButton(onPressed: ShowMap, icon: Icon(Icons.map)),
          TextButton(
            onPressed: submitData,
            child: Text(
              "+ Add exam",
              style: TextStyle(fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}
