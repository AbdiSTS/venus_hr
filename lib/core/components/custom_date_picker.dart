import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:venus_hr_psti/core/extensions/date_time_ext.dart';

import '../assets/assets.gen.dart';
import '../constants/colors.dart';

class CustomDatePicker extends StatefulWidget {
  final void Function(DateTime selectedDate)? onDateSelected;
  final DateTime? initialDate;
  final DateTime? beforeDate;
  final Widget? prefix;
  final String label;
  final bool showLabel;

  const CustomDatePicker({
    super.key,
    required this.label,
    this.showLabel = true,
    this.beforeDate,
    this.initialDate,
    this.onDateSelected,
    this.prefix,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
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
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        if (selectedDateBefore != "") {
          if (DateFormat('yyyy-MM-dd')
              .parse(selectedDateBefore.toString())
              .isAfter(
                  DateFormat('yyyy-MM-dd').parse(selectedDate.toString()))) {
            controller.text = DateTime.now().toFormattedDate();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("From Date harus lebih kecil dari pada To Date"),
                backgroundColor: AppColors.red,
              ),
            );
          } else {
            controller.text = selectedDate.toFormattedDate();
          }
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
