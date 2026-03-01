import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/route/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../cubit/reset_password_cubit.dart';
import '../cubit/reset_password_state.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode {
    return _otpControllers.map((c) => c.text).join();
  }

  void _onVerifyOtpPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final otp = _otpCode;
      if (otp.length == 6) {
        context.read<ResetPasswordCubit>().verifyOtp(
          email: widget.email,
          otp: otp,
        );
      } else {
        CustomSnackBar.show(context, message: 'الرجاء إدخال رمز التحقق كاملاً');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'التحقق من الرمز',
          style: AppTheme.heading3.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is VerifyOtpSuccess) {
            CustomSnackBar.show(
              context,
              message: state.response.message ?? 'تم التحقق بنجاح',
              backgroundColor: Colors.green,
            );
            Navigator.pushReplacementNamed(
              context,
              Routes.resetPassword,
              arguments: state.email,
            );
          } else if (state is ResetPasswordError) {
            CustomSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is ResetPasswordLoading;
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      // Icon
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.sms_outlined,
                            size: 80,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Title
                      Text(
                        'أدخل رمز التحقق',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'تم إرسال رمز التحقق إلى',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.email,
                        style: AppTheme.bodyLarge.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      // OTP Fields
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            6,
                            (index) => SizedBox(
                              width: 45,
                              child: TextFormField(
                                controller: _otpControllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 5) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Verify Button
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () => _onVerifyOtpPressed(context),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : Text(
                                    'تحقق',
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Resend OTP
                      TextButton(
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  context.read<ResetPasswordCubit>().sendOtp(
                                    email: widget.email,
                                  );
                                  CustomSnackBar.show(
                                    context,
                                    message: 'جاري إعادة إرسال الرمز...',
                                    backgroundColor: Colors.blue,
                                  );
                                },
                        child: Text(
                          'إعادة إرسال الرمز',
                          style: AppTheme.bodyLarge.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
