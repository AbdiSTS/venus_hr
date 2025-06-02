import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:venus_hr_psti/core/extensions/date_time_ext.dart';

import '../assets/assets.gen.dart';

class CustomDatePickerRange extends StatefulWidget {
  final void Function(DateTime selectedDate)? onDateSelected;
  final DateTime? initialDate;
  final DateTime? startDate;
  final DateTime? endtDate;
  final DateTime? beforeDate;
  final Widget? prefix;
  final String label;
  final bool showLabel;
  final FormFieldValidator<String>? validator;

  const CustomDatePickerRange({
    super.key,
    required this.label,
    this.startDate,
    this.endtDate,
    this.showLabel = true,
    this.beforeDate,
    this.initialDate,
    this.onDateSelected,
    this.prefix,
    this.validator, //
  });

  @override
  State<CustomDatePickerRange> createState() => _CustomDatePickerRangeState();
}

class _CustomDatePickerRangeState extends State<CustomDatePickerRange> {
  late TextEditingController controller;
  late DateTime selectedDate;
  late DateTime selectedDateBefore;

  @override
  void initState() {
    controller = TextEditingController(
      text: widget.initialDate?.toFormattedDate(),
    );
    selectedDateBefore = widget.beforeDate ?? DateTime.now();
    selectedDate = widget.initialDate ?? DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: widget.startDate ?? DateTime(2015),
      lastDate: widget.endtDate ?? DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        if (selectedDateBefore != "") {
          controller.text = selectedDate.toFormattedDate();
        } else {
          controller.text = selectedDate.toFormattedDate();
        }
      });

      if (widget.onDateSelected != null) {
        widget.onDateSelected!(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12.0),
        ],
        TextFormField(
          validator: widget.validator,
          controller: controller,
          onTap: () => _selectDate(context),
          readOnly: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Assets.icons.calendar.svg(),
            ),
            hintText: widget.initialDate != null
                ? selectedDate.toFormattedDate()
                : widget.label,
          ),
        ),
      ],
    );
  }
}
