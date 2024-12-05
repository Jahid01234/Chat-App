import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices{
  // instance of auth and FireStore..........
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user....................
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  // sign in.............................
  Future<UserCredential> signInWithEmailAndPassword(String email,password) async{
    try {
      // try log in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user information if it does not already exit
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
          {
            'uid' : userCredential.user!.uid,
            'email' : email,
          }
      );

      return userCredential;

    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }


  // sign up...........................
  Future<UserCredential> signUpWithEmailPassword(String email,password) async{
    try {
      // create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user information in a separate doc
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid' : userCredential.user!.uid,
          'email' : email,
        }
      );


      return userCredential;

    } on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

   // sign out..................
   Future<void> signOut() async{
    return await _auth.signOut();
   }



}