import 'dart:math';
import 'utils.dart';
import 'package:flutter/material.dart';

class CircularMotion extends StatefulWidget {
  final bool useBuilder;
  final IndexedWidgetBuilder? builder;
  final List<Widget>? children;
  final int? itemCount;

  const CircularMotion.builder({
    Key? key,
    required this.builder,
    required this.itemCount,
  })  : useBuilder = true,
        children = null,
        super(key: key);

  const CircularMotion({
    Key? key,
    required this.children,
  })  : useBuilder = false,
        builder = null,
        itemCount = null,
        super(key: key);

  @override
  State<CircularMotion> createState() => _CircularMotionState();
}

class _CircularMotionState extends State<CircularMotion>
    with SingleTickerProviderStateMixin {
  double angle = 0;

  @override
  Widget build(BuildContext context) {
    final double distanceAngle =
        getDistanceAngle(widget.itemCount, widget.children?.length);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          child: Stack(
            children: List.generate(
              (widget.itemCount ?? widget.children?.length ?? 0),
              (index) => Align(
                alignment: Alignment(
                  (cos((angle + (distanceAngle * index)).radians) * 1),
                  (sin((angle + (distanceAngle * index)).radians) * 1),
                ),
                child: widget.useBuilder
                    ? widget.builder!(context, index)
                    : widget.children![index],
              ),
            ),
          ),
        );
      },
    );
  }

}
