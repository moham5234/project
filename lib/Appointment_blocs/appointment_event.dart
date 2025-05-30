part of 'appointment_bloc.dart';

@immutable
@immutable
abstract class AppointmentEvent {}

class LoadAppointmentsEvent extends AppointmentEvent {
  final int userId;
  LoadAppointmentsEvent(this.userId);
}

class AddAppointmentEvent extends AppointmentEvent {
  final Appointment appointment;
  AddAppointmentEvent(this.appointment);
}

class DeleteAppointmentEvent extends AppointmentEvent {
  final int id;
  DeleteAppointmentEvent(this.id);
}

class UpdateAppointmentEvent extends AppointmentEvent {
  final Appointment appointment;
  UpdateAppointmentEvent(this.appointment);
}
class ScheduleNotificationsEvent extends AppointmentEvent {
  final int userId;
  ScheduleNotificationsEvent(this.userId);
}
class ExportAppointmentsToPdfEvent extends AppointmentEvent {
  final int userId;
  ExportAppointmentsToPdfEvent(this.userId);
}
class ExportAllAppointmentsToPdfEvent extends AppointmentEvent {
  final int userId;
  ExportAllAppointmentsToPdfEvent(this.userId);

}

class AppointmentSuccess extends AppointmentState {
  final String message;

  AppointmentSuccess(this.message);
}





