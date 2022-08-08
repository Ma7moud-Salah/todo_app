import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import '../../models/task.dart';
import '../widgets/input_field.dart';
import '/controllers/task_controller.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  final List<int> _remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> _repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              InputField(
                title: 'Title',
                hint: 'Enter Title Here',
                controller: _titleController,
                // widget: Icon(Icons.access_alarm),
              ),
              InputField(
                title: 'Note',
                hint: 'Enter note Here',
                controller: _noteController,
                // widget: Icon(Icons.access_alarm),
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                //  controller: _titleController,
                widget: IconButton(
                  onPressed: () => _getDateFromUser(),
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
                // widget: Icon(Icons.access_alarm),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      //  controller: _titleController,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                      // widget: Icon(Icons.access_alarm),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      //  controller: _titleController,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                      // widget: Icon(Icons.access_alarm),
                    ),
                  )
                ],
              ),
              InputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                //  controller: _titleController,
                widget: Row(
                  children: [
                    DropdownButton(
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: Colors.blueGrey,
                      // value: _selectedRemind,
                      items: _remindList
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      style: subTitleStyle,
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedRemind = int.parse(value.toString());
                        });
                      },
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
                // widget: Icon(Icons.access_alarm),
              ),
              InputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                //  controller: _titleController,
                widget: Row(
                  children: [
                    DropdownButton(
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: Colors.blueGrey,
                      // value: _selectedRemind,
                      items: _repeatList
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      style: subTitleStyle,
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedRepeat = value.toString();
                        });
                      },
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                  ],
                ),
                // widget: Icon(Icons.access_alarm),
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalatte(),
                  MyButton(
                      label: 'Create Task',
                      onTap: () {
                        _validateData();
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_forward_ios,
          size: 24,
          color: primaryClr,
        ),
      ),
      elevation: 0,
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        SizedBox(
          width: 20,
        ),
      ],
      backgroundColor: context.theme.backgroundColor,
    );
  }

  Column _colorPalatte() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text('Color',style: titleStyle,),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List.generate(
            3,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : orangeClr,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('Required', 'All Fields Are Required',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: pinkClr,
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    } else {
      print(
          '###################### SOMETHING BAD HAPPENED ######################');
    }
  }

  _addTasksToDb() async {
    int value = await _taskController.addTask(
        task: Task(
            title: _titleController.text,
            note: _noteController.text,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat,
            isCompleted: 0,
        ));
    print('$value');
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    } else
      print(
          '############################# ERROR #############################');
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input ,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(DateTime.now().add(const Duration(minutes: 15))),
    );
    String _formattedTime=_pickedTime!.format(context);
    if (isStartTime){
      setState(() {
        _startTime =_formattedTime ;
      });
    }
    else if (!isStartTime){
      setState(() {
        _endTime =_formattedTime ;
      });
    }
    else
      print(
          '############################# ERROR #############################');
    //
    // if (_pickedTime != null) {
    //
    // } else
    //   print(
    //       '############################# ERROR #############################');
  }
}
