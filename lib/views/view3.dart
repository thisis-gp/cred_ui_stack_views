import 'package:flutter/material.dart';

class View3 extends StatefulWidget {
  // Changed to StatefulWidget
  final double creditAmount;
  final double emiAmount;
  final int emiDuration;
  final dynamic apiData; // Add apiData parameter

  const View3({
    super.key,
    required this.creditAmount,
    required this.emiAmount,
    required this.emiDuration,
    required this.apiData, // Make it required
  });

  @override
  _View3State createState() => _View3State(); // Correct State class
}

class _View3State extends State<View3> {
  // Renamed State class
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final body = widget.apiData['open_state']['body'];
    final items = body['items'] as List;

    return Container(
      // Changed to Container
      color: const Color(0xFF1A2028),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 80), // Added const
          _buildCreditAmountSection(body),
          _buildEmiPlanSection(body),
          _buildBankAccountSection(body, items), // Pass items
        ],
      ),
    );
  }

  Widget _buildCreditAmountSection(dynamic body) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                body['key1'] ?? 'Credit Amount', // Use API data
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 116, 113, 113),
                ),
              ),
              Text(
                '₹${widget.creditAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 121, 119, 119),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildEmiPlanSection(dynamic body) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                body['emi_key'] ??
                    'EMI', // Use API data or default, better key name
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 116, 113, 113),
                ),
              ),
              Text(
                '₹${widget.emiAmount.toStringAsFixed(0)}/mo',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 116, 113, 113),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                body['duration_key'] ??
                    'Duration', // Use API data or default, better key name
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 116, 113, 113),
                ),
              ),
              Text(
                '${widget.emiDuration} months',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 121, 119, 119),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountSection(dynamic body, List<dynamic> items) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10), // Added const
          Text(
            body['title'], // Use API title
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 156, 197, 230),
            ),
          ),
          const SizedBox(height: 10), // Added const
          Text(
            body['subtitle'], // Use API subtitle
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 144, 145, 145),
            ),
          ),
          const SizedBox(height: 5), // Added const
          // Use ListView.builder to display bank accounts from API
          ListView.builder(
            shrinkWrap: true, // Important for nested scrolling
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling
            itemCount: items.length, // Use the number of items from the API
            itemBuilder: (context, index) {
              final item = items[index]; // Get the current item
              return _buildBankAccountItem(item); // Build item widget
            },
          ),
          const SizedBox(height: 25), // Added const
          _buildChangeAccountButton(body),
        ],
      ),
    );
  }

  Widget _buildBankAccountItem(dynamic item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Use a Stack to handle potential image errors
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 4.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      "assets/images/hdfc.png", // Dynamic icon
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      errorBuilder: (context, object, stackTrace) {
                        return const Icon(Icons.error); // Show an error icon
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'], // Use title from API
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    item['subtitle'].toString(), // Use subtitle from API
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 160, 157, 157),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: const Color.fromARGB(255, 131, 124, 124),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeAccountButton(dynamic body) {
    return GestureDetector(
      onTap: () {
        // Handle tap event
        // print('Container tapped!');
      },
      child: Container(
        width: 100, // Adjust width as needed
        height: 30, // Adjust height as needed
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 103, 124, 142)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            body['footer'] ?? 'Change account', // Use API data or default
            style: const TextStyle(
              fontSize: 10,
              color: Color.fromARGB(255, 156, 197, 230),
            ),
          ),
        ),
      ),
    );
  }
}
