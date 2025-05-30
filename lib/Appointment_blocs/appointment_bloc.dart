import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import '../../services/notification_service.dart';
import '../Models/model_Appointment.dart';
import '../pdfs.dart';
import '../sqlite.dart';

part 'appointment_event.dart';

part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentService appointmentService;
  final UserService userService;

  AppointmentBloc(this.appointmentService, this.userService)
      : super(AppointmentInitial()) {
    on<LoadAppointmentsEvent>((event, emit) async {
      emit(AppointmentLoading());
      final allAppointments = await appointmentService.getAppointments();
      emit(AppointmentLoaded(allAppointments));
    });

    on<AddAppointmentEvent>((event, emit) async {
      await appointmentService.insertAppointment(event.appointment);
      emit(AppointmentSuccess("تمت إضافة الموعد بنجاح"));
      add(LoadAppointmentsEvent(event.appointment.userId));
    });

    on<DeleteAppointmentEvent>((event, emit) async {
      await appointmentService.deleteAppointment(event.id);
      final appointments = await appointmentService.getAppointments();
      emit(AppointmentLoaded(appointments));
    });

    on<UpdateAppointmentEvent>((event, emit) async {
      await appointmentService.updateAppointment(event.appointment);
      emit(AppointmentSuccess("تم تحديث الموعد بنجاح"));
      final appointments = await appointmentService.getAppointments();
      emit(AppointmentLoaded(appointments));
    });
    on<ScheduleNotificationsEvent>((event, emit) async {
      try {
        final appointments = await appointmentService.getAppointmentsByUserId(event.userId);

        for (var appointment in appointments) {
          final name = (appointment.name?.isNotEmpty == true)
              ? appointment.name!
              : 'بدون اسم';

          if (appointment.date != null && appointment.time != null) {
            try {
              final dateTime = NotificationService.parseAppointmentDateTime(
                appointment.date!,
                appointment.time!,
              );

              print('📅 تحليل التاريخ والوقت: ${appointment.date} ${appointment.time} ➜ $dateTime');
              print('🕓 الآن: ${DateTime.now()}');

              if (dateTime != null) {
                final notificationTime = dateTime.subtract(const Duration(hours: 1));

                if (notificationTime.isAfter(DateTime.now())) {
                  await NotificationService.scheduleNotification(
                    id: appointment.id ?? DateTime.now().millisecondsSinceEpoch,
                    title: 'تذكير بموعد',
                    body: 'تبقّى ساعة على موعدك مع $name',
                    scheduledTime: notificationTime, // ← تمرير الوقت بعد الخصم
                  );
                  print('✅ تم جدولة إشعار للموعد: $name');
                } else {
                  print('🚫 لن يتم جدولة إشعار. الموعد قريب جدًا أو ماضٍ: $notificationTime');
                }
              } else {
                print('⚠️ فشل في تحليل التاريخ والوقت للموعد: $name');
              }
            } catch (e) {
              print('⚠️ خطأ في معالجة موعد "$name": $e');
            }
          } else {
            print('🚫 موعد غير مكتمل البيانات: $name');
          }
        }
      } catch (e, stackTrace) {
        print('❌ خطأ في جدولة الإشعارات: $e');
        print('StackTrace: $stackTrace');
        emit(AppointmentError('فشل في جدولة الإشعارات: $e'));
      }
    });


    on<ExportAppointmentsToPdfEvent>((event, emit) async {
      try {
        final appointments =
            await appointmentService.getAppointmentsByUserId(event.userId);
        if (appointments.isEmpty) {
          emit(AppointmentError("لا توجد مواعيد للتصدير"));
          return;
        }

        final userName = await userService.getUserNameById(event.userId);
        if (userName == null) {
          emit(AppointmentError("اسم المستخدم غير موجود"));
          return;
        }

        PDFs.getAppointmentsData(
          target_: userName,
          title_: 'تقرير المواعيد',
          date_: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          appointments: appointments,
        );

        await PDFs.createPdf(fileName: userName.replaceAll(' ', '_'));
        emit(AppointmentExportedSuccess());
        add(LoadAppointmentsEvent(event.userId));
      } catch (e) {
        emit(AppointmentError("حدث خطأ أثناء تصدير المواعيد: $e"));
      }
    });

    on<ExportAllAppointmentsToPdfEvent>((event, emit) async {
      try {
        final allAppointments = await appointmentService.getAppointments();
        if (allAppointments.isEmpty) {
          emit(AppointmentError("لا توجد مواعيد لتصديرها."));
          return;
        }

        final userName = await userService.getUsersNameById(event.userId);
        if (userName == null) {
          emit(AppointmentError("اسم المستخدم غير موجود"));
          return;
        }

        PDFs.getAppointmentsData(
          target_: userName,
          title_: 'تقرير جميع المواعيد',
          date_: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          appointments: allAppointments,
        );

        await PDFs.createPdf(fileName: userName.replaceAll(' ', '_'));
        emit(AppointmentExportedSuccess());
        add(LoadAppointmentsEvent(event.userId));
      } catch (e) {
        emit(AppointmentError("فشل في تصدير جميع المواعيد: ${e.toString()}"));
      }
    });
  }
}
