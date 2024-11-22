import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math';

class DetailPage extends StatefulWidget {
  final String category;
  final List<dynamic> transactions;

  DetailPage({required this.category, required this.transactions});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? _selectedMonth;
  double _selectedMonthTotal = 0.0;

  // Method to calculate the total amount of transactions for each month
  Map<String, double> _calculateTotalByMonth() {
    final Map<String, double> monthlyTotals = {};

    for (var transaction in widget.transactions) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(transaction['timestamp']);
      String monthYear = DateFormat('MMM yyyy').format(date);

      if (transaction['category'] == widget.category) {
        if (!monthlyTotals.containsKey(monthYear)) {
          monthlyTotals[monthYear] = 0.0;
        }
        monthlyTotals[monthYear] = monthlyTotals[monthYear]! + transaction['amount'];
      }
    }

    return monthlyTotals;
  }

  // Generate a list of distinct colors
  List<Color> _generateColors(int count) {
    final Random random = Random();
    List<Color> colors = [];
    for (int i = 0; i < count; i++) {
      colors.add(Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      ));
    }
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate totals by month
    Map<String, double> monthlyTotals = _calculateTotalByMonth();
    print('Monthly Totals: $monthlyTotals'); // Debugging

    // Check if monthlyTotals is empty
    if (monthlyTotals.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Transactions for ${widget.category}'),
        ),
        body: Center(child: Text('No data available for ${widget.category}')),
      );
    }

    // Generate colors for each month
    List<Color> colors = _generateColors(monthlyTotals.length);

    // Create a map of month-year to color
    final Map<String, Color> monthColorMap = {};
    int index = 0;
    monthlyTotals.keys.forEach((month) {
      if (index < colors.length) {
        monthColorMap[month] = colors[index++];
      } else {
        monthColorMap[month] = Colors.grey; // Default color if needed
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions for ${widget.category}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Pie Chart
            Expanded(
              child: PieChart(
                dataMap: monthlyTotals,
                chartType: ChartType.ring,
                colorList: monthColorMap.values.toList(), // Use colors
                legendOptions: LegendOptions(
                  showLegends: true,
                  legendPosition: LegendPosition.right,
                ),
                chartValuesOptions: ChartValuesOptions(
                  showChartValuesInPercentage: true,
                  showChartValues: true,
                ),
                /*dataMap: (value, name) {
                  setState(() {
                    _selectedMonth = name;
                    
                    _selectedMonthTotal = monthlyTotals[name] ?? 0.0;
                  }
                  );
                },*/
              ),
            ),
            // Display the selected month's total
            if (_selectedMonth != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total for $_selectedMonth: Rs. ${_selectedMonthTotal.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            // Display monthly totals
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Totals:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ...monthlyTotals.entries.map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          '${entry.key}: Rs. ${entry.value.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18),
                        ),
                      )),
                ],
              ),
            ),
            // Display transactions in a ListView
            Expanded(
              child: ListView.builder(
                itemCount: widget.transactions.length,
                itemBuilder: (context, index) {
                  var transaction = widget.transactions[index];
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(transaction['timestamp']);
                  String formattedDate = DateFormat('d MMM yyyy hh:mma').format(date);

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title: ${transaction['title']}', style: TextStyle(fontSize: 20)),
                          SizedBox(height: 10),
                          Text('Amount: Rs. ${transaction['amount']}', style: TextStyle(fontSize: 18)),
                          SizedBox(height: 10),
                          Text('Category: ${transaction['category']}', style: TextStyle(fontSize: 18)),
                          SizedBox(height: 10),
                          Text('Type: ${transaction['type']}', style: TextStyle(fontSize: 18)),
                          SizedBox(height: 10),
                          Text('Date: $formattedDate', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



