import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widget/Text_Filed.dart';
import '../Models/model_user.dart';
import '../user_blocs/users_bloc.dart';
import 'login.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state is UserAddedSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅تم تسجيل الحساب بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          });
        } else if (state is UsersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تسجيل حساب جديد'),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: BackButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 60.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveTextField(
                    controller_: nameController,
                    keyboardType_: TextInputType.name,
                    labelText: "name",
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الاسم مطلوب';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
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
                  SizedBox(height: 16.h),
                  ResponsiveTextField(
                    controller_: passwordController,
                    keyboardType_: TextInputType.visiblePassword,
                    labelText: 'password',
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'كلمه المرور مطلوبه';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  ResponsiveTextField(
                    controller_: typeController,
                    keyboardType_: TextInputType.text,
                    labelText: 'type',
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'نوع المستخدم مطلوب';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    height: 60.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                      ),
                      onPressed: () {
                        if (nameController.text.trim().isEmpty ||
                            emailController.text.trim().isEmpty ||
                            passwordController.text.trim().isEmpty ||
                            typeController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('❗ يرجى تعبئة جميع الحقول أولاً'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        final user = User(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text,
                          type: typeController.text.trim(),
                        );

                        context.read<UsersBloc>().add(AddUserEvent(user));
                      },
                      child: Text(
                        'تسجيل',
                        style: TextStyle(
                          fontSize: 22.sp,
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        'لديك حساب؟ تسجيل الدخول هنا',
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
