import 'package:flutter/material.dart';

const double navigationBarHeight = 80;

double getCardBottomPadding(BuildContext context) {
  final bottomPadding = MediaQuery.paddingOf(context).bottom + navigationBarHeight + 20;
  return bottomPadding;
}
