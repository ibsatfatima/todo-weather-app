import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_weather_app/core/widgets/custom_button_widget.dart';
import 'package:todo_weather_app/core/widgets/custom_text_field_widget.dart';
import '../../../core/widgets/snackbar_widget.dart';
import '../../todo/presentation/todo_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _userNameController = TextEditingController(text: 'test');
  final _passController = TextEditingController(text: '1234');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            AppSnackBar.showSuccess(context, '${state.username} Logged In Successfully');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const TodoScreen()),
            );
          } else if (state is AuthFailure) {
            AppSnackBar.showError(context, state.message);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 70.0.h),
                  Text(
                    'Welcome Back!\nSignIn Here',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 50.0.h),
                  CustomTextFieldWidget(
                    controller: _userNameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    maxLength: 10,
                    titleText: 'Username',
                    maxLines: 1,
                    validator: (s) =>
                        (s == null || s.isEmpty) ? 'Username is required' : null,
                  ),
                  SizedBox(height: 14.h),
                  CustomTextFieldWidget(
                    controller: _passController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    maxLength: 10,
                    titleText: 'Password',
                    isPassword: true,
                    maxLines: 1,
                    validator: (s) =>
                        (s == null || s.isEmpty) ? 'Password is required' : null,
                  ),
                  SizedBox(height: 30.h),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return isLoading
                          ? const CircularProgressIndicator()
                          : CustomButtonWidget(
                              title: 'Login',
                              onPressed: isLoading ? null : _onLoginPressed
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onLoginPressed() {
    if (_form.currentState?.validate() ?? false) {
      final username = _userNameController.text.trim();
      final password = _passController.text.trim();
      context.read<AuthBloc>().add(AuthLoginRequested(username, password));
    }
  }
}
