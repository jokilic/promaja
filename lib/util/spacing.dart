import 'package:flutter/material.dart';

const double navigationBarHeight = 80;

double getCurrentCardBottomPadding(BuildContext context) => MediaQuery.paddingOf(context).bottom + navigationBarHeight + 20;

double getWeatherCardBottomPadding(BuildContext context) => MediaQuery.paddingOf(context).bottom + 20;

double getWeatherSummaryCardTopPadding(BuildContext context) => MediaQuery.paddingOf(context).top + 24;

double getWeatherCardContentHeight(BuildContext context) => MediaQuery.sizeOf(context).height - getWeatherCardBottomPadding(context);
