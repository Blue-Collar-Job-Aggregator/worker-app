import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/text_styles.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/data/auth_repository.dart';
import '../../jobs/data/job_providers.dart';
import '../../jobs/domain/job.dart';

class PostJobScreen extends ConsumerStatefulWidget {
  const PostJobScreen({super.key});

  @override
  ConsumerState<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends ConsumerState<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController(text: 'Delhi NCR');
  final _salaryController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  String _currentEmployerId() {
    final profile = ref.read(authControllerProvider).profile;
    if (profile is EmployerProfile) return profile.companyName;
    return 'Your company';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final job = Job(
      id: 'j-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      salary: _salaryController.text.trim(),
      employerId: _currentEmployerId(),
      status: JobStatus.open,
      createdAt: DateTime.now(),
    );

    ref.read(jobListProvider.notifier).addJob(job);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Posted: ${job.title}')),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: Text('Post a new job', style: AppTextStyles.heading2),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.md,
                      ),
                      children: [
                        Text(
                          'Tell workers what you need',
                          style: AppTextStyles.heading1,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Clear titles and descriptions get 3x more applicants.',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _FieldLabel('Job title'),
                        TextFormField(
                          controller: _titleController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Electrician for 2BHK rewiring',
                          ),
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.length < 3) return 'Please enter a job title';
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _FieldLabel('Description'),
                        TextFormField(
                          controller: _descriptionController,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.newline,
                          minLines: 4,
                          maxLines: 8,
                          decoration: const InputDecoration(
                            hintText:
                                'Scope of work, duration, any tools or materials provided…',
                          ),
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.length < 10) {
                              return 'Add a bit more detail (10+ characters)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _FieldLabel('Location'),
                        TextFormField(
                          controller: _locationController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Gurugram Sector 45',
                          ),
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return 'Location is required';
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _FieldLabel('Salary'),
                        TextFormField(
                          controller: _salaryController,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            hintText: 'e.g. ₹1,200 / day',
                          ),
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.length < 2) return 'Please enter a salary';
                            return null;
                          },
                          onFieldSubmitted: (_) => _submit(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Post job'),
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: AppTextStyles.bodyStrong),
    );
  }
}
