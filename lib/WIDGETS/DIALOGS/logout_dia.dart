import 'package:drawer_panel/FUNCTIONS/AUTH_FUNCTIONS/admin_auth_functions.dart';
import 'package:flutter/material.dart';

void showLogoutDialogue({
  required BuildContext context,
}) {
  // CustomBlurDialog.show(
  //   context: context,
  //   title: 'Confirm Logout',
  //   content: 'Are you sure you want to log out?',
  //   actions: [
  //     TextButton(
  //       onPressed: () {
  //         Navigator.of(context).pop();
  //       },
  //       child: const Text(
  //         'Cancel',
  //         style: TextStyle(color: Colors.deepPurple, fontSize: 18),
  //       ),
  //     ),
  //     TextButton(
  //       onPressed: () async {
  //         Navigator.of(context).pop();
  //         await AuthenticationFn.logout(context);
  //       },
  //       child: const Text(
  //         'Log out',
  //         style: TextStyle(color: Colors.red, fontSize: 18),
  //       ),
  //     ),
  //   ],
  // );
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            width: 300,
            height: MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(12, 26),
                      blurRadius: 50,
                      spreadRadius: 0,
                      color: Colors.grey.withOpacity(.1)),
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text("Confirm Logout",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 3.5,
                ),
                const Text("Are you sure want to log out?",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w300)),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SimpleBtn1(
                        text: "Cancel",
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    SimpleBtn1(
                      text: "Log out",
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await AuthenticationFn.logout(context);
                      },
                      invertedColors: true,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

class SimpleBtn1 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool invertedColors;
  const SimpleBtn1(
      {required this.text,
      required this.onPressed,
      this.invertedColors = false,
      super.key});
  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: WidgetStateProperty.all(0),
            alignment: Alignment.center,
            side: WidgetStateProperty.all(
                BorderSide(width: 1, color: primaryColor)),
            padding: WidgetStateProperty.all(
                const EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 0)),
            backgroundColor: WidgetStateProperty.all(
                invertedColors ? accentColor : primaryColor),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            )),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: invertedColors ? primaryColor : accentColor, fontSize: 16),
        ));
  }
}
