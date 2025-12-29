import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/session.dart';
import '../cubit/session_cubit.dart';
import 'add_result_bottom_sheet.dart';

class AddRoundAction extends StatelessWidget {
  final Session session;

  const AddRoundAction({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 60.h,
            child: ElevatedButton.icon(
              onPressed: () => _showAddResult(context, session),
              icon: Icon(Icons.add_circle, size: 24.sp),
              label: Text(
                'RECORD RESULT',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
              ),
            ),
          ),
          16.verticalSpace,
          TextButton(
            onPressed: () => context.push('/session-summary/${session.id}'),
            child: Text(
              'FINISH SESSION',
              style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddResult(BuildContext context, Session session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<SessionCubit>(),
        child: AddResultBottomSheet(session: session),
      ),
    );
  }
}
