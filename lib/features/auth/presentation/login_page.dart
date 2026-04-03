import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_temp/core/core.dart';
import 'package:project_temp/source/source.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.onLoggedIn});

  final void Function(User user) onLoggedIn;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneDigits = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;

  AuthRepository get _auth => sl();

  @override
  void dispose() {
    _phoneDigits.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    final result = await _auth.login(
      phoneNumber: PhoneFormat.buildForRequest(_phoneDigits.text.trim()),
      password: _password.text,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
      (login) => widget.onLoggedIn(login.user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: AutofillGroup(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 56,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Вход',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Формат номера: ${PhoneFormat.prefix} и 9 цифр',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _phoneDigits,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        maxLength: PhoneFormat.nationalDigits,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: 'Телефон',
                          hintText: '555123456',
                          helperText: 'В запрос: 996XXXXXXXXX (без +)',
                          counterText: '',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.phone_outlined),
                          prefixText: '${PhoneFormat.prefix} ',
                          prefixStyle: Theme.of(context).textTheme.bodyLarge,
                        ),
                        validator: PhoneFormat.validateNineDigits,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _password,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        autofillHints: const [AutofillHints.password],
                        decoration: InputDecoration(
                          labelText: 'Пароль',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.key_outlined),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Введите пароль';
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),
                      FilledButton(
                        onPressed: _submitting ? null : _submit,
                        child: _submitting
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Войти'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
