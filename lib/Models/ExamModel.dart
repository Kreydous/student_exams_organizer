import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class ExamModel {
  final String id;
  final String SubjectName;
  final DateTime ExamDate;
  final String ExamTime;
  final String username;
  final Marker? marker;
  ExamModel(this.id, this.SubjectName, this.ExamDate, this.ExamTime,
      this.username, this.marker);
}
