import 'package:flutter/material.dart';

class DrawerHeaders extends StatelessWidget {
  const DrawerHeaders({super.key, this.title = 'Fake Store', this.caption});
  final Color onPrimary = Colors.white;
  final String title;
  final String? caption; // pass user?.email or empty string
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              color: onPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(caption!, style: TextStyle(color: onPrimary.withOpacity(.85))),
        ],
      ),
    );
  }
}
