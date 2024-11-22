import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'transaction_card.dart';

class TrasactionsCard extends StatefulWidget {
  const TrasactionsCard({super.key});

  @override
  State<TrasactionsCard> createState() => _TrasactionsCardState();
}

class _TrasactionsCardState extends State<TrasactionsCard> {
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Text("Recent Trasactions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )
            ],
          ),
          RecentTransactionsList()
        ],),
    );
  }
}

class RecentTransactionsList extends StatelessWidget {
   RecentTransactionsList({
    super.key,
  });

  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {

     return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection("transactions")
      .orderBy('timestamp', descending: true).limit(20)
      .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if(snapshot.connectionState == ConnectionState.waiting){
          return Text("Loading");
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty){
          return const Center(child: Text('No transactions found.'));
        }

        

        
     
      var data = snapshot.data!.docs;
      var allTransactions = data.map((doc) => doc.data()).toList();

        return ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            var cardData = data[index].data() as Map<String, dynamic>;
            return TransactionCard(
              data:cardData, allTransactions: allTransactions,);
          });
     });
  }
}

