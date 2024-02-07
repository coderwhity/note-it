import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noteit/helpers/noteHelpers.dart';
import 'package:noteit/screens/EditingPage.dart';
import 'package:intl/intl.dart';
import 'package:noteit/screens/ViewingPage.dart';
import 'package:noteit/services/authServices.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearchingIndicator = false;
  final String loggedInUserEmail =
      FirebaseAuth.instance.currentUser!.email ?? "";
  TextEditingController _searchQueryController = TextEditingController();
  Color getRadomColor() {
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

  // List<Map<String, dynamic>> notesData = [
  //   {
  //     "title": "Note 1",
  //     "content":
  //         "This is the longer content for Note 1. It includes more details and information to make the note more substantial."
  //   },
  //   {
  //     "title": "Note 2",
  //     "content":
  //         "Extended content for Note 2. This additional information provides a more in-depth understanding of the note."
  //   },
  //   {
  //     "title": "Note 3",
  //     "content":
  //         "In this version of Note 3, we have added extensive content to convey a comprehensive message. The details cover various aspects."
  //   },
  //   {
  //     "title": "Note 4",
  //     "content":
  //         "Note 4 comes with a detailed explanation and additional context. We aim to provide comprehensive information in each note."
  //   },
  //   {
  //     "title": "Note 5",
  //     "content":
  //         "Content for Note 5 has been expanded to include relevant details, ensuring a thorough understanding of the note's subject."
  //   },
  //   {
  //     "title": "Note 1",
  //     "content":
  //         "This is the longer content for Note 1. It includes more details and information to make the note more substantial."
  //   },
  //   {
  //     "title": "Note 2",
  //     "content":
  //         "Extended content for Note 2. This additional information provides a more in-depth understanding of the note."
  //   },
  //   {
  //     "title": "Note 3",
  //     "content":
  //         "In this version of Note 3, we have added extensive content to convey a comprehensive message. The details cover various aspects."
  //   },
  //   {
  //     "title": "Note 4",
  //     "content":
  //         "Note 4 comes with a detailed explanation and additional context. We aim to provide comprehensive information in each note."
  //   },
  //   {
  //     "title": "Note 5",
  //     "content":
  //         "Content for Note 5 has been expanded to include relevant details, ensuring a thorough understanding of the note's subject."
  //   },
  // ];
  NoteHelpers _noteHelpers = NoteHelpers();
  AuthService _authService = AuthService();
  String formatFirebaseTimestamp(Timestamp timestamp) {
    if (timestamp == null) {
      return "";
    }

    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('EEE, d MMM, yyyy').format(dateTime);

    return formattedDate;
  }

  void setTitleColor() {
    titleColor = getRadomColor();
    setState(() {
      titleColor;
    });
  }

  Color titleColor = Colors.white;

  @override
  void initState() {
    // TODO: implement initState
    setTitleColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          shape: CircleBorder(side: BorderSide.none),
          child: Icon(
            Icons.add_rounded,
            size: 30,
            color: Colors.purple[400],
          ),
          onPressed: () {
            print("ADD NOTE");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditingPage()));
          }),
      backgroundColor: Color.fromARGB(255, 20, 21, 29),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Notes",
                      style: TextStyle(
                          color: Color.fromARGB(255, 254, 255, 255),
                          fontWeight: FontWeight.bold,
                          fontSize: 32)),
                  GestureDetector(
                    onTap: () async {
                      print("LOGOUT");
                      await _authService.logoutUser(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 79, 83, 113),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Icon(
                          Icons.logout_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 79, 83, 113),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          if (value.length == 0) {
                            setState(() {
                              _searchQueryController.text;
                            });
                          }
                        },
                        controller: _searchQueryController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        if (!_isSearchingIndicator) {
                          setState(() {
                            _isSearchingIndicator = true;
                          });
                          print("SEARCIHNG");
                          print(loggedInUserEmail);
                          setState(() {
                            _isSearchingIndicator = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _searchQueryController.text.length > 0
                  ? FirebaseFirestore.instance
                      .collection('notes')
                      .where('userid', isEqualTo: loggedInUserEmail)
                      .where('title',
                          isGreaterThanOrEqualTo: _searchQueryController.text)
                      .where('title',
                          isLessThanOrEqualTo:
                              _searchQueryController.text + '\uf8ff')
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('notes')
                      .where('userid', isEqualTo: loggedInUserEmail)
                      // .orderBy('datetime', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Loading indicator while data is being fetched
                }

                if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.white),
                  );
                }

                var notesData = snapshot.data!.docs;

                return Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisExtent: 200,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: notesData.length,
                    itemBuilder: (context, index) {
                      Color cardColor = getRadomColor();
                      var note = notesData[index];
                      return Card(
                        color: cardColor,
                        elevation: 3.0,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: InkWell(
                            onLongPress: () {
                              print("LONG PRESS");
                              _showDeleteModal(context, cardColor,note["id"]);
                            },
                            // on
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewingPage(
                                            noteId: note["id"],
                                          )));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note['title'].length == 0 ? "No Title.." : note["title"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  note['content'].length == 0 ? "No Content.." : note["content"],
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8.0),
                                Expanded(child: Container()),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      formatFirebaseTimestamp(note['datetime']),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    ));
  }

  void _showDeleteModal(BuildContext context, Color cardColor, String noteId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: cardColor,
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete Note'),
                  onTap: (){
                    _noteHelpers.deleteNote(noteId, context);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
