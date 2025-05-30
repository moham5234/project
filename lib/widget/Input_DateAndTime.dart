import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildDateField({
  required BuildContext context,
  required TextEditingController controller,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 12.h),
    child: TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final value = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2050),
        );
        if (value != null) {
          controller.text =
          "${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}";
        }
      },
      decoration: InputDecoration(
        labelText: 'التاريخ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        suffixIcon: Icon(Icons.calendar_today, size: 24.sp),
      ),
      validator: (value) => value!.isEmpty ? 'التاريخ مطلوب' : null,
    ),
  );
}

Widget buildTimeField({
  required BuildContext context,
  required TextEditingController controller,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 12.h),
    child: TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          controller.text = picked.format(context);
        }
      },
      decoration: InputDecoration(
        labelText: 'الوقت',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        suffixIcon: Icon(Icons.access_time, size: 24.sp),
      ),
      validator: (value) => value!.isEmpty ? 'الوقت مطلوب' : null,
    ),
  );
}
