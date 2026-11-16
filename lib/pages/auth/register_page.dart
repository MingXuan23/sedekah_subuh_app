import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prim_derma_app/bloc/auth/register/register_bloc.dart';
import 'package:prim_derma_app/widget/loading_widget.dart';
import 'package:prim_derma_app/widget/prim_text_field.dart';
import 'package:prim_derma_app/widget/style.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _icController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _icController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitRegisterForm() {
    if (_autovalidateMode == AutovalidateMode.disabled) {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
    }
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(RegisterRequested(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            icno: _icController.text.trim(),
            telno: _phoneController.text.trim(),
            password: _passwordController.text,
            passwordConfirmation: _confirmPasswordController.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimAppBar('Daftar'),
      body: SafeArea(
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            final messenger = ScaffoldMessenger.of(context);
            if (state is RegisterSuccess) {
              messenger.showSnackBar(SnackBar(content: Text(state.message)));
              Navigator.pop(context);
            } else if (state is RegisterFailure) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Pendaftaran Gagal'),
                  content: Text(state.error),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            } else if (state is RegisterWithoutNetwork) {
              messenger.showSnackBar(
                const SnackBar(content: Text('Tiada sambungan internet')),
              );
            }
          },
          child: Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Form(
                            key: _formKey,
                            autovalidateMode: _autovalidateMode,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PrimTextField(
                                  controller: _nameController,
                                  field: 'Nama Penuh',
                                  hintText: 'Masukkan Nama Penuh Anda',
                                  icon: Icons.person,
                                  inputType: TextInputType.text,
                                ),
                                PrimTextField(
                                  controller: _emailController,
                                  field: 'Emel (Tidak Wajib)',
                                  hintText: 'Contoh: nama@gmail.com',
                                  icon: Icons.email,
                                  inputType: TextInputType.emailAddress,
                                  isRequired: false,
                                  validator: (v) =>
                                      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                              .hasMatch(v!.trim())
                                          ? null
                                          : 'Format emel tidak sah',
                                ),
                                PrimTextField(
                                  controller: _icController,
                                  field: 'No Kad Pengenalan',
                                  hintText: 'Contoh: 012345-67-8901',
                                  icon: Icons.credit_card,
                                  inputType: TextInputType.number,
                                  inputFormatters: [IcInputFormatter()],
                                  validator: (v) => v!.length == 14
                                      ? null
                                      : 'No Kad Pengenalan tidak lengkap',
                                ),
                                PrimTextField(
                                  controller: _phoneController,
                                  field: 'No Telefon',
                                  hintText: 'Contoh: 0123456789',
                                  icon: Icons.phone,
                                  inputType: TextInputType.phone,
                                ),
                                PrimTextField(
                                  controller: _passwordController,
                                  field: 'Kata Laluan',
                                  hintText: 'Masukkan kata laluan',
                                  icon: Icons.lock,
                                  inputType: TextInputType.visiblePassword,
                                  isObscureText: true,
                                  validator: (v) =>
                                      PasswordRequirements.isValid(v ?? '')
                                          ? null
                                          : 'Kata laluan tidak memenuhi syarat',
                                ),
                                PrimTextField(
                                  controller: _confirmPasswordController,
                                  field: 'Sahkan Kata Laluan',
                                  hintText: 'Masukkan semula kata laluan',
                                  icon: Icons.lock,
                                  inputType: TextInputType.visiblePassword,
                                  isObscureText: true,
                                  customErrorMessage:
                                      'Sila Masukkan Kata Laluan Anda Semula Lagi',
                                  validator: (v) =>
                                      v == _passwordController.text
                                          ? null
                                          : 'Kata laluan tidak sepadan',
                                ),
                                const SizedBox(height: 12),
                                PasswordRequirements(
                                  passwordController: _passwordController,
                                  confirmPasswordController:
                                      _confirmPasswordController,
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: AlignmentDirectional.center,
                                  child: Text(
                                    'Dengan mengklik Daftar, anda bersetuju dengan Terma PRIM.',
                                    style: hintTextStyle(),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                BlocBuilder<RegisterBloc, RegisterState>(
                                  builder: (context, state) => SizedBox(
                                    width: double.infinity,
                                    child: PrimButton(
                                      text: 'Daftar',
                                      color: SECONDARY_GREEN,
                                      onPressed: state is RegisterLoading
                                          ? null
                                          : _submitRegisterForm,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    if (state is! RegisterLoading) {
                      return const SizedBox.shrink();
                    }
                    return const AbsorbPointer(child: LoadingWidget());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  static final _upper = RegExp(r'[A-Z]');
  static final _lower = RegExp(r'[a-z]');
  static final _number = RegExp(r'[0-9]');
  static final _symbol = RegExp(r'[^A-Za-z0-9]');

  static bool isValid(String p) =>
      p.length >= 8 &&
      _upper.hasMatch(p) &&
      _lower.hasMatch(p) &&
      _number.hasMatch(p) &&
      _symbol.hasMatch(p);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable:
          Listenable.merge([passwordController, confirmPasswordController]),
      builder: (context, _) {
        final password = passwordController.text;
        final confirm = confirmPasswordController.text;

        final hasLength = password.length >= 8;
        final hasCase = _upper.hasMatch(password) && _lower.hasMatch(password);
        final hasNumberSymbol =
            _number.hasMatch(password) && _symbol.hasMatch(password);
        final isMatch = password.isNotEmpty && password == confirm;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFECEEFA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RuleItem(
                  text: 'Mengandungi sekurang-kurangnya 8 perkataan',
                  isMet: hasLength),
              _RuleItem(
                  text: 'Mengandungi huruf besar dan huruf kecil',
                  isMet: hasCase),
              _RuleItem(
                  text: 'Mengandungi nombor dan simbol',
                  isMet: hasNumberSymbol),
              _RuleItem(text: 'Kedua-dua kata laluan sepadan', isMet: isMatch),
            ],
          ),
        );
      },
    );
  }
}

class _RuleItem extends StatelessWidget {
  const _RuleItem({required this.text, required this.isMet});

  final String text;
  final bool isMet;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2E9E5B);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isMet ? Icons.check_circle : Icons.radio_button_unchecked,
              key: ValueKey(isMet),
              size: 20,
              color: isMet ? green : Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: hintTextStyle().copyWith(
                color: isMet ? green : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IcInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text;
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 12 ? digits.substring(0, 12) : digits;

    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i == 6 || i == 8) buffer.write('-');
      buffer.write(limited[i]);
    }
    final text = buffer.toString();

    final cursor = newValue.selection.end.clamp(0, raw.length);
    var cursorDigits =
        raw.substring(0, cursor).replaceAll(RegExp(r'\D'), '').length;
    if (cursorDigits > limited.length) cursorDigits = limited.length;
    final offset =
        cursorDigits + (cursorDigits > 6 ? 1 : 0) + (cursorDigits > 8 ? 1 : 0);

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
