import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveTextField extends StatelessWidget {
  final TextEditingController controller_;
  final TextInputType keyboardType_;
  final String labelText;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool obscureText;

  const ResponsiveTextField({
    super.key,
    required this.controller_,
    required this.keyboardType_,
    required this.labelText,
    this.maxLines = 1,
    this.validator,
    this.obscureText = false,
  });

  String _getTranslatedLabel(AppLocalizations t) {
    switch (labelText.toLowerCase()) {
      case 'email':
        return t.email;
      case 'password':
        return t.password;
      case 'name':
        return t.name;
      case 'type':
        return t.type;
      case 'address':
        return t.address;
      case 'nots':
        return t.nots;
      case 'state':
        return t.state;
      default:
        return labelText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 20.h),
      child: TextFormField(
        controller: controller_,
        keyboardType: keyboardType_,
        maxLines: obscureText ? 1 : maxLines,
        obscureText: obscureText,
        textAlign: Directionality.of(context) == TextDirection.rtl
            ? TextAlign.right
            : TextAlign.left,
        validator: validator,
        style: TextStyle(fontSize: 15.sp),
        decoration: InputDecoration(
          label: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Text(
              _getTranslatedLabel(t),
              style: TextStyle(
                fontSize: 15.sp,
                fontFamily: "Cairo",
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.r),
            gapPadding: 10.w,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.r),
            gapPadding: 10.w,
            borderSide: const BorderSide(color: Colors.indigo),
          ),
        ),
      ),
    );
  }
}
