import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prim_derma_app/bloc/auth/login/login_bloc.dart';
import 'package:prim_derma_app/models/user.dart';
import 'package:prim_derma_app/pages/auth/register_page.dart';
import 'package:prim_derma_app/repo/env_variable.dart';
import 'package:prim_derma_app/widget/prim_text_field.dart';

import 'package:prim_derma_app/widget/style.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with login
      BlocProvider.of<LoginBloc>(context).add(
        LoginRequested(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  void openPrimWeb() async {
    await launchUrl(Uri.parse(PRIM_DERMA_URL));
  }

  @override
  void initState() {
    super.initState();
    initialiseForm();
  }

  void initialiseForm() async {
    var email = await User.retrieveEmail();
    _emailController.text = email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimAppBar('Login'),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              'lib/assets/sedekahsubuh_logo.png',
                              width: 200,
                              height: 200,
                            ),
                            PrimTextField(
                              controller: _emailController,
                              field: 'Emel/IC No',
                              hintText: 'Masukkan emel atau IC anda',
                              icon: Icons.email,
                              inputType: TextInputType.emailAddress,
                            ),
                            PrimTextField(
                              controller: _passwordController,
                              field: 'Kata Laluan',
                              hintText: 'Masukkan kata laluan anda',
                              icon: Icons.lock,
                              inputType: TextInputType.visiblePassword,
                              isObscureText: true,
                            ),
                            const SizedBox(height: 28),
                            PrimButton(
                              text: 'Log In',
                              color: SECONDARY_GREEN,
                              onPressed: _submitForm,
                            ),
                            const SizedBox(height: 16),
                            PrimButton(
                              text: 'Teruskan Dalam Web',
                              color: PRIMARY_GREY,
                              onPressed: openPrimWeb,
                            ),
                            Align(
                              child: TextButton(
                                onPressed: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage()),
                                  );
                                  if (!mounted) return;
                                  initialiseForm();
                                },
                                child: const Text.rich(
                                  TextSpan(
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
                                    children: [
                                      TextSpan(text: 'Belum ada akaun? '),
                                      TextSpan(
                                        text: 'Daftar',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
