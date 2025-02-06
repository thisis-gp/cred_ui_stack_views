import 'dart:math';

import 'package:flutter/material.dart';

class View1 extends StatefulWidget {
  final dynamic apiData;
  final Function(double) onAmountChanged;
  const View1({super.key, required this.onAmountChanged, this.apiData});

  @override
  State<View1> createState() => _View1State();
}

class _View1State extends State<View1> {
  double _currentAmount = 150000;
  final double _currentRate = 1.04;

  @override
  Widget build(BuildContext context) {
    final body = widget.apiData['open_state']['body'];
    final card = body['card'];

    return Container(
      color: const Color(0xFF1A2028),
      child: Stack(
        children: [
          Positioned.fill(child: BackgroundWidget()),
          Positioned(
            top: 150, // Adjust this value to position the text properly
            left: 40,
            right: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  body['title'],
                  style: TextStyle(
                    color: Color.fromARGB(221, 167, 160, 160),
                    fontSize: 18, // Increased font size for better visibility
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  body['subtitle'],
                  style: TextStyle(
                    color: Color.fromARGB(221, 83, 83, 83),
                    fontSize: 12, // Increased font size for better visibility
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: WidgetContainer(
                child: CreditWidget(
                  creditAmount: _currentAmount, // Initial credit amount
                  interestRate: _currentRate,
                  maxRange: card['max_range'], // Use max_range from API
                  minRange: card['min_range'],
                  footer: body['footer'], // Use min_range from API
                  onAmountChanged: (amount) {
                    setState(() {
                      _currentAmount = amount;
                      widget.onAmountChanged(amount);
                    });
                  }, // Initial interest rate
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      // Navy blue color for the background
    );
  }
}

class WidgetContainer extends StatelessWidget {
  final Widget child;

  const WidgetContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340, // Increase the size of the container
      height: 340, // Increase the size of the container
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2.0), // Black border
        borderRadius: BorderRadius.circular(20.0), // Rounded corners
      ),
      child: child,
    );
  }
}

class CreditWidget extends StatefulWidget {
  final double creditAmount;
  final double interestRate;
  final int maxRange;
  final int minRange;
  final String footer;
  final Function(double) onAmountChanged;

  const CreditWidget({
    super.key,
    required this.creditAmount,
    required this.interestRate,
    required this.onAmountChanged,
    required this.maxRange,
    required this.minRange,
    required this.footer,
  });

  @override
  State<CreditWidget> createState() => _CreditWidgetState();
}

class ClickableContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color color;
  final BorderRadius borderRadius;

  const ClickableContainer({
    super.key,
    required this.child,
    required this.onPressed,
    this.color = Colors.transparent,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(500.0), // Adjust the radius as needed
    ),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(color: color, borderRadius: borderRadius),
        child: child,
      ),
    );
  }
}

class _CreditWidgetState extends State<CreditWidget> {
  double _currentAmount = 150000; // Initial credit amount
  final double _currentRate = 1.04; // Initial interest rate
  double _greenangle = pi;
  Offset offsetCenter = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              RenderBox box = context.findRenderObject() as RenderBox;
              Offset localTouchPosition = box.globalToLocal(
                details.globalPosition,
              );

              double centerX = 100; // Center of the dialer (100, 100)
              double centerY = 100;
              double angle = atan2(
                localTouchPosition.dy - centerY,
                localTouchPosition.dx - centerX,
              );

              if (angle < 0) {
                angle += 2 * pi;
              }

              double amount =
                  (angle / (2 * pi)) * (widget.maxRange - widget.minRange) +
                      widget.minRange; // Use range from API
              amount = amount.clamp(
                widget.minRange.toDouble(),
                widget.maxRange.toDouble(),
              );
              widget.onAmountChanged(amount);

              setState(() {
                _currentAmount = amount;
                _greenangle = angle;
              });
            },
            child: RepaintBoundary(
              child: CustomPaint(
                size: const Size(200, 200),
                painter: CreditPainter(
                  creditAmount: widget.creditAmount,
                  interestRate: widget.interestRate,
                  greenArcAngle: _greenangle,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'credit amount',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              SizedBox(height: 4),
              Text(
                '₹${_currentAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                '@ ${_currentRate.toStringAsFixed(2)}% monthly',
                style: TextStyle(fontSize: 10, color: Colors.green),
              ),
            ],
          ),
          CaptionContainer(
            caption: widget.footer,
            margin: EdgeInsets.only(left: 40.0, top: 40.0, right: 40.0),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }
}

class CreditPainter extends CustomPainter {
  final double creditAmount;
  final double interestRate;
  final double greenArcAngle;

  CreditPainter({
    required this.creditAmount,
    required this.interestRate,
    required this.greenArcAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;

    // Track (Background Arc)
    final Paint trackPaint = Paint()
      ..color = const Color.fromARGB(255, 236, 192, 166) // Dark gray track
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    canvas.drawCircle(Offset(radius, radius), radius - 4, trackPaint);

    // Green Arc (Progress)
    final Paint progressPaint = Paint()
      ..color = const Color.fromARGB(255, 240, 102, 10) // Teal progress
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    final double sweepAngle = (creditAmount / 487891) * 2 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius - 4),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    final double indicatorAngle = -pi / 2 + sweepAngle;
    final double lineLength = 5;
    final double lineWidth = 10;
    final Offset indicatorCenter = Offset(
      radius + (radius - 6) * cos(indicatorAngle),
      radius + (radius - 6) * sin(indicatorAngle),
    );

    final Offset lineStart = Offset(
      indicatorCenter.dx + (-lineLength / 2) * cos(indicatorAngle),
      indicatorCenter.dy + (-lineLength / 2) * sin(indicatorAngle),
    );
    final Offset lineEnd = Offset(
      indicatorCenter.dx + (lineLength / 2) * cos(indicatorAngle),
      indicatorCenter.dy + (lineLength / 2) * sin(indicatorAngle),
    );

    // Blue Indicator (Line and Circle)
    final Paint linePaint = Paint()
      ..color = const Color.fromARGB(255, 40, 116, 187) // Blue indicator
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(lineStart, lineEnd, linePaint);

    final double circleRadius = 15;
    // Blue Indicator (Line and Circle)
    final Paint circlePaint = Paint()
      ..color = const Color.fromARGB(255, 2, 5, 10) // Blue indicator
      ..strokeWidth = 10
      ..style = PaintingStyle.fill;

    canvas.drawCircle(lineEnd, circleRadius, circlePaint);

    final Paint circleBorderPaint = Paint()
      ..color = const Color(0xFFFFAB91) // Light orange border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(lineEnd, circleRadius, circleBorderPaint);
  }

  @override
  bool shouldRepaint(CreditPainter oldDelegate) {
    return oldDelegate.creditAmount != creditAmount ||
        oldDelegate.greenArcAngle != greenArcAngle;
  }
}

class CaptionContainer extends StatelessWidget {
  final String caption;
  final EdgeInsets margin;
  final Alignment alignment;

  const CaptionContainer({
    super.key,
    required this.caption,
    this.margin = const EdgeInsets.all(8.0),
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          caption,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
