import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/auth/user_provider.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:todo_app/tabs/tasks/task_item.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TasksTab extends StatefulWidget {
  const TasksTab({super.key});

  @override
  State<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<TasksTab> {
  bool shouldGetTasks = true;
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    double screenHeight = MediaQuery.sizeOf(context).height;
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);
    String userId = Provider.of<UserProvider>(
      context,
      listen: false,
    ).currentUser!.id;
    if (shouldGetTasks) {
      tasksProvider.getTasks(userId);
      shouldGetTasks = false;
    }
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: screenHeight * 0.2,
              width: double.infinity,
              color: AppTheme.primary,
            ),
            PositionedDirectional(
              top: 35,
              start: 20,
              child: SafeArea(
                child: Text(
                  AppLocalizations.of(context)!.todoList,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: settingsProvider.isDark
                            ? AppTheme.backgroundDark
                            : AppTheme.white,
                      ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.16,
              ),
              child: EasyInfiniteDateTimeLine(
                firstDate: DateTime.now().subtract(
                  const Duration(
                    days: 365,
                  ),
                ),
                focusDate: tasksProvider.selectedDate,
                lastDate: DateTime.now().add(
                  const Duration(
                    days: 365,
                  ),
                ),
                onDateChange: (selectedDate) =>
                    tasksProvider.getSelectedDateTasks(
                  selectedDate,
                  userId,
                ),
                showTimelineHeader: false,
                dayProps: EasyDayProps(
                  height: 79,
                  width: 58,
                  dayStructure: DayStructure.dayStrDayNum,
                  activeDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: settingsProvider.isDark
                          ? AppTheme.backgroundColorBottomNavigationBar
                          : AppTheme.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          5,
                        ),
                      ),
                    ),
                    dayNumStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                    dayStrStyle:
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.primary,
                            ),
                  ),
                  inactiveDayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: settingsProvider.isDark
                          ? AppTheme.backgroundColorBottomNavigationBar
                          : AppTheme.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          5,
                        ),
                      ),
                    ),
                    dayNumStyle:
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: settingsProvider.isDark
                                  ? AppTheme.white
                                  : AppTheme.black,
                            ),
                    dayStrStyle:
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: settingsProvider.isDark
                                  ? AppTheme.white
                                  : AppTheme.black,
                            ),
                  ),
                  todayStyle: DayStyle(
                    decoration: BoxDecoration(
                      color: settingsProvider.isDark
                          ? AppTheme.backgroundColorBottomNavigationBar
                          : AppTheme.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          5,
                        ),
                      ),
                    ),
                    dayNumStyle:
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: settingsProvider.isDark
                                  ? AppTheme.white
                                  : AppTheme.black,
                            ),
                    dayStrStyle:
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: settingsProvider.isDark
                                  ? AppTheme.white
                                  : AppTheme.black,
                            ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              top: 20,
            ),
            itemBuilder: (_, index) => TaskItem(
              task: tasksProvider.tasks[index],
            ),
            itemCount: tasksProvider.tasks.length,
          ),
        ),
      ],
    );
  }
}
