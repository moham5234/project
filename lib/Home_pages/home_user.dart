import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdfs/sqlite.dart';
import '../../Add_Appointments/Add_Appointments_User.dart';
import '../../Auth/login.dart';
import '../Appointment_blocs/appointment_bloc.dart';
import '../Views/show_Appointments_user.dart';



class UserPage extends StatelessWidget {
  final int userId;

  UserPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User', style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: BackButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
          ),
        ),
        toolbarHeight: 60.h,
      ),
      body: Column(
        children: [
          Container(
            height: 170.h,
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(100.r),
                bottomLeft: Radius.circular(100.r),
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("Assets/log2.png", width: 130.w),
                      SizedBox(height: 8.h),
                      Text(
                        "مرحبا بك",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Image.asset(
            "Assets/log2.png",
            width: 250.w,
            height: 200.h,
          ),

          Text(
            "اهلا بك في تطبيق موعدك",
            style: TextStyle(color: Colors.cyan, fontSize: 22.sp),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150.w,
                    height: 70.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                      ),
                      onPressed: () async {
                        final appointmentService =
                        await DatabaseHelper().getAppointmentService();
                        final userService =
                        await DatabaseHelper().getUserService();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => AppointmentBloc(
                                appointmentService,
                                userService,
                              )..add(LoadAppointmentsEvent(userId)),
                              child: UserAppointmentsPage(userId: userId),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'عرض المواعيد',
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 30.w),
                  SizedBox(
                    width: 150.w,
                    height: 70.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                      ),
                      onPressed: () async {
                        final appointmentService =
                        await DatabaseHelper().getAppointmentService();
                        final userService =
                        await DatabaseHelper().getUserService();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => AppointmentBloc(
                                appointmentService,
                                userService,
                              )..add(LoadAppointmentsEvent(userId)),
                              child: AddAppointmentPage2(userId: userId),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'اضافه موعد',
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
