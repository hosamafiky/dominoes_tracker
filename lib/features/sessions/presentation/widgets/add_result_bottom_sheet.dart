import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/session.dart';
import '../cubit/session_cubit.dart';

class AddResultBottomSheet extends StatefulWidget {
  final Session session;
  const AddResultBottomSheet({super.key, required this.session});

  @override
  State<AddResultBottomSheet> createState() => _AddResultBottomSheetState();
}

class _AddResultBottomSheetState extends State<AddResultBottomSheet> {
  String? winningTeamId;
  String pointsStr = '0';

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'Del') {
        if (pointsStr.length > 1) {
          pointsStr = pointsStr.substring(0, pointsStr.length - 1);
        } else {
          pointsStr = '0';
        }
      } else {
        if (pointsStr == '0') {
          pointsStr = key;
        } else {
          pointsStr += key;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 0.85.sh,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.backgroundDark : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      padding: EdgeInsets.all(24.dg),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Record Result',
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            32.verticalSpace,
            Text(
              'WHO WON?',
              style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, letterSpacing: 1.2.sp),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => winningTeamId = widget.session.team1Name),
                    child: _WinnerCard(name: widget.session.team1Name, isSelected: winningTeamId == widget.session.team1Name),
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => winningTeamId = widget.session.team2Name),
                    child: _WinnerCard(name: widget.session.team2Name, isSelected: winningTeamId == widget.session.team2Name),
                  ),
                ),
              ],
            ),
            32.verticalSpace,
            Text(
              'ENTER POINTS',
              style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, letterSpacing: 1.2.sp),
            ),
            16.verticalSpace,
            Center(
              child: Text(
                pointsStr,
                style: TextStyle(fontSize: 72.sp, fontWeight: FontWeight.w900),
              ),
            ),
            24.verticalSpace,
            _Keypad(onKeyPress: _onKeyPress),
            SizedBox(
              width: double.infinity,
              height: 60.h,
              child: ElevatedButton(
                onPressed: winningTeamId == null || pointsStr == '0'
                    ? null
                    : () {
                        context.read<SessionCubit>().recordRound(winningTeamId!, int.parse(pointsStr));
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
                ),
                child: Text(
                  'SAVE ROUND',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WinnerCard extends StatelessWidget {
  final String name;
  final bool isSelected;

  const _WinnerCard({required this.name, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: isSelected ? AppTheme.primary : Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppTheme.primary : Colors.grey),
        ),
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  final ValueChanged<String> onKeyPress;

  const _Keypad({required this.onKeyPress});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      alignment: WrapAlignment.center,
      children: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'Del'].map((key) => _KeypadButton(label: key, onTap: () => onKeyPress(key))).toList(),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _KeypadButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isAction = label == 'Del';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: isAction ? Colors.red.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: isAction ? Colors.red : Colors.white),
          ),
        ),
      ),
    );
  }
}
