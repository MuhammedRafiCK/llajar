import 'package:flutter/material.dart';
import 'package:llajar/src/utils/app_theme.dart' show AppTheme;

class SearchBarWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;
  final String hintText;
  final bool readOnly;

  const SearchBarWidget({
    super.key,
    this.onTap,
    this.onSubmitted,
    this.controller,
    this.hintText = 'Where do you want to pick up?',
    this.readOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: readOnly ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.search, color: AppTheme.primaryColor, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: readOnly
                      ? Text(
                          hintText,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                          ),
                        )
                      : TextField(
                          controller: controller,
                          onSubmitted: onSubmitted,
                          decoration: InputDecoration(
                            hintText: hintText,
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                ),
                Icon(Icons.tune, color: AppTheme.textSecondary, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
