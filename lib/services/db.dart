import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Db{
  CollectionReference users = FirebaseFirestore.instance.collection('users');

Future<void> addUser(data, context) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  await users
    .doc(userId)
    .set(data)
    .then((value) => print("User Added"))
    .catchError((error) {
      showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: Text("Sign up Failed"),
            content: Text(error.toString()),
          );
        });
    });
}

  /* Future<List<TransactionData>> getTransactions() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot = await users
        .doc(userId)
        .collection('transactions')
        .orderBy('timestamp')
        .get();

    return snapshot.docs.map((doc) => TransactionData.fromFirestore(doc)).toList();
  }*/
}
