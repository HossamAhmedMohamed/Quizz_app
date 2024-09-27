// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_import, prefer_const_literals_to_create_immutables, unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iam_training/constants/colors.dart';
import 'package:iam_training/constants/strings.dart';
import 'package:iam_training/logic/auth_cubit/auth_cubit.dart';
import 'package:iam_training/model/question_model.dart';
import 'package:iam_training/model/realtime_database.dart';
import 'package:iam_training/presentation/widgets/next_button.dart';
import 'package:iam_training/presentation/widgets/options_card.dart';
import 'package:iam_training/presentation/widgets/previous_button.dart';
import 'package:iam_training/presentation/widgets/question_widget.dart';
import 'package:iam_training/presentation/widgets/result_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<Question> questions = [];

  int index = 0;
  int score = 0;
  int count = 0;
  int selectedOptionIndex = 0;

  bool isPressed = false;
  bool isAlreadySelected = false;
  List<int?> selectedAnswers = [];

  var db = DataBaseConnect();

  late Future<List<Question>> questionsss;

  Future<List<Question>> getQuestions() async {
    return db.fetchQuestions();
  }

  void restartQuiz() {
    setState(() {
      index = 0;
      score = 0;
      count = 0;
      isPressed = false;
      isAlreadySelected = false;
      selectedAnswers = List<int?>.filled(selectedAnswers.length, null);
    });
    Navigator.pop(context);
  }

  void checkAnswerAndUpdate(bool value, int selectedIndex) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        count++;
        score += 10;
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
        selectedOptionIndex = selectedIndex;
        selectedAnswers[index] = selectedIndex;
      });
    }
  }

  void nextQuestion(int questionsLength) {
    if (index == questionsLength - 1) {
      return;
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = selectedAnswers[index] != null;
          isAlreadySelected = selectedAnswers[index] != null;
          selectedOptionIndex = selectedAnswers[index] ?? -1;

        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please select any option"),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  void backQuestion() {
    if (index == 0) {
      return;
    } else {
      setState(() {
        index--;
        isPressed = selectedAnswers[index] != null;
        selectedOptionIndex = selectedAnswers[index] ?? -1; // استرجاع الإجابة
        isAlreadySelected = selectedAnswers[index] != null;
      });
    }
  }

  Widget buildScore() {
    return Align(
      alignment: Alignment.topRight,
      child: Text(
        'Score: $score',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget buildResultButton(int questionsLength) {
    return ElevatedButton(
      onPressed: () => showDialog(
          context: context,
            barrierDismissible: true,
          builder: (ctx) => ResultBox(
                result: score,
                questionLength: questionsLength,
                count: count,
                restartQuiz: restartQuiz,
              )),
      style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          backgroundColor: natural,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      child: Text(
        "Show Result",
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget buildDoubleButtons(int questionsLength) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PreviousButton(backQuestion: backQuestion),
        SizedBox(
          width: MediaQuery.of(context).size.width / 25,
          // width: 8,
        ),
        GestureDetector(
            onTap: () => nextQuestion(questionsLength), child: NextButton()),
      ],
    );
  }

  @override
  void initState() {
    questionsss = getQuestions().then((questions) {
      selectedAnswers =
          List<int?>.filled(questions.length, null); // تهيئة قائمة الإجابات
      return questions;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: questionsss as Future<List<Question>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var extractedData = snapshot.data as List<Question>;
            // questionsLength = extractedData.length;
            return SafeArea(
                child: Scaffold(
              backgroundColor: background,
              body: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 20,
                  vertical: MediaQuery.of(context).size.height / 25,
                ),
                child: Column(
                  children: [
                    QuestionWidget(
                        question: extractedData[index].title,
                        index: index,
                        totalQuestions: extractedData.length),
                    Divider(
                      color: natural,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    for (int i = 0;
                        i < extractedData[index].options.length;
                        i++)
                      GestureDetector(
                        onTap: () => checkAnswerAndUpdate(
                            extractedData[index].options.values.toList()[i], i),
                        child: OptionsCard(
                          options:
                              extractedData[index].options.keys.toList()[i],
                          color: isPressed
                              ? (i == selectedOptionIndex
                                  ? (extractedData[index]
                                              .options
                                              .values
                                              .toList()[i] ==
                                          true
                                      ? correct
                                      : inCorrect)
                                  : (extractedData[index]
                                              .options
                                              .values
                                              .toList()[i] ==
                                          true
                                      ? correct
                                      : natural))
                              : natural,
                        ),
                      ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                    ),
                    index == 0
                        ? GestureDetector(
                            onTap: () => nextQuestion(extractedData.length),
                            child: NextButton())
                        : index == extractedData.length - 1
                            ? buildResultButton(extractedData.length)
                            : buildDoubleButtons(extractedData.length)
                  ],
                ),
              ),
              // floatingActionButton: index == 0
              //     ? GestureDetector(
              //         onTap: () => nextQuestion(extractedData.length),
              //         child: const Padding(
              //           padding: EdgeInsets.symmetric(horizontal: 10.0),
              //           child: NextButton(// the above function
              //               ),
              //         ),
              //       )
              //     : index == extractedData.length - 1
              //         ? buildResultButton(extractedData.length)
              //         : buildDoubleButtons(extractedData.length),
              // floatingActionButtonLocation:
              //     FloatingActionButtonLocation.centerFloat,
            ));
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: Text('No data'),
        );
      },
    );
  }
}
