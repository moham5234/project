part of 'appointment_bloc.dart';

@immutable
sealed class AppointmentState {}

final class AppointmentInitial extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<Appointment> appointments;
  AppointmentLoaded(this.appointments);

}

class AppointmentLoading extends AppointmentState {}
class AppointmentExportedSuccess extends AppointmentState {}


class AppointmentError extends AppointmentState {
  final String message;
  AppointmentError(this.message);
}
