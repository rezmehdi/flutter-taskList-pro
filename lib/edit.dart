import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data.dart';

import 'main.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskEntity task;

  EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        elevation: 0,
        title: const Text('Edit Task'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final task = TaskEntity();
          task.name = _controller.text;
          task.priority = widget.task.priority;
          task.isCompleted = false;
          if (task.isInBox) {
            task.save();
          } else {
            final Box<TaskEntity> box = Hive.box(taskBoxName);
            box.add(task);
          }
          Navigator.of(context).pop();
        },
        label: const Row(
          children: [
            Text('Save Changes'),
            Icon(
              CupertinoIcons.check_mark,
              size: 18,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 1,
                  child: PriorityRadioButton(
                    label: 'High',
                    color: highPriority,
                    isSelected: widget.task.priority == Priority.high,
                    onTap: () {
                      setState(() {
                        widget.task.priority = Priority.high;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: PriorityRadioButton(
                    label: 'Normal',
                    color: normalPriority,
                    isSelected: widget.task.priority == Priority.normal,
                    onTap: () {
                      setState(() {
                        widget.task.priority = Priority.normal;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: PriorityRadioButton(
                    label: 'Low',
                    color: lowPriority,
                    isSelected: widget.task.priority == Priority.low,
                    onTap: () {
                      setState(() {
                        widget.task.priority = Priority.low;
                      });
                    },
                  ),
                ),
              ],
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                label: Text(
                  'Add a task for today...',
                  style:
                      themeData.textTheme.bodyLarge!.apply(fontSizeFactor: 1.4),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PriorityRadioButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;
  const PriorityRadioButton(
      {super.key,
      required this.label,
      required this.color,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: secondaryTextColor.withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: _CheckBoxShape(
                  value: isSelected,
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;

  const _CheckBoxShape({super.key, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 12,
            )
          : null,
    );
  }
}
