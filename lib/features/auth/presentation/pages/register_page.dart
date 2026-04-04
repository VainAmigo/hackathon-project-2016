import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_temp/components/components.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/auth/cubit/register_cubit.dart';
import 'package:project_temp/features/auth/cubit/register_state.dart';
import 'package:project_temp/features/auth/presentation/auth_validators.dart';
import 'package:project_temp/features/auth/presentation/widgets/auth_page_scaffold.dart';
import 'package:project_temp/l10n/app_localizations.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(sl()),
      child: BlocListener<RegisterCubit, RegisterState>(
        listenWhen: (prev, curr) =>
            (curr.failureMessage != null &&
                curr.failureMessage != prev.failureMessage) ||
            (curr.registration != null &&
                curr.registration != prev.registration),
        listener: (context, state) {
          final msg = state.failureMessage;
          if (msg != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
            return;
          }
          if (state.registration != null) {
            final l10n = AppLocalizations.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.authRegisterSuccess)),
            );
            Navigator.of(context).pop();
          }
        },
        child: const _RegisterForm(),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<RegisterCubit>().register(
          username: _username.text.trim(),
          password: _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (p, c) => p.isSubmitting != c.isSubmitting,
      builder: (context, state) {
        final submitting = state.isSubmitting;
        return AuthPageScaffold(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.maybePop(context),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          ),
          cardTitle: l10n.authRegisterTitle,
          cardBody: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    controller: _username,
                    label: l10n.authUsernameLabel,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newUsername],
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: AppThemes.textColorGrey,
                    ),
                    validator: (v) => AuthValidators.username(l10n, v),
                  ),
                  CustomTextFormField(
                    controller: _password,
                    label: l10n.authPasswordLabel,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: AppThemes.textColorGrey,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppThemes.textColorGrey,
                      ),
                    ),
                    validator: (v) => AuthValidators.password(l10n, v),
                    onChanged: (_) {
                      if (_confirm.text.isNotEmpty) {
                        _formKey.currentState?.validate();
                      }
                    },
                  ),
                  CustomTextFormField(
                    controller: _confirm,
                    label: l10n.authConfirmPasswordLabel,
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    autofillHints: const [AutofillHints.newPassword],
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: AppThemes.textColorGrey,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppThemes.textColorGrey,
                      ),
                    ),
                    validator: (v) =>
                        AuthValidators.confirmPassword(l10n, v, _password.text),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    text: l10n.authSignUp,
                    onPressed: submitting ? null : _submit,
                    child: submitting
                        ? const CenteredProgressingButton(null)
                        : null,
                  ),
                ],
              ),
            ),
          ),
          footer: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              Text(
                l10n.authHaveAccount,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppThemes.textColorSecondary,
                    ),
              ),
              TextButton(
                onPressed: submitting ? null : () => Navigator.maybePop(context),
                child: Text(l10n.authGoLogin),
              ),
            ],
          ),
        );
      },
    );
  }
}
