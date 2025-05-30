import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Models/model_Appointment.dart';
import '../sqlite.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final AppointmentService appointmentService;

  SearchBloc(this.appointmentService) : super(SearchInitial()) {
    on<SearchAppointmentsEvent>((event, emit) async {
      emit(SearchLoading());
      try {
        final results = await appointmentService.searchAppointments(event.keyword);
        emit(SearchLoaded(results));
      } catch (e) {
        emit(SearchError('حدث خطأ أثناء البحث'));
      }
    });
  }
}
