import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdfs/Auth/sginup.dart';
import 'package:pdfs/main.dart';
import 'package:provider/provider.dart';
import '../../widget/Text_Filed.dart';
import '../Home_pages/home_admin.dart';
import '../Home_pages/home_user.dart';
import '../user_blocs/users_bloc.dart';





class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Function(Locale)? onLocaleChange;

  LoginPage({this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          final userId = state.user.id!;
          if (state.user.type == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => AdminPage(userId: userId)),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => UserPage(userId: userId)),
            );
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅تم تسجيل الحساب بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },

      child: Scaffold(
        appBar: AppBar(
          title: const Text('تسجيل الدخول'),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,

          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.language),
              onSelected: (value) {
                if (value == 'ar') {
                  onLocaleChange?.call(Locale('ar'));
                } else if (value == 'en') {
                  onLocaleChange?.call(Locale('en'));
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'ar', child: Text('العربية')),
                PopupMenuItem(value: 'en', child: Text('English')),
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 270.w, bottom: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.indigo,
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },
                child: Icon(Icons.mode_night, color: Colors.white),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 76.h),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                children: [
                  Icon(
                    Icons.person,
                    size: 150.sp,
                    color: Colors.indigo,
                  ),
                  SizedBox(height: 20.h),
                  ResponsiveTextField(
                    controller_: emailController,
                    keyboardType_: TextInputType.emailAddress,
                    labelText: 'email',
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الايميل مطلوب';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  ResponsiveTextField(
                    controller_: passwordController,
                    keyboardType_: TextInputType.visiblePassword,
                    labelText: "password",
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'كلمه المرور مطلوبه';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    height: 60.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                      onPressed: () {
                        context.read<UsersBloc>().add(LoginEvent(
                          emailController.text,
                          passwordController.text,
                        ));
                      },
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: Colors.white,
                          fontFamily: "Cairo",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      child: Text(
                        'ليس لديك حساب؟ سجل هنا',
                        style: TextStyle(fontSize: 16.sp),
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
