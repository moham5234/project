import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widget/AppBar.dart';
import '../../widget/Header.dart';
import '../../widget/cardAppointmen_user.dart';
import '../Appointment_blocs/appointment_bloc.dart';
import '../Search/seash_page.dart';
import '../search_bloc/search_bloc.dart';
import '../sqlite.dart';

class UserAppointmentsPage extends StatefulWidget {
  final int userId;

  UserAppointmentsPage({required this.userId});

  @override
  _UserAppointmentsPageState createState() => _UserAppointmentsPageState();
}

class _UserAppointmentsPageState extends State<UserAppointmentsPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<AppointmentBloc>();
    bloc.add(LoadAppointmentsEvent(widget.userId));
    bloc.add(ScheduleNotificationsEvent(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentExportedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ تم تصدير المواعيد إلى ملف PDF بنجاح',
                  style: TextStyle(fontSize: 16.sp)),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AppointmentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
              Text('❌ ${state.message}', style: TextStyle(fontSize: 16.sp)),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppointmenAppBar(context, 'مواعيدك'),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 50.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: 'Search',
                tooltip: "البحث عن الجهة",
                backgroundColor: Colors.blueGrey,
                onPressed: () async {
                  final appointmentService =
                  await DatabaseHelper().getAppointmentService();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => SearchBloc(appointmentService),
                        child: SearchsAppointmentPage(),
                      ),
                    ),
                  );
                },
                child: Icon(Icons.search, color: Colors.white, size: 24.sp),
              ),
              SizedBox(width: 10.w),
              BlocBuilder<AppointmentBloc, AppointmentState>(
                builder: (context, state) {
                  if (state is AppointmentLoaded) {
                    return FloatingActionButton(
                      heroTag: 'Export',
                      tooltip: "تصدير جميع المواعيد",
                      backgroundColor: Colors.green,
                      onPressed: () {
                        context.read<AppointmentBloc>().add(
                          ExportAppointmentsToPdfEvent(widget.userId),
                        );
                      },
                      child: Icon(Icons.picture_as_pdf,
                          color: Colors.white, size: 24.sp),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            buildHeader(),
            SizedBox(height: 20.h),
            Expanded(child: _buildAppointmentsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AppointmentLoaded) {
          final userAppointments = state.appointments
              .where((appointment) => appointment.userId == widget.userId)
              .toList();
          if (userAppointments.isEmpty) {
            return Center(
              child: Text("لا توجد مواعيد", style: TextStyle(fontSize: 18.sp)),
            );
          }

          return ListView.builder(
            itemCount: userAppointments.length,
            itemBuilder: (context, index) {
              return buildAppointmentCard(context, userAppointments[index]);
            },
          );
        } else {
          return Center(
            child: Text("حدث خطأ أثناء تحميل البيانات",
                style: TextStyle(fontSize: 18.sp)),
          );
        }
      },
    );
  }
}
