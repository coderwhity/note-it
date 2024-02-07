import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class NoteHelpers{
void updateNote(BuildContext context,String noteId,Map<String,dynamic> data) async {
  try {
    // Get the current timestamp
    Timestamp timestamp = Timestamp.now();

    // Update the note data in Firestore based on the noteId
    await FirebaseFirestore.instance.collection('notes')
        .where('id', isEqualTo: noteId)
        .get()
        .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) async {
            await doc.reference.update({
              'title': data["title"],
              'content': data["content"],
              'datetime': timestamp,
            });
          });
        });

    // Show a success message or perform any other actions if needed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    // Handle any errors that occur during the update process
    print('Error updating note: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error updating note'),
        backgroundColor: Colors.red,
      ),
    );
  }
}



void saveNewNote(Map<String,dynamic> data,String noteId,BuildContext context) async {
  try {
    // Generate a unique ID for the new note
    

    // Get the current timestamp
    Timestamp timestamp = Timestamp.now();

    // Save the new note data to Firestore
    await FirebaseFirestore.instance.collection('notes').doc(noteId).set({
      'id': noteId,
      'title': data["title"],
      'content': data["content"],
      'datetime': timestamp,
      'userid': data["userId"],
    });

    // Show a success message or perform any other actions if needed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note created and saved successfully.'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    // Handle any errors that occur during the save process
    print('Error saving note: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error saving note'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


void deleteNote(String noteId,BuildContext context) async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.email!; // Get the logged-in user's email
    await FirebaseFirestore.instance.collection('notes')
        .where('id', isEqualTo: noteId)
        .where('userid', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Note deleted successfully.'),
        backgroundColor: Colors.green,
      ),
    );
    print('Note deleted successfully');
  } catch (error) {
    print('Error deleting note: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error deleting note'),
        backgroundColor: Colors.red,
      ),
    );
    // Handle error accordingly, e.g., show error message
  }
}

}