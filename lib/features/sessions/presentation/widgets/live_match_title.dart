import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/session.dart';

class LiveMatchTitle extends StatelessWidget {
  final Session session;

  const LiveMatchTitle({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Game History',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            'Limit: ${session.limit} pts',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[500], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
