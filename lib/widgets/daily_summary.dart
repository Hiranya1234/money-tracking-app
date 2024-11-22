import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DailySummary extends StatefulWidget {
  @override
  _DailySummaryState createState() => _DailySummaryState();
}

class _DailySummaryState extends State<DailySummary> {
  List<double> dailyExpenses = [];
  List<double> dailyIncome = [];
  List<String> sortedDays = [];  // Store dates here
  Map<String, List<Map<String, dynamic>>> transactionsByDay = {}; // Store transactions by day
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
        String title = doc['title'];

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

        String day = DateFormat('yyyy-MM-dd').format(date);

        // Store the transaction in the map
        if (!transactionsByDay.containsKey(day)) {
          transactionsByDay[day] = [];
        }
        transactionsByDay[day]?.add({
          'title': title,
          'amount': amount,
          'timestamp': date,
          'type': type,
        });

        if (type == 'debit') {
          tempExpenses[day] = (tempExpenses[day] ?? 0) + amount;
        } else if (type == 'credit') {
          tempIncome[day] = (tempIncome[day] ?? 0) + amount;
        }
      }

      sortedDays = tempExpenses.keys.toList()..sort();  // Save sorted dates
      List<double> fetchedExpenses = sortedDays.map((day) => tempExpenses[day] ?? 0).toList();
      List<double> fetchedIncome = sortedDays.map((day) => tempIncome[day] ?? 0).toList();

      setState(() {
        dailyExpenses = fetchedExpenses;
        dailyIncome = fetchedIncome;
        isLoading = false;
      });
    } catch (e) {
      // Handle errors
      print(e);
    }
  }

  void showTransactionDetails(String day) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Transactions on $day"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: transactionsByDay[day]!.map((transaction) {
              return ListTile(
                title: Text('${transaction['type'] == 'credit' ? 'Income' : 'Expense'}: \Rs.${transaction['amount']}'),
                subtitle: Text('Time: ${DateFormat('hh:mm a').format(transaction['timestamp'])}\nTitle: ${transaction['title']}'),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', 
              style: TextStyle(
                color: Colors.white
              )),
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 47, 125, 121),
              
              ),
            ),
          ],
        );
      },
    );
  }

  String formatNumber(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    } else {
      return value.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Daily Summary")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Daily Summary',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        barGroups: List.generate(dailyExpenses.length, (index) {
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: dailyExpenses[index],
                                color: Colors.red,
                                width: 8,
                              ),
                              BarChartRodData(
                                toY: dailyIncome[index],
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
                                if (index < 0 || index >= sortedDays.length) {
                                  return Container();
                                }
                                return GestureDetector(
                                  onTap: () {
                                    print("Tapped on: ${sortedDays[index]}"); // Debug print
                                    showTransactionDetails(sortedDays[index]);
                                  },
                                  child: Text(
                                    DateFormat('E').format(DateTime.parse(sortedDays[index])), // Display day of the week
                                    style: TextStyle(fontSize: 10),
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false), // Remove top titles
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  formatNumber(value),
                                  style: TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false), // Remove right titles
                          ),
                        ),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            //tooltipBgColor: Colors.blueGrey,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              String day = sortedDays[groupIndex];
                              return BarTooltipItem(
                                '${DateFormat('E').format(DateTime.parse(day))}\n',
                                TextStyle(color: Colors.white),
                                children: [
                                  TextSpan(
                                    text: 'Expense: \Rs.${dailyExpenses[groupIndex]}\n',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  TextSpan(
                                    text: 'Income: \Rs.${dailyIncome[groupIndex]}',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          drawHorizontalLine: true,
                          horizontalInterval: 10,
                          verticalInterval: 1,
                          checkToShowHorizontalLine: (value) => value % 10 == 0,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white,
                              strokeWidth: 0.5,
                            );
                          },
                          checkToShowVerticalLine: (value) => value % 1 == 0,
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.white,
                              strokeWidth: 0.5,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}











