import 'package:flutter/material.dart';
import 'package:nike_shop/data/favorite_manager.dart';
import 'package:nike_shop/data/repo/auth_repository.dart';
import 'package:nike_shop/theme.dart';
import 'package:nike_shop/ui/root.dart';

void main() async {
  await FavoriteManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defualtTextStyle = TextStyle(
        fontFamily: 'iranSans', color: LightThemeColor.praimaryTextColor);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: LightThemeColor.primaryColor,
          secondary: LightThemeColor.secendaryColor,
          onSecondary: Colors.white,
        ),
        textTheme: TextTheme(
          subtitle1:
              defualtTextStyle.apply(color: LightThemeColor.secendaryTextColor),
          bodyText2: defualtTextStyle,
          caption:
              defualtTextStyle.apply(color: LightThemeColor.secendaryTextColor),
          button: defualtTextStyle,
          headline6: defualtTextStyle.copyWith(
              fontSize: 18, fontWeight: FontWeight.w600),
        ),
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: defualtTextStyle.copyWith(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
            centerTitle: true,
            iconTheme:
                const IconThemeData(color: LightThemeColor.praimaryTextColor),
            backgroundColor: LightThemeColor.surfaceColor,
            titleTextStyle: defualtTextStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: LightThemeColor.praimaryTextColor,
                fontSize: 18),
            elevation: 0),
        hintColor: LightThemeColor.praimaryTextColor,
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: LightThemeColor.praimaryTextColor.withOpacity(0.1),
            ),
          ),
        ),
      ),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: RootScreen()),
    );
  }
}
