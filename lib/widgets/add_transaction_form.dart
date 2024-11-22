import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/utils/appvalidator.dart';
import 'package:flutter_application_4/widgets/category_dropdown.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  var type = "credit";
  var category = "Grocery";
  List<String> userCategories = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoarder = false;
  var appValidator = AppValidator();
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();
  var uid = Uuid();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoarder = true;
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        var amount = int.parse(amountEditController.text);
        DateTime date = DateTime.now();

        var id = uid.v4();
        String monthyear = DateFormat('MM y').format(date);

        print("Fetching user document...");
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        int remainingAmount = userDoc['remainingAmount'];
        int totalCredit = userDoc['totalCredit'];
        int totalDebit = userDoc['totalDebit'];

        if (type == 'credit') {
          remainingAmount += amount;
          totalCredit += amount;
        } else {
          remainingAmount -= amount;
          totalDebit += amount;
        }

        print("Updating user document...");
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          "remainingAmount": remainingAmount,
          "totalCredit": totalCredit,
          "totalDebit": totalDebit,
          "updatedAt": timestamp,
        });

        var data = {
          "id": id,
          "title": titleEditController.text,
          "amount": amount,
          "type": type,
          "timestamp": timestamp,
          "totalCredit": totalCredit,
          "totalDebit": totalDebit,
          "remainingAmount": remainingAmount,
          "monthyear": monthyear,
          "category": category,
        };

        print("Adding transaction document...");
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection("transactions")
            .doc(id)
            .set(data);

        print("Transaction added successfully.");
        Navigator.pop(context);

        // Reset form fields
        titleEditController.clear();
        amountEditController.clear();
        setState(() {
          type = "credit";
          category = "Grocery";
        });

      } catch (e) {
        print("Error: $e");
      } finally {
        setState(() {
          isLoarder = false;
        });
      }
    }
  }

  Future<void> _addCategory() async {
    TextEditingController categoryController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Category"),
        content: TextField(
          controller: categoryController,
          decoration: InputDecoration(hintText: "Enter category name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                userCategories.add(categoryController.text);
              });
              Navigator.of(context).pop();
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: titleEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextFormField(
              controller: amountEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            CategoryDropDown(
              cattype: category,
              userCategories: userCategories,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),
            DropdownButtonFormField(
              value: type,
              items: [
                DropdownMenuItem(
                  child: Text('Credit'),
                  value: 'credit',
                ),
                DropdownMenuItem(
                  child: Text('Debit'),
                  value: 'debit',
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    type = value;
                  });
                }
              },
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                if (isLoarder == false) {
                  _submitForm();
                }
              },
              child: isLoarder ? Center(child: CircularProgressIndicator()) : Text("Add Transaction"),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: _addCategory,
              child: Text("Add Category"),
            ),
          ],
        ),
      ),
    );
  }
}

