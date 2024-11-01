import 'package:chat_app/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices{
  // instance of auth and FireStore..........
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get user stream...................
   Stream<List<Map<String,dynamic>>> getUsersStream(){
     return _firestore.collection("Users").snapshots().map((snapshot) {
       return snapshot.docs.map((doc) {
           // go through an individual user
           final user = doc.data();

           // return user
           return user;
         }).toList();
       }
     );
   }


  // send message...............
  Future<void> sendMessage(String receiverID, message)async{
     // get current user info
     final String currentUserID = _auth.currentUser!.uid;
     final String currentUserEmail = _auth.currentUser!.email!;
     final Timestamp timestamp = Timestamp.now();

     // create a new message
     Message newMessage = Message(
         senderID: currentUserID,
         senderEmail: currentUserEmail,
         receiverID: receiverID,
         message: message,
         timestamp: timestamp,
     );

     // construct chat room ID for the two users
     List<String> ids = [
       currentUserID,
       receiverID,
     ];
     ids.sort(); // sorted the ids (this ensure the chatroomID is the same for any 2 people)
     String chatRoomID = ids.join('_');

     // add new message to database
     await _firestore
           .collection("chat_rooms")
           .doc(chatRoomID)
           .collection("messages")
           .add(newMessage.toMap());

  }


  // get messages...................
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct chat room ID for the two users
    List<String> ids = [
      userID,
      otherUserID,
    ];
    ids.sort(); // sorted the ids (this ensure the chatroomID is the same for any 2 people)
    String chatRoomID = ids.join('_');

    // add new message to database
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp",descending: false)
        .snapshots();

  }

}