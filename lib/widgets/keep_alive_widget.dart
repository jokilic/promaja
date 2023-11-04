import 'package:flutter/material.dart';

class KeepAlivePage extends StatefulWidget {
  final Widget child;
  final bool keepAlive;

  const KeepAlivePage({
    required this.child,
    this.keepAlive = true,
    super.key,
  });

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
