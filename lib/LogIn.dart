import 'package:flutter/material.dart';
import 'package:student_exams_organizer/Models/UserModel.dart';

class LogIn extends StatefulWidget {
  final Function logInFunction;
  final List<UserModel> users;
  LogIn(this.logInFunction, this.users);

  @override
  State<StatefulWidget> createState() => LogInState();
}

class LogInState extends State<LogIn> {
  final usernameValue = TextEditingController();
  final passwordValue = TextEditingController();

  void LogIn() {
    var usernameTxt = usernameValue.text;
    var passTxt = passwordValue.text;
    if (usernameTxt.isEmpty || passTxt.isEmpty) {
      return;
    }
    widget.logInFunction(usernameTxt, passTxt);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: usernameValue,
            decoration: InputDecoration(labelText: "Username"),
            onSubmitted: (value) => LogIn(),
          ),
          TextField(
            controller: passwordValue,
            decoration: InputDecoration(labelText: "Password"),
            onSubmitted: (value) => LogIn(),
          ),
          TextButton(
            onPressed: LogIn,
            child: Text(
              "Log in",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
