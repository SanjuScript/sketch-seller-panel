import 'package:drawer_panel/WIDGETS/BUTTONS/dialogue_buttons.dart';
import 'package:flutter/material.dart';

void showMarkAsStartedDialogue({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: 300,
          height: MediaQuery.of(context).size.height / 3.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                offset: const Offset(12, 26),
                blurRadius: 50,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.1),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Text(
                "Confirm Action",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to mark this work as started?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Warning: This action cannot be undone!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SimpleBtn1(
                    text: "Cancel",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SimpleBtn1(
                    text: "Confirm",
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    invertedColors: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
