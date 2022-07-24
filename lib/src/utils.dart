import 'dart:math';
import 'package:flutter/material.dart';

double getDistanceAngle(int? count, int? children) {
  return count == null ? (360 / children!) : (360 / count);
}

  double getAngle(double halfWidth, double halfHeight, Offset position) {
    var x = position.dx - halfWidth;
    var y = position.dy - halfHeight;
    var angle = atan2(y, x);
    var degreeangle = angle * 180 / pi;
    return degreeangle;
  }

extension CircularExt on double {
  double get radians {
    return this * (pi / 180);
  }
}
