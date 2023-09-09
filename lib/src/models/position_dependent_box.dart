import 'package:flutter/material.dart';

class PositionDependentBox2 {
  final Offset offset;

  final AxisDirection axisDirection;

  const PositionDependentBox2({
    required this.offset,
    required this.axisDirection,
  });

  PositionDependentBox2 copyWith({
    Offset? offset,
    AxisDirection? axisDirection,
  }) {
    return PositionDependentBox2(
      offset: offset ?? this.offset,
      axisDirection: axisDirection ?? this.axisDirection,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PositionDependentBox2 &&
        other.offset == offset &&
        other.axisDirection == axisDirection;
  }

  @override
  int get hashCode => offset.hashCode ^ axisDirection.hashCode;

  @override
  String toString() {
    return 'PositionDependentBox(  $offset,  $axisDirection  )';
  }
}
