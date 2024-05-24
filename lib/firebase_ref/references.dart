import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Firebase Firestore
final fireStore = FirebaseFirestore.instance;

// Firebase storage reference
Reference get firebaseStorage => FirebaseStorage.instance.ref();

// 'questionPaper' collection
final questionPaperRF = fireStore.collection('questionPapers');

DocumentReference questionRF({
  required String paperId,
  required String questionId,
})
//Locate the document with name the same as this paperId,
//Create a collection under this document with the name 'questions'
//Create a document under this collection with name the same as the questionId
    =>
    questionPaperRF.doc(paperId).collection('questions').doc(questionId);

// 'users' Collection
final userRF = fireStore.collection('users');
DocumentReference currentUserRF({
  required String userEmail,
}) =>
    userRF.doc(userEmail);

final chatsRF = fireStore.collection('messages');
//Grab the data from the 'message' database, and sort according to the timestamp from the time field
final chatsByTimeRF = chatsRF.orderBy('time');
