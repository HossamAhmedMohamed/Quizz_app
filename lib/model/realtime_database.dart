// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iam_training/model/question_model.dart';

class DataBaseConnect {
  final url = Uri.parse(
      'https://todo-app-94ffa-default-rtdb.firebaseio.com/questions.json');

  Future<List<Question>> fetchQuestions() async {
    return http.get(url).then((response) {
      var data = json.decode(response.body) as Map<String, dynamic>;

      List<Question> newQuestions = [];

      data.forEach((key, value) {
        var newQuestion = Question(
            id: key,
            title: value['title'],
            options: Map.castFrom(value['options']));

        newQuestions.add(newQuestion);
      });

      return newQuestions;
    });
  }
}
