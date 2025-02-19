import 'package:drawer_panel/HELPERS/CONSTANTS/global_texts.dart';
import 'package:drawer_panel/HELPERS/CONSTANTS/show_toast.dart';
import 'package:flutter/material.dart';

void showImageIssueDialog(BuildContext context, Function(String) onSubmit) {
  String? selectedIssue;
  TextEditingController customIssueController = TextEditingController();
  ScrollController scrollController = ScrollController();
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Report Image Issue",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please select the issue with the uploaded image:",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Scrollbar(
                  trackVisibility: true,
                  thumbVisibility: true,
                  interactive: true,
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          children: [
                            ...issues.map((issue) {
                              return RadioListTile<String>(
                                title: Text(
                                  issue,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        letterSpacing: 0,
                                      ),
                                ),
                                value: issue,
                                groupValue: selectedIssue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedIssue = value;
                                  });
                                },
                              );
                            }).toList(),
                            if (selectedIssue == "Other (Specify below)")
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: customIssueController,
                                  decoration: InputDecoration(
                                    hintText: "Enter your issue",
                                    hintStyle:
                                        Theme.of(context).textTheme.labelSmall,
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String finalIssue =
                          selectedIssue == "Other (Specify below)"
                              ? customIssueController.text.trim()
                              : selectedIssue ?? "No issue selected";

                      if (finalIssue.isEmpty ||
                          finalIssue == "No issue selected") {
                        showToast("No issue selected");
                        return;
                      }

                      onSubmit(finalIssue);
                      Navigator.pop(context);
                    },
                    child: const Text("Submit"),
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
