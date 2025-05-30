import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Add_Appointments/Add_Appointments_User.dart';
import '../Appointment_blocs/appointment_bloc.dart';
import '../Models/model_Appointment.dart';


Widget buildAppointmentCard(BuildContext context, Appointment appointment) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 10.h,
      horizontal: 16.w,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.indigo, width: 2.w),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Card(
      elevation: 6.0,
      shadowColor: Colors.indigo,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue, size: 24.sp),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<AppointmentBloc>(),
                          child: AddAppointmentPage2(
                            userId: appointment.userId,
                            existingAppointment: appointment,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      appointment.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.indigo,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            buildResponsiveText(' العنوان: ${appointment.address}'),
            buildResponsiveText('⏰ الوقت: ${appointment.time}'),
            buildResponsiveText('📅 التاريخ: ${appointment.date}'),
            buildResponsiveText('📝 الملاحظات: ${appointment.notes}'),
            buildResponsiveText('📌 الحالة: ${appointment.status}', color: Colors.grey[700]),
          ],
        ),
      ),
    ),
  );
}

Widget buildResponsiveText(String text, {Color? color}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 4.h),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        color: color ?? Colors.black,
      ),
      textAlign: TextAlign.right,
    ),
  );
}
