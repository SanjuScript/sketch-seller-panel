import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction History"),
        leading: const Icon(Icons.payments_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            TransactionItem(
              tID: "ihsdbfonaodfn234",
              username: 'Damodar',
              title: "Wooden Art - Custom Drawing",
              date: "2025-01-14",
              amount: 200.0,
              status: 'Received',
              color: Colors.green,
            ),
            TransactionItem(
              tID: "ishbf8274fh",
              username: "Sanjus",
              title: "Glass Art - Custom Drawing",
              date: "2025-01-10",
              amount: 350.0,
              status: 'Received',
              color: Colors.orange,
            ),
            TransactionItem(
              tID: "sifhbvisjn12",
              username: "Sankar",
              title: "Blue Art - Digital Sketch",
              date: "2025-01-05",
              amount: 120.0,
              status: 'Received',
              color: Colors.blue,
            ),
          ],
        ),
      ),
      
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String title;
  final String username;
  final String tID;
  final String date;
  final double amount;
  final String status;
  final Color color;

  const TransactionItem({
    super.key,
    required this.title,
    required this.username,
    required this.date,
    required this.amount,
    required this.status,
    required this.color,
    required this.tID,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Card(
      color: Colors.white,
      elevation: 8.0,
      margin: const EdgeInsets.only(bottom: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width * .15,
              height: size.height * .07,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[200],
              ),
              child: const Icon(Icons.image, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "#$tID",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    "\$${amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date: $date",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
