import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date operations

class NotificationScreen extends StatelessWidget {
  final String userId;

  NotificationScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text("Document does not exist"));
        }
        
        var data = snapshot.data!.data() as Map<String, dynamic>;

        // Calculate the daily spendable amount
        double totalBalance = data['remainingAmount'];
        int daysInMonth = DateTime.now().month == 2 ? 28 : (DateTime.now().month % 2 == 1 ? 31 : 30); // Simplified calculation for days in the month
        int daysLeft = daysInMonth - DateTime.now().day;
        double dailySpendableAmount = totalBalance / (daysLeft > 0 ? daysLeft : 1); // Avoid division by zero

        // Get the current date
        String currentDate = DateFormat('yMMMMd').format(DateTime.now());

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentDate,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'You can spend Rs. ${dailySpendableAmount.toStringAsFixed(2)} per day.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close',
                style: TextStyle(
                  color: Colors.white
                ),),
                style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 47, 125, 121)),
              ),
            ],
          ),
        );
      },
    );
  }
}


