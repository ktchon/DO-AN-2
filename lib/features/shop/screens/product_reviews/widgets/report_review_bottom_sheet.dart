import 'package:flutter/material.dart';

class ReportReviewBottomSheet {
  static void show(BuildContext context, Function(String reason) onSubmit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        String selectedReason = "";
        final TextEditingController otherController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Báo cáo bình luận",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  const Divider(),

                  ...[
                    "Spam",
                    "Nội dung không phù hợp",
                    "Lừa đảo",
                    "Khác"
                  ].map((reason) {
                    return ListTile(
                      title: Text(reason),
                      leading: Radio(
                        value: reason,
                        groupValue: selectedReason,
                        onChanged: (value) =>
                            setState(() => selectedReason = value!),
                      ),
                    );
                  }),

                  if (selectedReason == "Khác")
                    TextField(
                      controller: otherController,
                      decoration:
                          const InputDecoration(hintText: "Nhập lý do..."),
                    ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      final finalReason = selectedReason == "Khác"
                          ? otherController.text
                          : selectedReason;

                      onSubmit(finalReason);
                      Navigator.pop(context);
                    },
                    child: const Text("Gửi báo cáo"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}