part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}
class SearchAppointmentsEvent extends SearchEvent {
  final String keyword;
  SearchAppointmentsEvent(this.keyword);
}