import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/screens/home/home.dart';

const taskBoxName = 'tasks';
void main() async {
  // final Repository<TaskEntity> repository =
  //     Repository(HiveTaskDataSource(Hive.box(taskBoxName)));

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: primaryVariantColor));
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794CFF);
const Color primaryVariantColor = Color(0xff5C0AFF);
const Color secondaryTextColor = Color(0xffAEBED0);
const normalPriority = Color(0xffF09819);
const lowPriority = Color(0xff3BE1F1);
const highPriority = primaryColor;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff1D2830);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            border: InputBorder.none,
            labelStyle: TextStyle(color: secondaryTextColor),
            iconColor: secondaryTextColor,
            floatingLabelBehavior: FloatingLabelBehavior.never),
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          onPrimary: Colors.white,
          primaryVariant: primaryVariantColor,
          // primaryContainer: Color(0xff5c0AFF),
          background: Color(0xffF3F5F8),
          surface: Colors.white,
          onSurface: primaryTextColor,
          onBackground: primaryTextColor,
          secondary: primaryColor,
          onSecondary: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
            TextTheme(titleLarge: TextStyle(fontWeight: FontWeight.bold))),
      ),
      home: HomeScreen(),
    );
  }
}
