import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ShowCustomToast {
  static final toastification = Toastification();
  static void showToast(
      {required BuildContext context,
      Alignment loc = Alignment.bottomCenter,
      Widget icon = const Icon(Icons.check),
      ToastificationType type = ToastificationType.success,
      int sec = 3,
      required String msg}) {
    toastification.show(
      context: context,
      type:type,
      style: ToastificationStyle.flat,
      autoCloseDuration:  Duration(seconds: sec),
      description: RichText(
              text: TextSpan(
              text: msg,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(),
            ))
         ,
      alignment: loc,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: icon,
      showIcon: true,
      primaryColor: Colors.green,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: false,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => log('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            log('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            log('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => log('Toast ${toastItem.id} dismissed'),
      ),
    );
  }
}
