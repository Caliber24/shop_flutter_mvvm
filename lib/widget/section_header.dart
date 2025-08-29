import 'package:flutter/material.dart';
import '../utils/colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  const SectionHeader(this.title, {super.key, this.actionText, this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
          const Spacer(),
          if (actionText != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(actionText!,
                  style: const TextStyle(color: AppColors.gray, fontSize: 12)),
            ),
        ],
      ),
    );
  }
}
