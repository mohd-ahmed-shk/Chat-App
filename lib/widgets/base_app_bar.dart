import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final bool? automaticallyImplyLeading;
  final bool? centerTitle;
  final double? leadingWidth;
  @override
  final Size preferredSize;

  const BaseAppBar(
      {super.key, this.preferredSize = const Size.fromHeight(kToolbarHeight), required this.title, this.automaticallyImplyLeading, this.centerTitle, this.leadingWidth});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leadingWidth: leadingWidth,
      backgroundColor: Colors.orange,
      automaticallyImplyLeading: automaticallyImplyLeading ?? false,
      centerTitle: centerTitle ?? false,
    );
  }
}
