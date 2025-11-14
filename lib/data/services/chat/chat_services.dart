import 'package:chat_app/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatServices extends ChangeNotifier {

  // INSTANCE OF AUTH AND FIRESTORE..........
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // // GET ALL USERS STREAM...................
  //  Stream<List<Map<String,dynamic>>> getUsersStream(){
  //    return _firestore.collection("Users").snapshots().map((snapshot) {
  //      return snapshot.docs
  //             .where((doc) => doc.data()['email'] != _auth.currentUser!.email)
  //             .map((doc) => doc.data())
  //             .toList();
  //      });
  //  }


   // GET ALL USERS STREAM EXCEPT BLOCKED USERS..............
   Stream<List<Map<String,dynamic>>> getUsersStreamExcludingBlocked(){
     final currentUser = _auth.currentUser;
     return _firestore
               .collection("Users")
               .doc(currentUser!.uid)
               .collection("BlockedUsers")
               .snapshots()
               .asyncMap((snapshot) async{
         // get list of blocked user ids
         final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

         // get all users
         final userDocs = await _firestore.collection("Users").get();

         // return as a stream list, excluding current user and blocked users
          return userDocs.docs
                  .where((doc) => doc.data()['email'] != currentUser.email && !blockedUserIds.contains(doc.id))
                  .map((doc) => doc.data())
                  .toList();

       });

   }


  // SEND MESSAGE ...............
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


  // GET MESSAGE...................
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

  // DELETED MESSAGE.........................
  Future<void> deleteMessage(String chatRoomID, String messageID) async {
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .doc(messageID)
        .delete();
  }


  // REPORT USERS................................
   Future<void> reportUser(String messageID, String userID) async{
     final currentUser = _auth.currentUser;
     final report = {
       'reportedBy': currentUser!.uid,
       'messageID' : messageID,
       'messageOwnerID' : userID,
       'timestamp' : FieldValue.serverTimestamp(),
     };
     await _firestore.collection("Reports").add(report);
   }


  // BLOCK USERS................................
   Future<void> blockUser(String userID) async{
     final currentUser = _auth.currentUser;
     await _firestore
             .collection("Users")
             .doc(currentUser!.uid)
             .collection("BlockedUsers")
             .doc(userID)
             .set({});

     notifyListeners();
   }


  // UNBLOCK USERS......................................
  Future<void> unblockUser(String blockUserID) async{
    final currentUser = _auth.currentUser;
    await _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .doc(blockUserID)
        .delete();
  }



  // GET BLOCKED USERS STREAM..............................
  Stream<List<Map<String,dynamic>>> getBlockedUsersStream(String userID){
     return _firestore
              .collection("Users")
              .doc(userID)
              .collection("BlockedUsers")
              .snapshots()
              .asyncMap((snapshot) async{
                // get list of blocked user ids
              final blockedUserIds = snapshot.docs.map((doc) => doc.id).toList();

              final userDocs = await Future.wait(
                  blockedUserIds.map((id) => _firestore.collection("Users").doc(id).get()),
              );
        // return as a list
        return userDocs.map((doc) => doc.data() as Map<String,dynamic>).toList();
     });

  }

}


