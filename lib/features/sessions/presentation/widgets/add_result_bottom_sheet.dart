import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
  int _points = 0; // Default as per design showing 25

  // Custom Colors
  static const Color _primary = Color(0xFF11D411);
  static const Color _surfaceDark = Color(0xFF111811); // Darker shade from HTML
  static const Color _accentGold = Color(0xFFFFAA00);

  @override
  void initState() {
    super.initState();
    // Default selecting team 1 for quick access or keep null?
    // Design suggests "Us" is checked by default in HTML (checked="" attribute)
    // So I'll default to first team.
    winningTeamId = widget.session.team1Name;
  }

  void _updatePoints(int delta) {
    setState(() {
      _points = (_points + delta).clamp(0, 999);
    });
  }

  void _onSave() {
    if (winningTeamId != null) {
      context.read<SessionCubit>().recordRound(winningTeamId!, _points);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine round number (generic or theoretical next)
    // Since we don't have round count, we can omit specific number or just say "New Round"
    // But to match design "Round 4 • Game 12", I'll use placeholders or generic text.
    final subheading = "${widget.session.team1Name} vs ${widget.session.team2Name}";

    return Container(
      height: 0.85.sh,
      decoration: BoxDecoration(
        color: _surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 30, offset: const Offset(0, -8))],
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      ),
      child: Column(
        children: [
          _buildHandle(),
          _buildHeader(subheading),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionTitle('WHO WON?'),
                  SizedBox(height: 12.h),
                  _buildWinnerSelection(),
                  SizedBox(height: 24.h),
                  Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
                  SizedBox(height: 24.h),
                  _buildSectionTitle('POINTS SCORED'),
                  SizedBox(height: 16.h),
                  _buildScoreStepper(),
                  SizedBox(height: 16.h),
                  _buildQuickPresets(),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 12.h, bottom: 4.h),
        width: 48.w,
        height: 6.h,
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(3.r)),
      ),
    );
  }

  Widget _buildHeader(String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Column(
        children: [
          Text(
            'Record Result',
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold, height: 1.2),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(color: Colors.white.withValues(alpha: 0.5), fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Center(
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(color: Colors.white.withValues(alpha: 0.7), fontSize: 12.sp, fontWeight: FontWeight.w600, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildWinnerSelection() {
    return Row(
      children: [
        Expanded(
          child: _WinnerCard(
            name: widget.session.team1Name,
            subtitle: "Currently ${widget.session.team1Score} pts", // Or specific score if available
            isSelected: winningTeamId == widget.session.team1Name,
            onTap: () => setState(() => winningTeamId = widget.session.team1Name),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _WinnerCard(
            name: widget.session.team2Name,
            subtitle: "Currently ${widget.session.team2Score} pts",
            isSelected: winningTeamId == widget.session.team2Name,
            onTap: () => setState(() => winningTeamId = widget.session.team2Name),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreStepper() {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StepperButton(icon: Icons.remove, color: Colors.white, backgroundColor: Colors.white.withValues(alpha: 0.1), onTap: () => _updatePoints(-1)),
          Column(
            children: [
              Text(
                '$_points',
                style: GoogleFonts.plusJakartaSans(color: _accentGold, fontSize: 48.sp, fontWeight: FontWeight.w800, height: 1.0),
              ),
              Text(
                'POINTS',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          _StepperButton(
            icon: Icons.add,
            color: _primary,
            backgroundColor: _primary.withValues(alpha: 0.2),
            borderColor: _primary.withValues(alpha: 0.3),
            onTap: () => _updatePoints(1),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPresets() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 8.w,
      mainAxisSpacing: 8.h,
      childAspectRatio: 0.8,
      children: [
        _PresetButton(label: 'Min', value: '+10', onTap: () => _updatePoints(10)),
        _PresetButton(label: 'Avg', value: '+25', onTap: () => _updatePoints(25)),
        _PresetButton(label: 'High', value: '+50', onTap: () => _updatePoints(50)),
        _PresetButton(
          label: '', // Icons handling inside
          value: 'Domino!',
          isSpecial: true,
          onTap: () {
            // Functionality for Domino! button. Maybe add bonus or zero?
            // For now, let's say it adds 0 but highlights.
            _updatePoints(0);
            // Or maybe a toast?
          },
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            _surfaceDark,
            _surfaceDark, // Solid surface color at bottom
            _surfaceDark.withValues(alpha: 0.0), // Fade out
          ],
          stops: const [0.0, 0.4, 1.0], // More solid area
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: _onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.black,
                elevation: 8,
                shadowColor: _primary.withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Save Game',
                    style: GoogleFonts.plusJakartaSans(fontSize: 18.sp, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                  SizedBox(width: 8.w),
                  const Icon(Icons.arrow_forward_rounded, size: 22),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.white.withValues(alpha: 0.6)),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 16.sp),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom / 2),
        ],
      ),
    );
  }
}

class _WinnerCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _WinnerCard({required this.name, required this.subtitle, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF11D411);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: isSelected ? primary : Colors.transparent, width: 2),
          boxShadow: isSelected ? [BoxShadow(color: primary.withValues(alpha: 0.2), blurRadius: 8, spreadRadius: 0)] : [],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Selection Check Icon
            if (isSelected)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: const Icon(Icons.check_circle, color: primary, size: 20),
              ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(color: isSelected ? primary : Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(Icons.group, color: isSelected ? Colors.black : Colors.white, size: 18.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(color: isSelected ? primary : Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(color: Colors.white.withValues(alpha: 0.5), fontSize: 10.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _StepperButton({required this.icon, required this.color, required this.backgroundColor, this.borderColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: borderColor != null ? Border.all(color: borderColor!, width: 1) : null,
        ),
        child: Icon(icon, color: color, size: 28.sp),
      ),
    );
  }
}

class _PresetButton extends StatelessWidget {
  final String label;
  final String value;
  final bool isSpecial;
  final VoidCallback onTap;

  const _PresetButton({required this.label, required this.value, this.isSpecial = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const accentGold = Color(0xFFFFAA00);

    final bgColor = isSpecial ? accentGold.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05);
    final borderColor = isSpecial ? accentGold.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSpecial) ...[
              Icon(Icons.star, color: accentGold, size: 20.sp),
              SizedBox(height: 2.h),
            ] else
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(color: Colors.white.withValues(alpha: 0.6), fontSize: 10.sp),
              ),

            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                color: isSpecial ? accentGold : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isSpecial ? 12.sp : 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
