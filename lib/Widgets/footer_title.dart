import 'package:flutter/material.dart';

class footertitle extends StatelessWidget {
  const footertitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // থিম অনুযায়ী কালার সেট করার জন্য
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          // কার্ডের ব্যাকগ্রাউন্ড কালার ডার্ক মোড অনুযায়ী পরিবর্তন হবে
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Developed by",
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 12,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "AshrafIT",
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // একটি ছোট স্টাইলিশ লাইন
            Container(
              height: 2,
              width: 25,
              decoration: BoxDecoration(
                color: Colors.pinkAccent.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}