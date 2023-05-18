import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'api.dart';
import 'package:http/http.dart' as http;

class ResultPage extends StatefulWidget {
  final File image;
  ResultPage({Key key, @required this.image}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ResultPageState(image);
}

class ResultPageState extends State<ResultPage> {
  String captions = "Refresh once!";
  var data;
  File image;
  FlutterTts ftts = FlutterTts();
  TextEditingController questionController = TextEditingController();
  String question = '';
  bool showQuestionField = false;
  String answer = '';

  ResultPageState(this.image);

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.yellow[800],
            Colors.yellow[700],
            Colors.yellow[600],
            Colors.yellow[400],
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Text(
                    "Captions",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: displayImage(image),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 100,
                  width: 200,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Text(
                    captions,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  child: Text("Refresh", style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    // getCaption();
                    setState(() {
                      showQuestionField = true;
                    });
                  },
                ),
                SizedBox(width: 25,),
            ElevatedButton(
              child: Text("Audio",style: TextStyle(color: Colors.black,),),
              // elevation: 5.0,
              //color: Colors.white,
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: () => speakCaption(),
            ), 

                if (showQuestionField) ...[
                  SizedBox(height: 20,),
                  Container(
                    width: 250,
                    child: TextField(
                      controller: questionController,
                      decoration: InputDecoration(
                        hintText: 'Enter a question',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          question = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
  child: Text("Get Answer", style: TextStyle(color: Colors.black)),
  onPressed: () async {
    String answer = await getAnswer(captions, question);
    setState(() {
      this.answer = answer;
    });
  },
),
                  SizedBox(height: 20,),
                  Text(
                    answer,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future getCaption() async {
    data = await getData(uploadUrl);

    setState(() {
      captions = data['captions'];
    });
 

  }

  speakCaption() async {
    await ftts.setLanguage("en-US");
    await ftts.setPitch(1);
    await ftts.speak(captions);
  }

  Widget displayImage(File file) {
    return SizedBox(
      height: 250.0,
      width: 200.0,
      child: file == null ? Container() : Image.file(file),
    );
  }
}