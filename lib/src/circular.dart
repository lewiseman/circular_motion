import 'dart:math';
import 'package:flutter/physics.dart';

import 'utils.dart';
import 'package:flutter/material.dart';

/// Creates widgets positioned in a circular position
/// that are able to rotate around the center of the widget.
///
/// This example shows how to use the [CircularMotion.builder] widget.
///
/// ```dart
///CircularMotion.builder(
///    itemCount: 18,
///    centerWidget: Text('Center'),
///    builder: (context, index) {
///      return Text('$index');
///    }
///)
/// ```
///
/// This example shows how to use the [CircularMotion] widget.
///
/// ```dart
///CircularMotion(
///    centerWidget: Text('Center'),
///    children: [
///     Text('0'),
///     Text('1'),
///     Text('2'),
///     Text('3'),
///  ],
///)
/// ```
///
class CircularMotion extends StatefulWidget {
  final bool useBuilder;

  ///Builder function to create the widget at the given index in a circular position.
  final IndexedWidgetBuilder? builder;

  ///Widgets to be positioned in a circular position.
  final List<Widget>? children;

  /// The widget that is positioned in the center.
  final Widget? centerWidget;

  ///Number of items expected in the builder
  final int? itemCount;

  /// Creates a scrollable, circular array of widgets that are created on demand.
  ///This constructor is appropriate for a large number of children.
  const CircularMotion.builder({
    Key? key,
    required this.builder,
    required this.itemCount,
    this.centerWidget,
  })  : useBuilder = true,
        children = null,
        super(key: key);

  /// Creates a scrollable, circular array of widgets from an explicit [List].
  /// This constructor is appropriate for a small number of children
  const CircularMotion({
    Key? key,
    required this.children,
    this.centerWidget,
  })  : useBuilder = false,
        builder = null,
        itemCount = null,
        super(key: key);

  @override
  State<CircularMotion> createState() => _CircularMotionState();
}

class _CircularMotionState extends State<CircularMotion>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double angle = 0;
  int prevPosInt = 1;

  void runDeceleration(double velocity) {
    final Simulation simulation = FrictionSimulation(.08, angle + 1, velocity);
    _animationController.animateWith(simulation);
  }

  @override
  void initState() {
    _animationController = AnimationController.unbounded(vsync: this);
    _animationController.addListener(() {
      if ((angle.toInt() - _animationController.value.toInt()) == 0) {
        _animationController.stop();
      } else {
        setState(() {
          angle = _animationController.value.toInt().toDouble();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double distanceAngle =
        getDistanceAngle(widget.itemCount, widget.children?.length);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size boxSize = constraints.biggest;
        var halfWidth = boxSize.width / 2;
        var halfHeight = boxSize.height / 2;
        return GestureDetector(
          onVerticalDragStart: (details) => _animationController.stop(),
          onVerticalDragUpdate: (details) {
            var pos = getAngle(halfWidth, halfHeight, details.localPosition);
            var x = updateScrollDirection(pos, false);
            setState(() {
              angle += ((details.primaryDelta ?? 0) * x);
            });
          },
          onVerticalDragEnd: (details) {
            prevPos = null;
            runDeceleration((details.primaryVelocity ?? 0) * prevPosInt);
          },
          onHorizontalDragStart: (details) => _animationController.stop(),
          onHorizontalDragUpdate: (details) {
            var pos = getAngle(halfWidth, halfHeight, details.localPosition);
            var x = updateScrollDirection(pos, true);
            setState(() {
              angle += ((details.primaryDelta ?? 0) * x);
            });
          },
          onHorizontalDragEnd: (details) {
            prevPos = null;
            runDeceleration((details.primaryVelocity ?? 0) * prevPosInt);
          },
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
                ) +
                [
                  Align(
                    alignment: const Alignment(0, 0),
                    child: widget.centerWidget,
                  ),
                ],
          ),
        );
      },
    );
  }

  String? prevPos;

  int updateScrollDirection(double angle, bool isHorizontal) {
    if (angle > 0 && angle < 90 && prevPos == null) {
      //Bottom right'
      prevPos = 'dnB';
      prevPosInt = isHorizontal ? -1 : 1;
      prevPosInt = isHorizontal ? -1 : 1;
      return prevPosInt;
    } else if (angle > 90 && angle < 180 && prevPos == null) {
      //Bottom left
      prevPos = 'dnA';
      prevPosInt = -1;
      return prevPosInt;
    } else if (angle < 0 && angle > -90 && prevPos == null) {
      //Top right
      prevPos = 'upB';
      prevPosInt = 1;
      return prevPosInt;
    } else if (angle < -90 && angle > -180 && prevPos == null) {
      //Top left
      prevPos = 'upA';
      prevPosInt = isHorizontal ? 1 : -1;
      return prevPosInt;
    } else {
      return prevPosInt;
    }
  }
}
