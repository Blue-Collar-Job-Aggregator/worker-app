import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/radius.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text_styles.dart';
import '../application/auth_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const _otpLength = 6;

  final _controller = TextEditingController();
  final _errorController = StreamController<ErrorAnimationType>.broadcast();
  String _currentCode = '';

  @override
  void dispose() {
    _controller.dispose();
    _errorController.close();
    super.dispose();
  }

  Future<void> _verify(String code) async {
    if (code.length != _otpLength) {
      _errorController.add(ErrorAnimationType.shake);
      Fluttertoast.showToast(msg: 'Enter the 6-digit code');
      return;
    }
    await ref.read(authControllerProvider.notifier).verifyOtp(code);
    final error = ref.read(authControllerProvider).errorMessage;
    if (error != null) {
      _errorController.add(ErrorAnimationType.shake);
      _controller.clear();
      setState(() => _currentCode = '');
      Fluttertoast.showToast(msg: error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final canVerify = _currentCode.length == _otpLength && !state.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
          onPressed: () =>
              ref.read(authControllerProvider.notifier).signOut(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.sm),
              const Text('Verify your number', style: AppTextStyles.heading1),
              const SizedBox(height: AppSpacing.sm),
              Text.rich(
                TextSpan(
                  style: AppTextStyles.caption,
                  children: [
                    const TextSpan(text: 'We sent a 6-digit code to '),
                    TextSpan(
                      text: state.phone ?? '',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: '. Use 123456 in dev.'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PinCodeTextField(
                appContext: context,
                controller: _controller,
                length: _otpLength,
                autoFocus: true,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 180),
                cursorColor: AppColors.primary,
                enableActiveFill: true,
                errorAnimationController: _errorController,
                textStyle: AppTextStyles.heading2.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  fieldHeight: 56,
                  fieldWidth: 48,
                  borderWidth: 1.2,
                  activeColor: AppColors.primary,
                  selectedColor: AppColors.primary,
                  inactiveColor: AppColors.border,
                  activeFillColor: AppColors.surface,
                  selectedFillColor: AppColors.surface,
                  inactiveFillColor: AppColors.surface,
                  errorBorderColor: AppColors.error,
                ),
                onChanged: (value) => setState(() => _currentCode = value),
                onCompleted: _verify,
                beforeTextPaste: (_) => true,
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          final phone = state.phone;
                          if (phone != null) {
                            ref
                                .read(authControllerProvider.notifier)
                                .sendOtp(phone);
                          }
                        },
                  child: Text(
                    'Resend code',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: canVerify ? () => _verify(_currentCode) : null,
                  child: state.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Verify'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
