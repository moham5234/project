import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Add_Appointments/Add_Appointments_Admin.dart';
import '../Appointment_blocs/appointment_bloc.dart';
import '../Models/model_Appointment.dart';


Widget buildAppointmentCards(BuildContext context, Appointment appointment) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.indigo,
        width: 2.w,
      ),
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Card(
      margin: EdgeInsets.all(2.w),
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
                          child: AddAppointmentPage(
                            userId: appointment.userId,
                            existingAppointment: appointment,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 24.sp),
                  onPressed: () => _confirmDelete(context, appointment),
                ),
                Spacer(),
                Container(
                  width: 180.w,
                  alignment: Alignment.centerRight,
                  child: Text(
                    appointment.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: Colors.indigo,
                    ),
                    overflow: TextOverflow.ellipsis,
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

void _confirmDelete(BuildContext context, Appointment appointment) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('تأكيد الحذف', style: TextStyle(fontSize: 18.sp)),
      content: Text('هل أنت متأكد من حذف هذا الموعد؟', style: TextStyle(fontSize: 16.sp)),
      actions: [
        TextButton(
          child: Text('إلغاء', style: TextStyle(fontSize: 14.sp)),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('حذف', style: TextStyle(color: Colors.red, fontSize: 14.sp)),
          onPressed: () {
            if (!context.read<AppointmentBloc>().isClosed) {
              context.read<AppointmentBloc>().add(DeleteAppointmentEvent(appointment.id!));
            }
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
