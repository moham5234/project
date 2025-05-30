import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Add_Appointments/Add_Appointments_User.dart';
import '../Appointment_blocs/appointment_bloc.dart';
import '../Models/model_Appointment.dart';

class AppointmentsListWidget extends StatelessWidget {
  final List<Appointment> results;

  AppointmentsListWidget(this.results);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length,
      itemBuilder: (context, index) {
        final a = results[index];

        return ListTile(
          title: Text(a.name),
          subtitle: Text('${a.date} - ${a.time}'),
          trailing: Text(a.status),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<AppointmentBloc>(),
                  child: AddAppointmentPage2(
                    userId: a.userId,
                    existingAppointment: a,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
