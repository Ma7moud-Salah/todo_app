import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/task_tile.dart';
import '../../controllers/task_controller.dart';
import '../../services/notification_services.dart';
import '../../services/theme_services.dart';
import '../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    // _taskController.getTask();
  }

  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          _showTask(),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          ThemeServices().switchThemeMode();
          // notifyHelper.displayNotification(
          //   title: 'Theme Changed',
          //   body: 'body',
          // );
          // notifyHelper.scheduledNotification();
        },
        icon: Icon(
            Get.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round_outlined,
            size: 24,
            color: Get.isDarkMode ? Colors.white : darkGreyClr),
      ),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            notifyHelper.cancelAllNotification();

            _taskController.deleteAllTask();
          },
          icon: Icon(Icons.cleaning_services_outlined,
              size: 24, color: Get.isDarkMode ? Colors.white : darkGreyClr),
        ),
        const SizedBox(
          width: 10,
        ),
        const CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        const SizedBox(
          width: 20,
        ),
      ],
      backgroundColor: context.theme.backgroundColor,
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
              label: '+ Add Task',
              onTap: () async {
                await Get.to(() => const AddTaskPage());
                _taskController.getTask();
              })
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 6),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: _selectedDate,
        width: 70,
        height: 100,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w600)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600)),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  _showTask() {
    // Task task=Task(
    //     id: 2,
    //     title: 'title',
    //     note:
    //     'hi my bro good luck to youhi my bro good luck to youhi my bro good luck to youhi my bro good luck to youhi my bro good luck to you hi my bro good luck to you',
    //     isCompleted: 0,
    //     date: DateTime.now().toString(),
    //     startTime: '3:24',
    //     endTime: '3:30',
    //     color: 0,
    //     remind: 1,
    //     repeat: '4');

    return Expanded(child: Obx(
      () {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemBuilder: (BuildContext contex, int index) {
                var task = _taskController.taskList[index];
                if (task.repeat == 'Daily' ||
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    (task.repeat == 'Weekly' &&
                        _selectedDate
                                    .difference(
                                        DateFormat.yMd().parse(task.date!))
                                    .inDays %
                                7 ==
                            0) ||
                    (task.repeat == 'Monthly' &&
                        DateFormat.yMd().parse(task.date!).day ==
                            _selectedDate.day)) {
                  // var hour=task.startTime.toString().split(':')[0];
                  // var minutes=task.startTime.toString().split(':')[1];
                  var date = DateFormat.jm().parse(task.startTime!);
                  var myTime = DateFormat('HH:mm').format(date);
                  // debugPrint('My Hour is $hour');
                  // debugPrint('My Hour is $minutes');
                  // debugPrint('############################is completed = ${task.isCompleted} ############################');
                  // debugPrint('############################is title = ${task.title} ############################');

                  notifyHelper.scheduledNotification(
                      int.parse(myTime.toString().split(':')[0]),
                      int.parse(myTime.toString().split(':')[1]),
                      task);
                  return AnimationConfiguration.staggeredList(
                    duration: const Duration(milliseconds: 1333),
                    position: index,
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
              itemCount: _taskController.taskList.length,
            ),
          );
        }
        //  return  Container(height: 0,);
      },
    ));
  }

  //return ,
  /* child: Obx(
          () {
            if (_taskController.taskList.isEmpty) {
              return _noTaskMsg();
            } else {
              return Container(
                height: 0,
              );
            }
            //  return  Container(height: 0,);
          },
        ),*/

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 6,
                        )
                      : const SizedBox(
                          height: 220,
                        ),
                  SvgPicture.asset(
                    'images/task.svg',
                    semanticsLabel: 'Task',
                    color: primaryClr.withOpacity(.5),
                    height: 90,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'You don\'t have any task yet!\n Add new tasks to make your days productive',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 120,
                        )
                      : const SizedBox(
                          height: 180,
                        ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * .6
                : SizeConfig.screenHeight * .8)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * .30
                : SizeConfig.screenHeight * .39),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: 'Task Completed',
                    onTap: () {
                      notifyHelper.cancelNotification(task);
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryClr,
                  ),
            // Divider(color: Get.isDarkMode?Colors.grey:darkGreyClr,),
            _buildBottomSheet(
              label: 'Delete Task',
              onTap: () {
                Get.back();
                notifyHelper.cancelNotification(task);
                _taskController.deleteTask(task);
              },
              clr: Colors.red[300]!,
            ),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            _buildBottomSheet(
              label: 'Cancel',
              onTap: () {
                Get.back();
              },
              clr: primaryClr,
            ),
          ],
        ),
      ),
    ));
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * .9,
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr,
            ),
            borderRadius: BorderRadius.circular(20),
            color: isClose ? Colors.transparent : clr),
        child: Text(
          label,
          // textAlign: TextAlign.center,
          style:
              isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTask();
  }
}
