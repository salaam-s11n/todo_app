// ignore_for_file: prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controllers/task_controller.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/size_config.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/button.dart';
import 'package:todo_app/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _hintController = TextEditingController();
  DateTime _selsctedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 1)))
      .toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 30)))
      .toString();
  int _selectedRemind = 0;
  List<int> remindList = [0, 5, 10, 15, 20];
  String _selectedRepeat = 'none'.tr;
  List<String> repeatList = ['none'.tr, 'dialy'.tr, 'weekly'.tr, 'monthly'.tr];
  int _selectedColor = 0;
  String before = 'minutes'.tr;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: appBarFun(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  'addTask'.tr,
                  style: headingStyle,
                ),
              ),
              InputField(
                hint: 'enterTitle'.tr,
                title: 'title'.tr,
                controller: _titleController,
              ),
              InputField(
                hint: 'enterNote'.tr,
                title: 'note'.tr,
                controller: _hintController,
              ),
              InputField(
                hint: DateFormat.yMd().format(_selsctedDate),
                title: 'date'.tr,
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      hint: _startTime,
                      title: 'startTime'.tr,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.timer,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: InputField(
                      hint: _endTime,
                      title: 'endTime'.tr,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.snooze,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                hint: '$_selectedRemind $before',
                title: 'reimnd'.tr,
                widget: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: DropdownButton<String>(
                    items: remindList
                        .map<DropdownMenuItem<String>>(
                          (value) => DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(
                              '$value',
                              style: TextStyle(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 2,
                    underline: const SizedBox(
                      height: 0,
                      width: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    },
                    alignment: Alignment.center,
                    style: subTitleStyle,
                    menuMaxHeight: SizeConfig.screenHeight * 0.3,
                    borderRadius: BorderRadius.circular(15),
                    dropdownColor: context.theme.primaryColor,
                  ),
                ),
              ),
              InputField(
                hint: _selectedRepeat,
                title: 'repeat'.tr,
                widget: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: DropdownButton<String>(
                    items: repeatList
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 2,
                    underline: const SizedBox(
                      height: 0,
                      width: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                    alignment: Alignment.center,
                    style: subTitleStyle,
                    menuMaxHeight: SizeConfig.screenHeight * 0.3,
                    borderRadius: BorderRadius.circular(15),
                    dropdownColor: context.theme.primaryColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    colorColumn(),
                    Expanded(
                        child: MyButton(
                            label: 'addTask'.tr,
                            onTap: () {
                              _validateDate();
                            }))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Expanded colorColumn() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'color'.tr,
            style: titleStyle,
          ),
          Wrap(
              children: List.generate(
            8,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                child: CircleAvatar(
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done_rounded,
                          color: Colors.white,
                          size: 25,
                        )
                      : null,
                  backgroundImage: index >= 4
                      ? index == 5
                          ? const AssetImage('images/img1.jpg')
                          : index == 6
                              ? const AssetImage('images/img2.jpg')
                              : index == 7
                                  ? const AssetImage('images/img3.jpg')
                                  : index == 4
                                      ? const AssetImage('images/img4.jpg')
                                      : null
                      : null,
                  backgroundColor: index < 4
                      ? (index == 0
                          ? bluishClr
                          : index == 1
                              ? orangeClr
                              : index == 2
                                  ? redClr
                                  : greenClr)
                      : null,
                  radius: 17,
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  AppBar appBarFun(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: context.theme.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded),
        color: Get.isDarkMode ? Colors.white : Colors.black,
        onPressed: () => Get.back(),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
          child: InkWell(
            onTap: () {
              String date = DateFormat('hh:mm:a').format(DateTime.now());
              print(date);
              print(date.split(':')[2]);

              // notifyhelper.displayNotification(
              //     title: 'Theme Changed', body: 'done');
              // notifyhelper.scheduledNotification();
            },
            child: Card(
              elevation: 6,
              shadowColor: Get.isDarkMode ? Colors.white60 : Colors.grey[100],
              color: Colors.white,
              child: const CircleAvatar(
                backgroundImage: AssetImage('images/appicon.jpeg'),
                radius: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _hintController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _hintController.text.isEmpty) {
      _showSnackBar('Required'.tr, 'All fields are required'.tr);
    } else {
      print("ERORRRRRRRRRRRRRR");
    }
  }

  SnackbarController _showSnackBar(String title, String desc) {
    return Get.snackbar(
      title,
      desc,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(bottom: 8, right: 5, left: 5),
      animationDuration: const Duration(milliseconds: 750),
      backgroundColor: Get.isDarkMode
          ? Colors.white.withOpacity(0.7)
          : Colors.black.withOpacity(0.7),
      // colorText: Colors.red,
      messageText: Text(
        desc,
        style: subTitleStyle.copyWith(color: Colors.red),
      ),
      titleText: Text(
        title,
        style: titleStyle.copyWith(color: Colors.red),
      ),
      icon: const Icon(
        Icons.warning_rounded,
        color: Colors.red,
      ),
    );
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _hintController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selsctedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
    print(value);
  }

  void _getDateFromUser() async {
    var endDate = DateTime.now().add(const Duration(days: 365));
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _selsctedDate,
      firstDate: _selsctedDate,
      lastDate: endDate,
    );
    if (_pickedDate != null) {
      setState(() {
        _selsctedDate = _pickedDate;
      });
    } else {
      _showSnackBar('Required'.tr, 'Select Date are required'.tr);
    }
  }

  void _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15)),
            ),
    );

    if (_pickedTime != null) {
      String _fotmattedTime = _pickedTime.format(context);
      if (isStartTime) {
        setState(() {
          _startTime = _fotmattedTime;
        });
      } else if (!isStartTime) {
        setState(() {
          _endTime = _fotmattedTime;
        });
      }
    } else {
      print("nonr of them");
      _showSnackBar('Required'.tr, 'Select Time are required'.tr);
    }
  }
}
