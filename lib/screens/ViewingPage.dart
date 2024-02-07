import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteit/helpers/noteHelpers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart%20';

class ViewingPage extends StatefulWidget {
  String noteId;
  ViewingPage({super.key, required this.noteId});

  @override
  State<ViewingPage> createState() => _ViewingPageState(noteId: noteId);
}

class _ViewingPageState extends State<ViewingPage> {
  String noteId;
  _ViewingPageState({required this.noteId});
  Color getRandomColor() {
    var colorList = [
      Color.fromARGB(255, 255, 209, 242), // Light Pink
      Color.fromARGB(255, 255, 245, 186), // Light Yellow
      Color.fromARGB(255, 214, 255, 188), // Light Green
      Color.fromARGB(255, 179, 226, 255), // Light Blue
      Color.fromARGB(255, 204, 198, 117), // Pale Gold
      Color.fromARGB(255, 200, 180, 225), // Lavender
      Color.fromARGB(255, 196, 235, 209), // Mint
      Color.fromARGB(255, 153, 204, 255), // Sky Blue
      Color.fromARGB(255, 224, 207, 196), // Muted Rose
      Color.fromARGB(255, 173, 216, 230), // Light Blue
    ];
    Random random = Random();
    int index = random.nextInt(colorList.length);
    return colorList[index];
  }

  String formatFirebaseTimestamp(Timestamp timestamp) {
    if (timestamp == null) {
      return "";
    }

    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('EEE, d MMM, yyyy').format(dateTime);

    return formattedDate;
  }

  void setTitleColor() {
    titleColor = getRandomColor();
    setState(() {
      titleColor;
    });
  }

  bool _speechEnabled = false;
  SpeechToText _speechToText = SpeechToText();
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    print("STARTED LISTENING");
    if (_speechEnabled) {
      print("SPEECH ENABLED");
      await _speechToText.listen(
        onResult: (result) {
          print("RESULT");
          print(result);
        },
      );
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  String title = "";
  String content = "";
  String timestamp = '';
  Color titleColor = Colors.black;
  TextEditingController _contentTextController = TextEditingController();
  TextEditingController _titleTextController = TextEditingController();
  int contentLength = 0;
  NoteHelpers _noteHelpers = NoteHelpers();

  // Color titleColor = getRandomColor();
  Map<String, dynamic> noteData = {};
  final String currentLoggedInUser =
      FirebaseAuth.instance.currentUser!.email ?? "";
  bool _isLoading = false;
  void fetchNoteData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('notes')
          .where('id', isEqualTo: noteId)
          .where('userid', isEqualTo: currentLoggedInUser)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data() as Map<String, dynamic>;
        noteData = data;
        title = data["title"];
        content = data["content"];
        _titleTextController.text = title;
        _contentTextController.text = content;
        contentLength = content.length;
        timestamp = formatFirebaseTimestamp(data["datetime"]);
        setState(() {
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No data found!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error while fetching note data.'),
          duration: Duration(seconds: 3),
        ),
      );
      print('Error fetching note data: $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchNoteData();
    setTitleColor();
    _initSpeech();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        bool exit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: titleColor,
            title: Text('Exit ?'),
            content: Text('Are you sure you want to exit?'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Exit'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  if (_titleTextController.text.length == 0 &&
                      _contentTextController.text.length == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Note can\'t be empty.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop(false);
                  } else {
                    Map<String, dynamic> updatedData = {
                      'title': _titleTextController.text,
                      'content': _contentTextController.text,
                    };
                    _noteHelpers.updateNote(context, noteId, updatedData);
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop(true);
                  }
                  // _noteHelpers.updateNote(context, noteId, data)
                },
                child: Text('Save and exit'),
              ),
            ],
          ),
        );
        final navigator = Navigator.of(context);
        if (exit) {
          navigator.pop();
        }
        // return exit ?? false;
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 20, 21, 29),
        // appBar: AppBar(
        //     leading: Padding(
        //       padding: const EdgeInsets.only(left:20.0,top:10),
        //       child: IconButton(
        //         icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.black,size: 37,),
        //         onPressed: () => Navigator.of(context).pop(),
        //       ),
        //     ),
        //     actions: [
        //       Padding(
        //         padding: const EdgeInsets.only(right:20.0,top:20),
        //         child: GestureDetector(
        //           child: Icon(
        //             Icons.check_circle_outline_rounded,
        //             color: Colors.blue,
        //             size: 35,
        //           ),
        //         ),
        //       )
        //     ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
            child: Column(
                mainAxisAlignment: _isLoading
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: cro,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_circle_left_outlined,
                          color: Colors.white,
                          size: 37,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            child: Icon(
                              _speechToText.isNotListening
                                  ? Icons.mic_off
                                  : Icons.mic,
                              color: titleColor,
                              size: 35,
                            ),
                            onTap: () {
                              // setState(() {
                              //   _isLoading = true;
                              // });
                              _speechToText.isNotListening
                                  ? _startListening()
                                  : _stopListening();
                            },
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.check_circle_outline_rounded,
                              color: titleColor,
                              size: 35,
                            ),
                            onTap: () {
                              setState(() {
                                _isLoading = true;
                              });
                              if (_titleTextController.text.length == 0 &&
                                  _contentTextController.text.length == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Note can\'t be empty.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                              } else {
                                Map<String, dynamic> updatedData = {
                                  'title': _titleTextController.text,
                                  'content': _contentTextController.text,
                                };
                                _noteHelpers.updateNote(
                                    context, noteId, updatedData);
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextField(
                    controller: _titleTextController,
                    cursorColor: titleColor,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: titleColor),
                    decoration: InputDecoration(
                        hintText: "Enter Title...",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: titleColor)),
                  ),
                  Text(
                    "${timestamp} | ${contentLength}",
                    style: TextStyle(
                        color: Color.fromARGB(255, 193, 192, 192),
                        fontWeight: FontWeight.w600),
                  ),
                  TextField(
                    onChanged: (value) {
                      contentLength = value.length;
                      print("change");
                      setState(() {
                        contentLength;
                      });
                    },
                    controller: _contentTextController,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                    // expands: true,
                    maxLines: 5000,
                    cursorColor: titleColor,
                    // maxLength: 5000,
                    decoration: InputDecoration(
                        hintText: "Enter Content...",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white)),
                  ),
                ]),
          ),
        ),
      ),
    ));
  }
}
