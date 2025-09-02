// ویجت بک گراند خمیده در بالای صفحه ثبت نام و لاگین
import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CurvedHeader extends StatelessWidget {
  final double height;
  final Widget? child;
  const CurvedHeader({super.key, this.height = 240, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height, width: double.infinity,
      child: Stack(children: [
        CustomPaint(size: Size.infinite, painter: _HeaderPainter()),
        if (child != null) child!,
      ]),
    );
  }
}

class _HeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final p = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x26F9C907), Color(0x99F9C907), AppColors.yellowPrimary],
        begin: Alignment.topLeft, end: Alignment.bottomRight,
      ).createShader(rect);

    final path = Path()
      ..lineTo(0, size.height * .55)
      ..cubicTo(size.width * .28, size.height * .80, size.width * .42, size.height * .34,
          size.width * .66, size.height * .60)
      ..cubicTo(size.width * .86, size.height * .82, size.width * .92, size.height * .56,
          size.width, size.height * .72)
      ..lineTo(size.width, 0)..close();
    canvas.drawPath(path, p);

    final line = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke..strokeWidth = 1;
    for (double i = 0; i < 5; i++) {
      final lp = Path()
        ..moveTo(0, size.height * (0.15 + i * 0.12))
        ..cubicTo(size.width * .25, size.height * (0.05 + i * 0.11),
            size.width * .55, size.height * (0.25 + i * 0.09),
            size.width, size.height * (0.12 + i * 0.13));
      canvas.drawPath(lp, line);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FrostedCard extends StatelessWidget {
  final Widget child;
  const FrostedCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.itemBackground.withOpacity(0.55),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.grayBlack),
          ),
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const PrimaryButton({super.key, required this.text, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.yellowPrimary,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 20),
          if (icon != null) const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}


InputDecoration authInput(String label, String hint, {IconData? icon}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    filled: true,
    fillColor: AppColors.itemBackground.withOpacity(.7),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    prefixIcon: icon != null ? Icon(icon, color: AppColors.gray) : null,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.grayBlack),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.yellowPrimary, width: 1.4),
    ),
    hintStyle: const TextStyle(color: AppColors.gray),
    labelStyle: const TextStyle(color: AppColors.gray),
  );
}
