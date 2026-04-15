import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text_styles.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/data/auth_repository.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _field1Controller = TextEditingController();
  final _field2Controller = TextEditingController();

  @override
  void dispose() {
    _field1Controller.dispose();
    _field2Controller.dispose();
    super.dispose();
  }

  Future<void> _submit(UserRole role) async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final f1 = _field1Controller.text.trim();
    final f2 = _field2Controller.text.trim();

    final profile = switch (role) {
      UserRole.employer =>
        EmployerProfile(companyName: f1, companyAddress: f2),
      UserRole.worker => WorkerProfile(fullName: f1, primarySkill: f2),
      UserRole.customer => CustomerProfile(fullName: f1, address: f2),
    };

    await ref.read(authControllerProvider.notifier).saveProfile(profile);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final role = state.role ?? UserRole.customer;
    final fields = _fieldsFor(role);

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.sm),
                Text(fields.title, style: AppTextStyles.heading1),
                const SizedBox(height: AppSpacing.sm),
                Text(fields.subtitle, style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.xl),
                Text(fields.field1Label, style: AppTextStyles.bodyStrong),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _field1Controller,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: fields.field1Hint),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.length < 2) return 'Please enter ${fields.field1Label.toLowerCase()}';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                Text(fields.field2Label, style: AppTextStyles.bodyStrong),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _field2Controller,
                  textInputAction: TextInputAction.done,
                  textCapitalization: fields.field2Multiline
                      ? TextCapitalization.sentences
                      : TextCapitalization.words,
                  minLines: fields.field2Multiline ? 2 : 1,
                  maxLines: fields.field2Multiline ? 4 : 1,
                  decoration: InputDecoration(hintText: fields.field2Hint),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.length < fields.field2MinLength) {
                      return 'Please enter ${fields.field2Label.toLowerCase()}';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _submit(role),
                ),
                const Spacer(),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: state.isLoading ? null : () => _submit(role),
                    child: state.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Save & continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileFields {
  const _ProfileFields({
    required this.title,
    required this.subtitle,
    required this.field1Label,
    required this.field1Hint,
    required this.field2Label,
    required this.field2Hint,
    required this.field2Multiline,
    required this.field2MinLength,
  });

  final String title;
  final String subtitle;
  final String field1Label;
  final String field1Hint;
  final String field2Label;
  final String field2Hint;
  final bool field2Multiline;
  final int field2MinLength;
}

_ProfileFields _fieldsFor(UserRole role) {
  switch (role) {
    case UserRole.employer:
      return const _ProfileFields(
        title: 'Tell us about your business',
        subtitle: 'Workers will see this when you post jobs.',
        field1Label: 'Company name',
        field1Hint: 'e.g. Arohi Constructions',
        field2Label: 'Company address',
        field2Hint: 'Street, locality, city',
        field2Multiline: true,
        field2MinLength: 6,
      );
    case UserRole.worker:
      return const _ProfileFields(
        title: 'Set up your worker profile',
        subtitle: 'Employers will see this when matching jobs.',
        field1Label: 'Full name',
        field1Hint: 'e.g. Ravi Kumar',
        field2Label: 'Primary skill',
        field2Hint: 'Electrician, Plumber, Cleaner…',
        field2Multiline: false,
        field2MinLength: 3,
      );
    case UserRole.customer:
      return const _ProfileFields(
        title: 'Complete your profile',
        subtitle: 'So workers know where to reach you.',
        field1Label: 'Full name',
        field1Hint: 'e.g. Priya Sharma',
        field2Label: 'Address',
        field2Hint: 'House / flat, street, locality',
        field2Multiline: true,
        field2MinLength: 6,
      );
  }
}
