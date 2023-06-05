// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:student_exams_organizer/Models/ExamModel.dart';

class ListExams extends StatelessWidget {
  final List<ExamModel> listOfExams;
  final Function deleteFunction;
  ListExams(this.listOfExams, this.deleteFunction);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: listOfExams.isEmpty
          ? Text("Yay! You don't have any exams")
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  child: ListTile(
                    title: Text(listOfExams[index].SubjectName),
                    subtitle: Text(
                        "${listOfExams[index].ExamDate.day.toString()} - ${listOfExams[index].ExamDate.month.toString()} - ${listOfExams[index].ExamDate.year.toString()} ${listOfExams[index].ExamTime}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteFunction(listOfExams[index].id),
                    ),
                  ),
                );
              },
              itemCount: listOfExams.length,
            ),
    );
  }
}
