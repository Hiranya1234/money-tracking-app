import 'package:flutter/material.dart';
import 'package:flutter_application_4/utils/icon_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'detail_page.dart';

class TransactionCard extends StatelessWidget {
  TransactionCard({
    super.key,
    required this.data,
    required this.allTransactions,
  });
  final dynamic data;
  final List<dynamic> allTransactions;

  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
    String formattedDate = DateFormat('d MMM hh:mma').format(date);

    // Filter transactions by category
    List<dynamic> categoryTransactions = allTransactions.where((transaction) {
      return transaction['category'] == data['category'];
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              color: Colors.grey.withOpacity(0.09),
              blurRadius: 10.0,
              spreadRadius: 4.0,
            ),
          ],
        ),
        child: ListTile(
          minVerticalPadding: 4,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    category: data['category'],
                    transactions: categoryTransactions,
                  ),
                ),
              );
            },
            child: Container(
              width: 70,
              height: 100,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: data['type'] == 'credit'
                      ? Color(0xff368983).withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                ),
                child: Center(
                  child: FaIcon(
                    appIcons.getExpenseCategoryIcons('${data['category']}'),
                  ),
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(child: Text("${data['title']}")),
              Text(
                "Rs. ${data['amount']}",
                style: TextStyle(
                  color: data['type'] == 'credit'
                      ? Color(0xff368983)
                      : Colors.red,
                ),
              ),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Balance",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Spacer(),
                  Text(
                    "Rs. ${data['remainingAmount']}",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              Text(
                formattedDate,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

