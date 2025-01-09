import 'package:flutter/material.dart';

class CustomerSelectionButton extends StatelessWidget {
  final VoidCallback onPressed;

  CustomerSelectionButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select Customer', style: TextStyle(color: theme.cardColor)),
          Icon(Icons.arrow_drop_down, color: theme.cardColor),
        ],
      ),
    );
  }
}