import 'package:flutter/material.dart';

/// Expiration Date Picker Widget
/// 
/// Widget for selecting payment expiration date and time
class ExpirationDatePicker extends StatelessWidget {
  final DateTime? expirationDate;
  final Function(DateTime) onDateSelected;

  const ExpirationDatePicker({
    super.key,
    required this.expirationDate,
    required this.onDateSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: expirationDate ?? DateTime.now().add(const Duration(hours: 24)),
      firstDate: DateTime.now().add(const Duration(hours: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          expirationDate ?? DateTime.now().add(const Duration(hours: 24)),
        ),
      );
      
      if (time != null) {
        final DateTime selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        ).toUtc();
        
        onDateSelected(selectedDateTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            expirationDate == null
                ? 'No expiration date set'
                : 'Expires: ${expirationDate!.toLocal().toString().split('.')[0]}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        TextButton(
          onPressed: () => _selectDate(context),
          child: const Text('Set Expiration Date'),
        ),
      ],
    );
  }
}

