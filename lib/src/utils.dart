import 'dart:math';

double getDistanceAngle(int? count, int? children) {
  return count == null ? (360 / children!) : (360 / count);
}

extension CircularExt on double {
  double get radians {
    return this * (pi / 180);
  }
}
