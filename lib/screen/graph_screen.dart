import 'package:flutter/material.dart';
import 'package:flutter_application_4/widgets/daily_summary.dart';
import 'package:flutter_application_4/widgets/monthly_summary.dart';
import 'package:flutter_application_4/widgets/yearly_summary.dart';

class Graph extends StatefulWidget {
  const Graph({super.key});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  List<String> dayOptions = ['Day', 'Month', 'Year'];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Statistics',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(dayOptions.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 80,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: selectedIndex == index
                            ? Color.fromARGB(255, 47, 125, 121)
                            : Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        dayOptions[index],
                        style: TextStyle(
                          color: selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: getSelectedSummaryPage(selectedIndex),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSelectedSummaryPage(int index) {
    switch (index) {
      case 0:
        return DailySummary();
      //case 1:
       // return WeeklySummary();
      case 1:
        return MonthlySummary();
      case 2:
        return YearlySummary();
      default:
        return DailySummary(); // Default to DailySummary
    }
  }
}


