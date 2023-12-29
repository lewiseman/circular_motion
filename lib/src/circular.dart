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

  /// Number of items expected in the builder
  final int? itemCount;

  ///  Use this to control the behavior of the guestures.
  /// eg : if you want guestures to respond also in areas with no child item add
  /// ```dart
  ///behavior: HitTestBehavior.translucent,
  /// ```
  final HitTestBehavior? behavior;

  final bool speedRunEnabled;

  /// Creates a scrollable, circular array of widgets that are created on demand.
  ///This constructor is appropriate for a large number of children.
  const CircularMotion.builder(
      {super.key,
      required this.builder,
      required this.itemCount,
      this.centerWidget,
      this.behavior,
      this.speedRunEnabled = true})
      : useBuilder = true,
        children = null;

  /// Creates a scrollable, circular array of widgets from an explicit [List].
  /// This constructor is appropriate for a small number of children
  const CircularMotion({
    super.key,
    required this.children,
    this.centerWidget,
    this.behavior,
    this.speedRunEnabled = true,
  })  : useBuilder = false,
        builder = null,
        itemCount = null;

  @override
  State<CircularMotion> createState() => _CircularMotionState();
}

class _CircularMotionState extends State<CircularMotion>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  //The current angle of the widget from the center in degrees and clockwise direction.
  double angle = 0;

  /// This acts a direction . It is either 1 or -1. Its updated by scroll gestures , then used to update the angle.
  /// Also used by the runDeceleration(speedRun) feature , since that happens after the scroll gesture is done.
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
    ///Angle spacing to be expected between each item.
    final double distanceAngle = getDistanceAngle(
      widget.itemCount,
      widget.children?.length,
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size boxSize = constraints.biggest;
        var halfWidth = boxSize.width / 2;
        var halfHeight = boxSize.height / 2;
        return GestureDetector(
          behavior: widget.behavior,
          onVerticalDragStart: (details) => _animationController.stop(),
          onVerticalDragUpdate: (details) {
            var pos = getAngle(halfWidth, halfHeight, details.localPosition);
            var x = updateScrollDirection(pos, false);
            setState(() {
              angle += ((details.primaryDelta ?? 0) * x);
            });
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
            if (widget.speedRunEnabled) {
              runDeceleration((details.primaryVelocity ?? 0) * prevPosInt);
            }
          },
          onVerticalDragEnd: (details) {
            prevPos = null;
            if (widget.speedRunEnabled) {
              runDeceleration((details.primaryVelocity ?? 0) * prevPosInt);
            }
          },
          child: Container(
            color: Colors.yellow,
            child: Stack(
              /// The [Align] widget is used because its starting point (0,0) is the center of the available space, making it easier to position the widgets in a circular manner.
              /// Additionally, the alignment property of [Align] allows us to specify the farthest x and y bounds as either 1 or -1, regardless of the available space's aspect ratio.
              /// This makes it convenient for positioning the widgets circularly, regardless of the size or shape of the container.
              /// Therefore utilizing  the Unit Circle to position the widgets. (https://en.wikipedia.org/wiki/Unit_circle#/media/File:Unit_circle.svg)
              /// Also note the the x and y go in clockwise direction rather than the anticlockwise direction of the unit circle , but tey position the widgets in the same manner.
              children: List.generate(
                    (widget.itemCount ?? widget.children?.length ?? 0),
                    (index) {
                      /// Each angle at which the widget is from the center.
                      /// We add -90 to the angle because the starting point of the unit circle is at 3 o'clock, but we want it to be at 12 o'clock.
                      final itemAngle = (angle + -90) + (distanceAngle * index);
                      final xPos = cos(itemAngle.radians);
                      final yPos = sin(itemAngle.radians);
                      return Align(
                        alignment: Alignment(xPos, yPos),
                        child: widget.useBuilder
                            ? widget.builder!(context, index)
                            : widget.children![index],
                      );
                    },
                  ) +
                  [
                    Align(
                      alignment: const Alignment(0, 0),
                      child: widget.centerWidget,
                    ),
                  ],
            ),
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
