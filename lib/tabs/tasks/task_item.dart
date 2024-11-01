import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/app_theme.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({super.key});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 20,
      ),
      padding: const EdgeInsets.all(
        20,
      ),
      decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(
            15,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 62,
            width: 4,
            margin: const EdgeInsetsDirectional.only(
              end: 12,
            ),
            color: AppTheme.primary,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Play Basketball',
                style: textTheme.titleMedium?.copyWith(
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Task Description Task Descripition',
                style: textTheme.titleSmall,
              ),
            ],
          ),
          Container(
            height: 34,
            width: 69,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: const Icon(
              FontAwesomeIcons.check,
              color: AppTheme.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
