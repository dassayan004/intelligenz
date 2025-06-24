import 'package:flutter/material.dart';
import 'package:intelligenz/core/constants/color_constant.dart';

class TRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const TRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: kSkyBlue300,
      backgroundColor: kNeutralWhite,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
