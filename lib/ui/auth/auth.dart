import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/ui/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController usernameConroller = TextEditingController();
  final TextEditingController passwordConroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    const onBacground = Colors.white;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: themeData.copyWith(
            colorScheme: themeData.colorScheme.copyWith(onSurface: onBacground),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: const TextStyle(color: onBacground),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: onBacground),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
                minimumSize:
                    MaterialStateProperty.all(const Size.fromHeight(56)),
                backgroundColor: MaterialStateProperty.all(onBacground),
                foregroundColor:
                    MaterialStateProperty.all(themeData.colorScheme.secondary),
              ),
            ),
            snackBarTheme: SnackBarThemeData(
                backgroundColor: themeData.colorScheme.primary,
                contentTextStyle: const TextStyle(fontFamily: 'iranSans'))),
        child: Scaffold(
          backgroundColor: themeData.colorScheme.secondary,
          body: BlocProvider<AuthBloc>(
            create: (context) {
              final bloc = AuthBloc(authRepository);
              bloc.stream.forEach((state) {
                if (state is AuthSuccess) {
                  Navigator.of(context).pop();
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.exception.message),
                    duration: const Duration(seconds: 3),
                  ));
                }
              });
              bloc.add(AuthStarted());
              return bloc;
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(right: 24, left: 24),
                child: BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) {
                    return current is AuthLoading ||
                        current is AuthInitial ||
                        current is AuthError;
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/nike_logo.png',
                          color: Colors.white,
                          width: 110,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Text(
                          state.isLoginMode ? 'خوش آمدید' : 'ثبت نام',
                          style:
                              const TextStyle(color: onBacground, fontSize: 22),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          state.isLoginMode
                              ? 'لطفا وارد حساب کاربری خود شوید'
                              : 'لطفا برای ایجاد حساب کاربری خود اطلاعات زیر را وارد کنید',
                          style: TextStyle(
                              color: onBacground,
                              fontSize: state.isLoginMode ? 16 : 14),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextField(
                          controller: usernameConroller,
                          keyboardType: TextInputType.emailAddress,
                          decoration:
                              const InputDecoration(label: Text('آدرس ایمیل')),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _PasswordTextField(
                          onBacground: onBacground,
                          passwordController: passwordConroller,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<AuthBloc>(context).add(
                                  AuthButtonIsClicked(usernameConroller.text,
                                      passwordConroller.text));
                            },
                            child: state is AuthLoading
                                ? const CircularProgressIndicator()
                                : Text(state.isLoginMode ? 'ورود' : 'ثبت نام')),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<AuthBloc>(context)
                                .add(AuthModeChangeIsClicked());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.isLoginMode
                                    ? 'حساب کاربری ندارید ؟'
                                    : 'حسبا کابری دارید ؟',
                                style: const TextStyle(color: onBacground),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                state.isLoginMode ? 'ثبت نام' : 'ورود',
                                style: TextStyle(
                                    color: themeData.colorScheme.primary,
                                    decoration: TextDecoration.underline),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField(
      {Key? key, required this.onBacground, required this.passwordController})
      : super(key: key);

  final Color onBacground;
  final TextEditingController passwordController;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool isShowed = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: isShowed,
      decoration: InputDecoration(
          label: const Text('رمز عبور'),
          suffixIcon: IconButton(
            icon: Icon(
              isShowed
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: widget.onBacground.withOpacity(0.6),
            ),
            onPressed: () {
              setState(() {
                isShowed = !isShowed;
              });
            },
          )),
    );
  }
}
