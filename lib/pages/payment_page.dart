// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nutsnbolts/utils/constants.dart';

import '../entities/transaction_entity.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<TransactionEntity> transactionList = [
    TransactionEntity(
        type: "Receive",
        username: "Lu Hou Yang",
        description: "Fixed toilet",
        amount: 50.00),
    TransactionEntity(
        type: "Transferred",
        username: "Adi Ahmad",
        description: "Lawn Cleaned",
        amount: 10.00),
    TransactionEntity(
        type: "Receive",
        username: "Lu Hou Yang",
        description: "Pipe Leakage Settled",
        amount: 98.00),
    TransactionEntity(
        type: "Transferred",
        username: "Lester Khoo Zhen Jie",
        description: "Repaired Fan Capacitor",
        amount: 20.00),
    TransactionEntity(
        type: "Receive",
        username: "Lim Jia Chyuen",
        description: "Fixed PC",
        amount: 134.50),
    TransactionEntity(
        type: "Receive",
        username: "Lu Hou Yang",
        description: "Fixed Broken Door",
        amount: 26.00)
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.amber,
                  Colors.amber[800]!,
                ],
              ),
            ),
            child: Text(
              "Finance",
              style: TextStyle(
                  color: MyColours.secondaryColour,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nut-Wallet",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "My balance",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "RM 238.50",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(
                            Icons.money,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Transaction History",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactionList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: ListTile(
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        tileColor: Colors.white,
                        title: Text(
                          transactionList[index].description,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(transactionList[index].username),
                        trailing: Text(
                          (transactionList[index].type == "Receive")
                              ? "+RM ${transactionList[index].amount.toStringAsFixed(2)}"
                              : "-RM ${transactionList[index].amount.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 20,
                              color: (transactionList[index].type == "Receive")
                                  ? Colors.green
                                  : Colors.red),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
