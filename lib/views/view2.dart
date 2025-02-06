import 'package:flutter/material.dart';

class View2 extends StatefulWidget {
  final double creditAmount;
  final dynamic apiData;
  final Function(double, int) onEmiSelected; // Callback function

  const View2({
    super.key,
    required this.creditAmount,
    required this.onEmiSelected,
    this.apiData,
  });

  @override
  _View2State createState() => _View2State();
}

class _View2State extends State<View2> {
  // Declare and initialize selected EMI variables
  double selectedEmiAmount = 0.0; // Initialize to 0.0
  int selectedEmiDuration = 0; // Initialize to 0
  int selectedIndex = -1;
  final List<Color> customColors = [
    const Color.fromARGB(255, 116, 62, 62),
    const Color.fromARGB(255, 165, 91, 179),
    Colors.indigo,
    Colors.amber,
    Colors.teal,
  ];

  // EMI Calculation function
  double calculateEmi(double creditAmount, int duration) {
    double interestRate = 0.015; // Example interest rate (1.5% per month)
    double emi = (creditAmount * interestRate * (1 + interestRate) * duration) /
        ((1 + interestRate) * duration - 1);
    return emi;
  }

  @override
  Widget build(BuildContext context) {
    final body = widget.apiData['open_state']['body'];
    final items = body['items'] as List; // Type casting
    return Scaffold(
      body: Container(
        color: const Color(0xFF1A2028),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 80),
            // Credit Amount Section (Blurred)
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  5,
                ), // Semi-transparent black
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Credit Amount',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 116, 113, 113),
                        ),
                      ),
                      Text(
                        '₹${widget.creditAmount.toStringAsFixed(0)}', // Display credit amount
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
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ), // Container with text layers
            Container(
              padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
              decoration: BoxDecoration(
                //border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
                //color: Color.fromARGB(255, 34, 31, 31),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    body['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 156, 197, 230),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    body['subtitle'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 156, 197, 230),
                    ),
                  ),
                ],
              ),
            ),
            // Container with selectable squares
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              padding: EdgeInsets.only(bottom: 20),
              height: 200,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ), // Adjust height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  int duration;
                  switch (index) {
                    case 0:
                      duration = 3;
                      break;
                    case 1:
                      duration = 6;
                      break;
                    case 2:
                      duration = 9;
                      break;
                    case 3:
                      duration = 12;
                      break;
                    default:
                      duration = 12; // Default case
                  }

                  double emi = calculateEmi(widget.creditAmount, duration);
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        _buildSquare(index, emi, duration),
                        if (item['tag'] == 'recommended')
                          Positioned(
                            top: -5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Text(
                                "Recommended",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Container with customizable button
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Align(
                // Wrap with Align to control width
                alignment: Alignment
                    .centerLeft, // Align to the left (or center as needed)
                child: GestureDetector(
                  onTap: () {
                    // Handle tap
                  },
                  child: Container(
                    width: 140, // Adjust width as needed
                    height: 30, // Adjust height as needed
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 103, 124, 142),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Create your own plan',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color.fromARGB(255, 156, 197, 230),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquare(int index, double emi, int duration) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index == selectedIndex ? -1 : index;
          if (selectedIndex != -1) {
            selectedEmiAmount = emi;
            selectedEmiDuration = duration;
            widget.onEmiSelected(emi, duration);
          }
        });
      },
      child: Container(
        width: 160, // Adjust width as needed
        height: 180, // Adjust height as needed
        margin: const EdgeInsets.symmetric(horizontal: 10), // Consistent margin
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: customColors[index], // Darker card background
        ),
        child: Column(
          children: [
            Padding(
              // Add padding to the content
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkmark or Placeholder
                  selectedIndex == index
                      ? const Icon(Icons.check_circle_outline, size: 30)
                      : Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white),
                          ),
                        ),
                  const SizedBox(height: 40),
                  Text(
                    '₹${emi.toStringAsFixed(0)}/mo', // Example amount
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'for $duration months',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'See calculations',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey, // Blue link color
                    ),
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
