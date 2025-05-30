import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdfs/sqlite.dart';
import '../../widget/AppBar.dart';
import '../../widget/Input_DateAndTime.dart';
import '../../widget/Text_Filed.dart';

import '../Appointment_blocs/appointment_bloc.dart';
import '../Models/model_Appointment.dart';

import '../Views/show_Appointments_Admin.dart';
import '../Views/show_Appointments_user.dart';



class AddAppointmentPage extends StatefulWidget {
  final int userId;
  final Appointment? existingAppointment;

  const AddAppointmentPage({
    Key? key,
    required this.userId,
    this.existingAppointment,
  }) : super(key: key);

  @override
  State<AddAppointmentPage> createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController timeController;
  late TextEditingController dateController;
  late TextEditingController notesController;
  late TextEditingController statusController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.existingAppointment?.name ?? '');
    addressController = TextEditingController(text: widget.existingAppointment?.address ?? '');
    timeController = TextEditingController(text: widget.existingAppointment?.time ?? '');
    dateController = TextEditingController(text: widget.existingAppointment?.date ?? '');
    notesController = TextEditingController(text: widget.existingAppointment?.notes ?? '');
    statusController = TextEditingController(text: widget.existingAppointment?.status ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    timeController.dispose();
    dateController.dispose();
    notesController.dispose();
    statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingAppointment != null;

    return BlocListener<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✅ ${state.message}"),
              backgroundColor: Colors.green,
            ),
          );

          Future.delayed(Duration(milliseconds: 500), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<AppointmentBloc>(),
                  child: UserAppointmentsPage(userId: widget.userId),
                ),
              ),
            );
          });
        }
      },
      child: Scaffold(
        appBar: AppointmenAppBar(context, isEditing ? 'تعديل موعد' : 'إضافة موعد'),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveTextField(
                    controller_: nameController,
                    keyboardType_: TextInputType.text,
                    labelText: "name",
                    maxLines: 1,
                    validator: (value) => value == null || value.isEmpty ? 'الرجاء إدخال الاسم' : null,
                  ),
                  ResponsiveTextField(
                    controller_: addressController,
                    keyboardType_: TextInputType.text,
                    labelText: "address",
                    maxLines: 1,
                    validator: (value) => value == null || value.isEmpty ? 'الرجاء إدخال العنوان' : null,
                  ),
                  ResponsiveTextField(
                    controller_: notesController,
                    keyboardType_: TextInputType.text,
                    labelText: "nots",
                    maxLines: 1,
                    validator: (value) => value == null || value.isEmpty ? 'الرجاء إدخال الملاحظات' : null,
                  ),
                  buildDateField(context: context, controller: dateController),
                  buildTimeField(context: context, controller: timeController),

                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: DropdownButtonFormField<String>(
                      value: statusController.text.isNotEmpty ? statusController.text : null,
                      decoration: InputDecoration(
                        labelText: "الحالة",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      ),
                      items: const [
                        DropdownMenuItem(value: "مكتمل", child: Text("مكتمل")),
                        DropdownMenuItem(value: "معلق", child: Text("معلق")),
                        DropdownMenuItem(value: "ملغي", child: Text("ملغي")),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          statusController.text = newValue!;
                        });
                      },
                      validator: (value) => value == null || value.isEmpty ? 'يرجى اختيار الحالة' : null,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    height: 60.h,
                    padding: EdgeInsets.symmetric(horizontal: 35.w),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        if (dateController.text.trim().isEmpty || timeController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('الرجاء إدخال التاريخ والوقت')),
                          );
                          return;
                        }

                        final appointment = Appointment(
                          id: widget.existingAppointment?.id,
                          userId: widget.userId,
                          name: nameController.text,
                          address: addressController.text,
                          time: timeController.text,
                          date: dateController.text,
                          notes: notesController.text,
                          status: statusController.text,
                        );

                        final bloc = context.read<AppointmentBloc>();
                        if (isEditing) {
                          bloc.add(UpdateAppointmentEvent(appointment));
                        } else {
                          bloc.add(AddAppointmentEvent(appointment));
                        }

                        final appointmentService = await DatabaseHelper().getAppointmentService();
                        final userService = await DatabaseHelper().getUserService();


                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => AppointmentBloc(appointmentService, userService)
                                ..add(LoadAppointmentsEvent(widget.userId)),
                              child: AdminAppointmentsPage(userId: widget.userId),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        isEditing ? 'تحديث' : 'إضافة',
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: Colors.white,
                          fontFamily: "Cairo",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
