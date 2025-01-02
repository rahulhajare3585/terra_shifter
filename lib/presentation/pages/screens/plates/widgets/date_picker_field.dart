import 'package:flutter/material.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/widgets/custom_text_field.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final VoidCallback? onDateSelected;

  DatePickerField({
    required this.controller,
    required this.labelText,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomTextField(
      controller: controller,
      labelText: labelText,
      readOnly: true,
      suffixIcon: Icon(Icons.calendar_today, color: theme.primaryColor),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate ?? DateTime.now(),
          firstDate: firstDate,
          lastDate: lastDate,
        );
        if (pickedDate != null) {
          controller.text = pickedDate.toLocal().toString().split(' ')[0];
          if (onDateSelected != null) {
            onDateSelected!();
          }
        }
      },
    );
  }
}