import 'package:digital_vault/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PinIndicator extends StatelessWidget {
  final int pinLength;
  final int enteredLength;

  const PinIndicator({
    super.key,
    this.pinLength = 4,
    required this.enteredLength,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pinLength, (index) {
        final isFilled = index < enteredLength;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AppTheme.googleBlue : AppTheme.mediumGrey,
            border: Border.all(
              color: isFilled ? AppTheme.googleBlue : AppTheme.mediumGrey,
              width: 2,
            ),
            boxShadow: isFilled
                ? [
                    BoxShadow(
                      color: AppTheme.googleBlue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: isFilled
              ? const Icon(Icons.circle, size: 12, color: Colors.white)
              : null,
        );
      }),
    );
  }
}
