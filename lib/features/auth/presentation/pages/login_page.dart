import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_temp/components/components.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/features/auth/cubit/login_cubit.dart';
import 'package:project_temp/features/auth/cubit/login_state.dart';
import 'package:project_temp/features/auth/presentation/auth_validators.dart';
import 'package:project_temp/features/auth/presentation/pages/register_page.dart';
import 'package:project_temp/features/auth/presentation/widgets/auth_page_scaffold.dart';
import 'package:project_temp/source/source.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.onLoggedIn});

  final void Function(User user) onLoggedIn;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(sl()),
      child: _LoginListener(onLoggedIn: onLoggedIn),
    );
  }
}

class _LoginListener extends StatelessWidget {
  const _LoginListener({required this.onLoggedIn});

  final void Function(User user) onLoggedIn;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (prev, curr) =>
          (curr.failureMessage != null &&
              curr.failureMessage != prev.failureMessage) ||
          (curr.user != null && curr.user != prev.user),
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
        final user = state.user;
        if (user != null) onLoggedIn(user);
      },
      child: _LoginForm(onLoggedIn: onLoggedIn),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({required this.onLoggedIn});

  final void Function(User user) onLoggedIn;

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<LoginCubit>().login(
          email: _email.text.trim(),
          password: _password.text,
        );
  }

  Future<void> _openRegister() async {
    final submitting = context.read<LoginCubit>().state.isSubmitting;
    if (submitting) return;
    final user = await Navigator.of(context).push<User?>(
      MaterialPageRoute<User?>(
        fullscreenDialog: true,
        builder: (_) => const RegisterPage(),
      ),
    );
    if (user != null && context.mounted) {
      widget.onLoggedIn(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (p, c) => p.isSubmitting != c.isSubmitting,
      builder: (context, state) {
        final submitting = state.isSubmitting;
        return AuthPageScaffold(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.maybePop(context),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          ),
          cardTitle: l10n.authLoginTitle,
          cardBody: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    controller: _email,
                    label: l10n.authEmailLabel,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    prefixIcon: Icon(
                      Icons.mail_outline_rounded,
                      color: AppThemes.textColorGrey,
                    ),
                    validator: (v) => AuthValidators.email(l10n, v),
                  ),
                  CustomTextFormField(
                    controller: _password,
                    label: l10n.authPasswordLabel,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    autofillHints: const [AutofillHints.password],
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
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    text: l10n.authSignIn,
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
                l10n.authNoAccount,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppThemes.textColorSecondary,
                    ),
              ),
              TextButton(
                onPressed: submitting ? null : _openRegister,
                child: Text(l10n.authGoRegister),
              ),
            ],
          ),
        );
      },
    );
  }
}
