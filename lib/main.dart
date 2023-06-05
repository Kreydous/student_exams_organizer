// ignore_for_file: use_key_in_widget_constructors, import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
//import 'package:proj4dart/proj4dart.dart';
import 'package:student_exams_organizer/AddExam.dart';
import 'package:student_exams_organizer/ListExams.dart';
import 'package:student_exams_organizer/LogIn.dart';
import 'package:student_exams_organizer/MapWidget.dart';
import 'package:student_exams_organizer/Models/ExamModel.dart';
import 'package:intl/intl.dart';
import 'package:student_exams_organizer/Models/UserModel.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main(List<String> args) {
  AwesomeNotifications().initialize(
    null, // icon for your app notification
    [
      NotificationChannel(
          channelKey: 'key1',
          channelName: 'Proto Coders Point',
          channelDescription: "Notification example",
          defaultColor: Color(0XFF9050DD),
          ledColor: Colors.white,
          playSound: true,
          enableLights: true,
          enableVibration: true)
    ],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Student Exam Organizer",
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                  fontFamily: "TimesRoman",
                  fontWeight: FontWeight.normal,
                  fontSize: 20),
            ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Marker> markers = [
    Marker(),
  ];
  List<Marker> filteredMarkers = [Marker()];
  List<ExamModel> listExams = [
    ExamModel("1", "Subject1", DateTime.now(), "8:45", "testuser1", null),
    ExamModel("2", "Subject2", DateTime.now(), "9:50", "testuser1", null),
    ExamModel("3", "Subject3", DateTime.now(), "15:05", "testuser1", null),
    ExamModel("4", "Subject4", DateTime.now(), "18:45", "testuser2", null),
    ExamModel("5", "Subject5", DateTime.now(), "20:15", "testuser2", null),
  ];

  List<UserModel> users = [
    UserModel("1", "testuser1", "TestName", "testpass"),
    UserModel("2", "testuser2", "Test2", "testpass")
  ];
  UserModel user = UserModel("", "", "", "");
  List<ExamModel> filteredListExams = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.checkIfLogedIn(context);
    });
  }

  void Notify(ExamModel exam) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: 'key1',
            title: 'You have added: ${exam.SubjectName} to your list',
            body:
                'You have added an exam on date: ${exam.ExamDate.toString()} time:${exam.ExamTime} for subject ${exam.SubjectName} }'));
  }

  void addExamFunction(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: AddExam(addExam, user.username, markers),
              behavior: HitTestBehavior.opaque);
        });
  }

  void deleteExam(String id) {
    setState(() {
      markers
          .remove(listExams.where((element) => element.id == id).first.marker);
      listExams.removeWhere((element) => element.id == id);
      filteredListExams = listExams
          .where((element) => element.username == user.username)
          .toList();
      filteredMarkers = [Marker()];
      for (ExamModel e in filteredListExams) {
        if (e.marker != null) {
          filteredMarkers.add(e.marker!);
        }
      }
    });
  }

  void addExam(ExamModel exam) {
    setState(() {
      listExams.add(exam);
      //markers.add(exam.marker!);
      filteredListExams = listExams
          .where((element) => element.username == user.username)
          .toList();
      filteredMarkers = [Marker()];
      for (ExamModel e in filteredListExams) {
        if (e.marker != null) {
          filteredMarkers.add(e.marker!);
        }
      }
    });
    Notify(exam);
  }

  void checkIfLogedIn(BuildContext ct) {
    if (user == null || user.id == "") {
      showModalBottomSheet(
          context: ct,
          builder: (_) {
            return GestureDetector(
                onTap: () {},
                child: LogIn(LogInFunction, users),
                behavior: HitTestBehavior.opaque);
          });
    } else {
      setState(() {
        filteredListExams = listExams
            .where((element) => element.username == user.username)
            .toList();
        filteredMarkers = [Marker()];
        for (ExamModel e in filteredListExams) {
          if (e.marker != null) {
            filteredMarkers.add(e.marker!);
          }
        }
      });
    }
  }

  void LogInFunction(String username, String password) {
    user = users
        .where((element) =>
            element.username == username && element.password == password)
        .first;
    checkIfLogedIn(context);
  }

  void Logout() {
    user = UserModel("", "", "", "");
    checkIfLogedIn(context);
  }

  void ShowMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MapWidget(AddMarker, filteredMarkers)),
    );
  }

  void AddMarker(LatLng latLng) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student exam organizer"), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => addExamFunction(context),
        ),
        IconButton(onPressed: Logout, icon: Icon(Icons.logout)),
        IconButton(onPressed: ShowMap, icon: Icon(Icons.map)),
      ]),
      body: ListExams(filteredListExams, deleteExam),
    );
  }
}
