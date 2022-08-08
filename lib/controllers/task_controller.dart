import 'package:get/get.dart';

import '../db/db_helper.dart';
import '/models/task.dart';

class TaskController extends GetxController {
  final taskList = <Task>[].obs;

  // Task(
  //     id: 0,
  //     title: 'title',
  //     note:
  //     'hi my bro good luck to youhi my bro good luck to youhi my bro good luck to youhi my bro good luck to youhi my bro good luck to you hi my bro good luck to you',
  //     isCompleted: 0,
  //     date: DateTime.now().toString(),
  //     startTime:
  // DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 1))).toString(),
  //  //   DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 1))).toString(),
  //     endTime: '3:30',
  //     color: 0,
  //     remind: 1,
  //     repeat: '4'),
  //   Task(
  //       id:1,
  //       title: 'title',
  //       note:
  //       'hi my bro good luck to youhi my bro good luck to youhi my bro good luck to youhi my bro good luck to youhi my bro good luck to you hi my bro good luck to you',
  //       isCompleted: 1,
  //       date: DateTime.now().toString(),
  //       startTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 1))).toString(),
  //       endTime: '3:30',
  //       color: 1,
  //       remind: 1,
  //       repeat: '4'),
  //   Task(
  //       id: 2,
  //       title: 'title',
  //       note:
  //       'hi my bro good luck to youhi my bro good luck to youhi my bro good luck to youhi my bro good luck to youhi my bro good luck to you hi my bro good luck to you',
  //       isCompleted: 0,
  //       date: DateTime.now().toString(),
  //       startTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 1))).toString(),
  //       endTime: '3:30',
  //       color: 2,
  //       remind: 1,
  //       repeat: '4'),
  //   Task(
  //       id: 3,
  //       title: 'title',
  //       note:
  //       'hi my bro good luck to youhi my bro good luck to youhi my bro good luck to youhi my bro good luck to youhi my bro good luck to you hi my bro good luck to you',
  //       isCompleted: 1,
  //       date: DateTime.now().toString(),
  //       startTime: DateFormat('hh:mm a').format(DateTime.now().add(Duration(minutes: 1))).toString(),
  //       endTime: '3:30',
  //       color: 0,
  //       remind: 1,
  //       repeat: '4'),

  // ];
  Future<void> getTask() async {
    final List<Map<String, Object?>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((json) => Task.fromJson(json)).toList());
    //tasks.m
  }

  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task!);
  }

  deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTask();
  }

  deleteAllTask() async {
    await DBHelper.deleteAllTask();
    getTask();
  }

  markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTask();
  }
}
