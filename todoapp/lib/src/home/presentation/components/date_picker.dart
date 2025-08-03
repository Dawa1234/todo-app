import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
  final DateTime? selectedDate;
  final bool isViewOnly;
  final void Function(DateTime?) onDateSelected;

  const DatePickerField(
      {super.key,
      this.selectedDate,
      this.isViewOnly = false,
      required this.onDateSelected});

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text:
          widget.selectedDate != null ? _formatDate(widget.selectedDate!) : '',
    );
  }

  @override
  void didUpdateWidget(covariant DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _controller.text =
          widget.selectedDate != null ? _formatDate(widget.selectedDate!) : '';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate!,
        firstDate: DateTime(widget.selectedDate!.year - 5),
        lastDate: DateTime(widget.selectedDate!.year + 5));
    if (picked != null) {
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      onTap: widget.isViewOnly ? null : _pickDate,
      decoration: const InputDecoration(
          labelText: 'Select Date',
          suffixIcon: Icon(Icons.calendar_today, size: 20),
          border: OutlineInputBorder()),
    );
  }
}
