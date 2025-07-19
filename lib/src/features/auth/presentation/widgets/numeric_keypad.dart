import 'package:digital_vault/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class NumericKeypad extends StatelessWidget {
  final ValueSetter<String> onKeyPressed;

  const NumericKeypad({super.key, required this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        const SizedBox(height: 16),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: 16),
        _buildRow(['7', '8', '9']),
        const SizedBox(height: 16),
        _buildRow(['', '0', '⌫']),
      ],
    );
  }

  Widget _buildRow(List<String> keys) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) => _buildKey(key)).toList(),
      ),
    );
  }

  Widget _buildKey(String key) {
    if (key.isEmpty) {
      return const Expanded(child: SizedBox());
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onKeyPressed(key),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: key == '⌫'
                    ? Icon(
                        Icons.backspace_outlined,
                        size: 28,
                        color: AppTheme.textSecondary,
                      )
                    : Text(
                        key,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
