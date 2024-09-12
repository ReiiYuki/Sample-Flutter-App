import 'package:flutter/material.dart';

class LinePainter extends CustomPainter { 
  final double animationValue; // Animation value to control line position 
  
  LinePainter(this.animationValue); 
  
  @override 
  void paint(Canvas canvas, Size size) { 
    final paint = Paint() 
      ..color = Colors.green // Line color 
      ..style = PaintingStyle.stroke // Stroke style 
      ..strokeWidth = 5.0; // Stroke width 
  
    final double startX = 0; 
    final double endX = size.width; 
    final double y = size.height / 2; 
  
    final double currentX = startX + (endX - startX) * animationValue; 
  
    // Draw the line 
    canvas.drawLine(Offset(startX, y), Offset(currentX, y), paint); 
  } 
  
  @override 
  bool shouldRepaint(covariant CustomPainter oldDelegate) { 
    return true; // Repaint the line continuously 
  } 
}

class OverlaySamplePage extends StatefulWidget {
  const OverlaySamplePage({super.key});

  @override
  State<OverlaySamplePage> createState() => _OverlaySamplePageState();
}

class _OverlaySamplePageState extends State<OverlaySamplePage> with SingleTickerProviderStateMixin {
  late OverlayEntry _overlayEntry;
  late AnimationController _controller;
  bool tick = false;

  @override 
  void initState() { 
    super.initState(); 
    _controller = AnimationController( 
      vsync: this, // Synchronize animation with this widget 
      duration: const Duration(seconds: 2), // Animation duration 
    )..repeat(reverse: true); // Repeat the animation back and forth 
  } 

  @override
  void dispose() {
    removeOverlay();
    _controller.dispose();

    super.dispose();
  }

  removeOverlay() {
    _overlayEntry.remove();
    _overlayEntry.dispose();
  }

  showOverlay(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          removeOverlay();
        },
        child: Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                height: 500,
                width: 200,
                color: Color.fromARGB(107, 255, 61, 61),
                child: Center(child: ElevatedButton(child: Text("Button on Overlay"), onPressed: () {},),),
              ),
          ),
        ),
      );

    Overlay.of(context).insert(_overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Overlay Sample"),
      ),
      body: ListView(
          children: [
                Container(),
                  ElevatedButton(
                    child: const Text('Show Overlay'),
                    onPressed: () {
                      showOverlay(context);
                    },
                  ),
                  AnimatedBuilder(animation: _controller, builder: (context, child) { 
                    return CustomPaint( 
                      size: Size( 
                        MediaQuery.of(context).size.width, 
                        100.0, 
                      ), 
                      painter: LinePainter( 
                          _controller.value), // Use LinePainter to draw the line 
                    ); 
                  }),
                  // Center(
                  //   child: AnimatedPositioned(
                  //     top: tick ? 300 : 600,
                  //     left: 0,
                  //     right: 0,
                  //     width: 50,
                  //     duration: const Duration(seconds: 3),
                  //     curve: Curves.easeIn,
                  //     child: GestureDetector(
                  //         onTap: () {
                  //           setState(() {
                  //             tick = !tick;
                  //           });
                  //         },
                  //         child: Container(
                  //           color: const Color.fromARGB(42, 221, 0, 0),
                  //           width: 100,
                  //           height: 100,
                  //         ),
                  //     ),
                  //   ),
                  // )
                ],
      ),
    );
  }
}