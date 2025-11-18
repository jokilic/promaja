import 'package:flutter/material.dart';

const double navigationBarHeight = 80;

double getCardBottomPadding(BuildContext context) => MediaQuery.paddingOf(context).bottom + navigationBarHeight + 20;

double getWeatherSummaryCardTopPadding(BuildContext context) => MediaQuery.paddingOf(context).top + 24;
