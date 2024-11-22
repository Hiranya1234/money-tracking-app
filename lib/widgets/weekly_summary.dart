import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class WeeklySummary extends StatefulWidget {
  @override
  _WeeklySummaryState createState() => _WeeklySummaryState();
}

class _WeeklySummaryState extends State<WeeklySummary> {
  List<double> weeklyExpenses = [];
  List<double> weeklyIncome = [];
  List<String> sortedWeeks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Handle user not logged in
        return;
      }

      final transactionsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .get();

      Map<String, double> tempExpenses = {};
      Map<String, double> tempIncome = {};

      for (var doc in transactionsSnapshot.docs) {
        double amount = doc['amount'];
        var timestampField = doc['timestamp'];
        String type = doc['type'];

        DateTime date;

        // Check if the timestamp is a Timestamp object or an int
        if (timestampField is Timestamp) {
          date = timestampField.toDate();
        } else if (timestampField is int) {
          // If it's an int, assume it's a Unix timestamp in milliseconds
          date = DateTime.fromMillisecondsSinceEpoch(timestampField);
        } else {
          // If it's not a recognizable type, skip this document
          continue;
        }

        String week = _getWeek(date);

        if (type == 'debit') {
          tempExpenses[week] = (tempExpenses[week] ?? 0) + amount;
        } else if (type == 'credit') {
          tempIncome[week] = (tempIncome[week] ?? 0) + amount;
        }
      }

      sortedWeeks = tempExpenses.keys.toList()..sort();
      List<double> fetchedExpenses = sortedWeeks.map((week) => tempExpenses[week] ?? 0).toList();
      List<double> fetchedIncome = sortedWeeks.map((week) => tempIncome[week] ?? 0).toList();

      setState(() {
        weeklyExpenses = fetchedExpenses;
        weeklyIncome = fetchedIncome;
        isLoading = false;
      });
    } catch (e) {
      // Handle errors
      print("Error fetching data: $e");
    }
  }

  String _getWeek(DateTime date) {
    int weekOfYear = int.parse(DateFormat('w').format(date));
    return '${date.year}-W$weekOfYear';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weekly Summary")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 400,
                child: BarChart(
                  BarChartData(
                    barGroups: List.generate(weeklyExpenses.length, (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: weeklyExpenses[index],
                            color: Colors.red,
                            width: 8,
                          ),
                          BarChartRodData(
                            toY: weeklyIncome[index],
                            color: Colors.green,
                            width: 8,
                          ),
                        ],
                      );
                    }),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= sortedWeeks.length) {
                              return Container();
                            }
                            return Text(
                              sortedWeeks[index],
                              style: TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}


