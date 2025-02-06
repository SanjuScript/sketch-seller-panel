  import 'package:flutter/material.dart';

  class ShimmerContainer extends StatefulWidget {
    final double width;
    final double height;
    final BorderRadiusGeometry? borderraduis;

    const ShimmerContainer(
        {super.key, this.width = 200, this.height = 100, this.borderraduis});

    @override
    _ShimmerContainerState createState() => _ShimmerContainerState();
  }

  class _ShimmerContainerState extends State<ShimmerContainer>
      with SingleTickerProviderStateMixin {
    late AnimationController _controller;

    @override
    void initState() {
      super.initState();
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      )..repeat();
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: widget.width,
            height: widget.height,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: widget.borderraduis ?? BorderRadius.circular(0),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, offset: Offset(2, -2), blurRadius: 10),
              ],
              gradient: LinearGradient(
                begin: Alignment(-1 + _controller.value * 2, -1),
                end: Alignment(1 + _controller.value * 2, 1),
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade100,
                  Colors.grey.shade400,
                ],
              ),
            ),
          );
        },
      );
    }
  }
