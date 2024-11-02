import 'package:flutter/material.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/tabs/tasks/add_task_bottom_sheet.dart';
import 'package:todo_app/tabs/settings/settings_tab.dart';
import 'package:todo_app/tabs/tasks/tasks_tab.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> tabs = [
    const TasksTab(),
    const SettingsTab(),
  ];
  int currentTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTabIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            10,
          ),
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          padding: EdgeInsets.zero,
          color: AppTheme.white,
          child: BottomNavigationBar(
            currentIndex: currentTabIndex,
            onTap: (index) => setState(
              () {
                currentTabIndex = index;
              },
            ),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                label: 'Tasks',
                icon: Icon(
                  Icons.list,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Settings',
                icon: Icon(
                  Icons.settings,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (_) => const AddTaskBottomSheet(),
        ),
        child: const Icon(
          Icons.add,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
