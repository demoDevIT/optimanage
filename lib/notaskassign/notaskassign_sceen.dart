import 'package:flutter/material.dart';

import '../constant/common.dart';

class NoTaskAssignScreen extends StatelessWidget {
  const NoTaskAssignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: common.Appbar(
        title: "No Task Assigned",
        callback: () {
          Navigator.of(context).pop(false);
        },
        actions: [
          // LanguageToggleSwitch(),
          Image.asset(
            'assets/icons/notification.png',
            width: 24,
            height: 24,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Task Details (29-04-2025)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '(No Task Assigned)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87, // soft gray as per screenshot
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),

            // Task Description
            _buildTextField(
              hintText: 'Daily Task Details',
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            // Date Pickers
            Row(
              children: [
                Expanded(
                  child: _buildDateField('Start Date', '01 April, 2025'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateField('End Date', '01 April, 2025'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Task Hour & Minute
            _buildTextField(hintText: 'Task Hour'),
            const SizedBox(height: 12),
            _buildTextField(hintText: 'Task Minute'),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle form submission
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25507C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18, // 👈 Increase this for larger text
                      fontWeight: FontWeight.w600, // Optional: make it semi-bold
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String hintText, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: const Color(0xFFF3F7FE),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDateField(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/calendar.png',
            width: 20,
            height: 20,
            //color: Colors.purple, // matches screenshot tint
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
