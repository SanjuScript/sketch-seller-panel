import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CustomKeepAliveMe extends StatefulWidget {
  final Widget child;
  final bool keepAlive;
  const CustomKeepAliveMe({
    super.key,
    required this.child,
    this.keepAlive = false,
  });

  @override
  State<CustomKeepAliveMe> createState() => _CustomKeepAliveMeState();
}

class _CustomKeepAliveMeState extends State<CustomKeepAliveMe>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => widget.keepAlive || !kDebugMode;
}
