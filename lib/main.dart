import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data.dart';
import 'package:task_list/edit.dart';

const taskBoxName = 'tasks';
void main() async {
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
        ),
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
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(taskBoxName);
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('To Do List'),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditTaskScreen(
                    task: TaskEntity(),
                  )));
        },
        label: const Row(
          children: [
            Text('Add New Task'),
            SizedBox(
              width: 4,
            ),
            Icon(CupertinoIcons.add),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  themeData.colorScheme.primary,
                  themeData.colorScheme.primaryVariant,
                ]),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TO DO List',
                          style: themeData.textTheme.titleLarge!
                              .apply(color: themeData.colorScheme.onPrimary),
                        ),
                        Icon(
                          CupertinoIcons.share,
                          color: themeData.colorScheme.onPrimary,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          color: themeData.colorScheme.onPrimary,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20),
                          ]),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.search),
                          label: Text('Search tasks...'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<Box<TaskEntity>>(
                valueListenable: box.listenable(),
                builder: (context, box, child) {
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: box.values.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Today',
                                  style: themeData.textTheme.titleLarge!
                                      .apply(fontSizeFactor: 0.9),
                                ),
                                Container(
                                  width: 70,
                                  height: 3,
                                  margin: EdgeInsets.only(top: 4),
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(1.5)),
                                )
                              ],
                            ),
                            MaterialButton(
                                color: const Color(0xffEAEFF5),
                                textColor: secondaryTextColor,
                                elevation: 0,
                                onPressed: () {},
                                child: const Row(
                                  children: [
                                    Text('Delete All'),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Icon(
                                      CupertinoIcons.delete_solid,
                                      size: 18,
                                    ),
                                  ],
                                ))
                          ],
                        );
                      } else {
                        final TaskEntity task = box.values.toList()[index - 1];
                        return TaskItem(task: task);
                      }
                    },
                  );
                },
                // child: ListView.builder(
                //   itemCount: box.values.length,
                //   itemBuilder: (context, index) {
                //     final Task task = box.values.toList()[index];
                //     return Container(
                //       child: Text(
                //         task.name,
                //         style: TextStyle(fontSize: 24),
                //       ),
                //     );
                //   },
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() {
          widget.task.isCompleted = !widget.task.isCompleted;
        });
      },
      child: Container(
        height: 84,
        margin: EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: themeData.colorScheme.surface,
          // boxShadow: [
          //   BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.2))
          // ],
        ),
        child: Row(
          children: [
            MyCheckBox(
              value: widget.task.isCompleted,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                widget.task.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 24,
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool value;

  const MyCheckBox({super.key, required this.value});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: !value ? Border.all(color: secondaryTextColor, width: 2) : null,
        color: value ? primaryColor : null,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 16,
            )
          : null,
    );
  }
}
