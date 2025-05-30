import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widget/AppBar.dart';
import '../../widget/Input_DateAndTime.dart';
import '../../widget/Text_Filed.dart';

import '../Appointment_blocs/appointment_bloc.dart';
import '../Models/model_Appointment.dart';
import '../Views/show_Appointments_user.dart';



class AddAppointmentPage2 extends StatefulWidget {
  final int userId;
  final Appointment? existingAppointment;

  const AddAppointmentPage2({
    Key? key,
    required this.userId,
    this.existingAppointment,
  }) : super(key: key);

  @override
  State<AddAppointmentPage2> createState() => _AddAppointmentPage2State();
}

class _AddAppointmentPage2State extends State<AddAppointmentPage2> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController timeController;
  late TextEditingController dateController;
  late TextEditingController notesController;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.existingAppointment?.name ?? '');
    addressController = TextEditingController(text: widget.existingAppointment?.address ?? '');
    timeController = TextEditingController(text: widget.existingAppointment?.time ?? '');
    dateController = TextEditingController(text: widget.existingAppointment?.date ?? '');
    notesController = TextEditingController(text: widget.existingAppointment?.notes ?? '');
    selectedStatus = widget.existingAppointment?.status;
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    timeController.dispose();
    dateController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingAppointment != null;

    return BlocListener<AppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("✅ ${state.message}"), backgroundColor: Colors.green),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<AppointmentBloc>(),
                child: UserAppointmentsPage(userId: widget.userId),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppointmenAppBar(context, isEditing ? 'تعديل موعد' : 'إضافة موعد'),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ResponsiveTextField(
                    controller_: nameController,
                    keyboardType_: TextInputType.text,
                    labelText: "الاسم",
                    maxLines: 1,
                    validator: (value) => value!.isEmpty ? 'الاسم مطلوب' : null,
                  ),
                  SizedBox(height: 16.h),
                  ResponsiveTextField(
                    controller_: addressController,
                    keyboardType_: TextInputType.text,
                    labelText: "العنوان",
                    maxLines: 1,
                    validator: (value) => value!.isEmpty ? 'العنوان مطلوب' : null,
                  ),
                  SizedBox(height: 16.h),
                  ResponsiveTextField(
                    controller_: notesController,
                    keyboardType_: TextInputType.text,
                    labelText: "ملاحظات",
                    maxLines: 1,
                    validator: (value) => null,
                  ),
                  SizedBox(height: 16.h),
                  buildDateField(context: context, controller: dateController),
                  SizedBox(height: 16.h),
                  buildTimeField(context: context, controller: timeController),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: DropdownButtonFormField<String>(
                      value: selectedStatus,
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
                      onChanged: (value) => setState(() => selectedStatus = value),
                      validator: (value) => value == null ? 'اختر الحالة' : null,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    height: 60.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                      onPressed: _submitForm,
                      child: Text(
                        isEditing ? 'تحديث' : 'إضافة',
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: Colors.white,
                          fontFamily: "Cairo",
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final appointment = Appointment(
        id: widget.existingAppointment?.id,
        userId: widget.userId,
        name: nameController.text,
        address: addressController.text,
        time: timeController.text,
        date: dateController.text,
        notes: notesController.text,
        status: selectedStatus ?? '',
      );

      final bloc = context.read<AppointmentBloc>();
      widget.existingAppointment != null
          ? bloc.add(UpdateAppointmentEvent(appointment))
          : bloc.add(AddAppointmentEvent(appointment));
    }
  }
}
