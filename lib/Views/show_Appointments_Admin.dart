import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widget/AppBar.dart';
import '../../widget/Header.dart';
import '../../widget/cardAppointmen_admin.dart';
import '../Appointment_blocs/appointment_bloc.dart';
import '../Search/seash_page.dart';
import '../search_bloc/search_bloc.dart';
import '../sqlite.dart';


class AdminAppointmentsPage extends StatefulWidget {
  final int userId;

  const AdminAppointmentsPage({required this.userId});

  @override
  _AdminAppointmentsPageState createState() => _AdminAppointmentsPageState();
}

class _AdminAppointmentsPageState extends State<AdminAppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentExportedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ تم تصدير المواعيد إلى ملف PDF بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AppointmentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppointmenAppBar(context, 'جميع المواعيد'),
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
                            ExportAllAppointmentsToPdfEvent(widget.userId));
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
            _buildAppointmentsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsList() {
    return Expanded(
      child: BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AppointmentLoaded) {
            final appointments = state.appointments;
            if (appointments.isEmpty) {
              return Center(
                  child: Text("لا توجد مواعيد",
                      style: TextStyle(fontSize: 18.sp)));
            }
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return buildAppointmentCards(context, appointments[index]);
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
