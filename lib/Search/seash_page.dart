import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdfs/Search/search_contacts.dart';
import 'package:pdfs/widget/AppBar.dart';

import '../search_bloc/search_bloc.dart';

class SearchsAppointmentPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppointmenAppBar(context, ' البحث عن موعد'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: TextField(
                controller: controller,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  labelText: "ادخل اسم الموعد",
                  labelStyle: TextStyle(fontSize: 14.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 12.w,
                  ),
                ),
                onChanged: (value) {
                  context.read<SearchBloc>().add(SearchAppointmentsEvent(value));
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SearchLoaded) {
                    if (state.results.isEmpty) {
                      return Center(child: Text("لا توجد نتائج", style: TextStyle(fontSize: 14.sp)));
                    }
                    return AppointmentsListWidget(state.results);
                  } else if (state is SearchError) {
                    return Center(child: Text(state.message, style: TextStyle(fontSize: 14.sp)));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}