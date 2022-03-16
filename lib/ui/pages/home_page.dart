// ignore_for_file: unused_element

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/ui/pages/notification_screen.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import '../../services/theme_services.dart';
import '../size_config.dart';
import '../theme.dart';
import '../widgets/button.dart';
import '../widgets/task_tile.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyhelper;
  List<String> lang = ['en', 'ar'];
  List<String> colors = const [
    '0xFFB15470',
    '0xFF00CC66',
    '0xFFaa0037',
    '0xFF4e5ae8',
    '0xCFFF8746',
    '0xFFff4667',
  ];

  String selectedLang = 'en';
  @override
  void initState() {
    super.initState();
    notifyhelper = NotifyHelper();
    notifyhelper.initializeNotification();
    notifyhelper.requestIOSPermissions();
    _taskController.getTask();
  }

  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    _sayHello();

    // double Top = MediaQuery.of(context).padding.top;

    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: SizeConfig.orientation == Orientation.landscape
            ? null
            : appBarFun(context),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            const SizedBox(
              height: 6,
            ),
            _showTasks(),
          ],
        ));
  }

  AppBar appBarFun(BuildContext context) {
    return AppBar(
      elevation: 0,
      // centerTitle: true,
      title: FittedBox(
        child: Text(
          'To Do',
          style: GoogleFonts.satisfy(
            textStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
      backgroundColor: context.theme.backgroundColor,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
        child: Card(
          color: Colors.white,
          elevation: 6,
          shadowColor: Colors.grey[200],
          child: const CircleAvatar(
            backgroundImage: AssetImage('images/appicon.jpeg'),
            radius: 16,
          ),
        ),
      ),

      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            settingMethod(),
          ],
        )
      ],
    );
  }

  Padding settingMethod() {
    return Padding(
      padding: const EdgeInsets.only(right: 6, left: 6),
      child: InkWell(
          onTap: () {
            // var task = _taskController.taskList[0];
            // _taskController.deleteAllTask();
            // Get.dialog(Text("data"));
            // notifyhelper.scheduledNotification(10, 22, task);
            _showDialog();
          },
          child: Icon(
            Icons.settings_suggest,
            color: Get.isDarkMode ? Colors.white : Colors.black,
            size: 32,
          )
          // const CircleAvatar(
          //   backgroundImage: AssetImage('images/appicon.jpeg'),
          //   radius: 18,
          // ),
          // ),
          ),
    );
  }

  _addTaskBar() {
    return Container(
      height: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenHeight * 0.2
          : SizeConfig.screenHeight * 0.09,
      margin: SizeConfig.orientation == Orientation.landscape
          ? EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 5,
              right: 5,
              bottom: 3)
          : const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    _sayHello(),
                    style: subHeadingStyle,
                  ),
                ),
                FittedBox(
                  child: Text(
                    'today'.tr,
                    style: headingStyle,
                  ),
                ),
              ],
            ),
          ),
          SizeConfig.orientation == Orientation.landscape
              ? Expanded(
                  child: settingMethod(),
                )
              : Expanded(child: Container()),
          Expanded(
            flex: 2,
            child: MyButton(
              label: 'addTask'.tr,
              onTap: () async {
                await Get.to(const AddTaskPage());
                _taskController.getTask();
              },
            ),
          ),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      height: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenHeight * 0.27
          : SizeConfig.screenHeight * 0.12,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 120,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        onDateChange: (selectedDate) {
          setState(() {
            _selectedDate = selectedDate;
          });
        },
        monthTextStyle: bodyStyle,
        dayTextStyle: bodyStyle,
        dateTextStyle: headingStyle,
        daysCount: 365,
        initialSelectedDate: DateTime.now(),
        locale: 'local'.tr,
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMessage();
        } else {
          return _taskList();
        }
      }),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTask();
  }

  _taskList() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: SizeConfig.orientation == Orientation.landscape
              ? Axis.horizontal
              : Axis.vertical,
          itemCount: _taskController.taskList.length,
          itemBuilder: (context, index) {
            var task = _taskController.taskList[index];

            if ((task.repeat == 'Daily' || task.repeat == 'يوميا') ||
                task.date == DateFormat.yMd().format(_selectedDate) ||
                ((task.repeat == 'Weekly' || task.repeat == 'اسبوعيا') &&
                    _selectedDate
                                .difference(DateFormat.yMd().parse(task.date!))
                                .inDays %
                            7 ==
                        0) ||
                ((task.repeat == 'Monthly' || task.repeat == 'شهريا') &&
                    DateFormat.yMd().parse(task.date!).day ==
                        _selectedDate.day)) {
              // var hour = task.startTime.toString().split(':')[0];
              // var minutes = task.startTime.toString().split(':')[1];
              // debugPrint('my hour is ' + hour);
              // debugPrint('my muin is ' + minutes);
              var date = DateFormat.jm().parse(task.startTime!);
              var myTime = DateFormat('hh:mm').format(date);
              print(
                  "Hour======= ${int.parse(myTime.toString().split(':')[0])} ");
              print(
                  "min======= ${int.parse(myTime.toString().split(':')[1])} ");
              // notifyhelper.displayNotification(title: "title", body: "body");
              notifyhelper.scheduledNotification(
                int.parse(myTime.toString().split(':')[0]),
                int.parse(myTime.toString().split(':')[1]),
                task,
              );
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  horizontalOffset: 300,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () => _showBottomSheet(context, task),
                      child: TaskTile(task, _selectedDate),
                    ),
                  ),
                ),
              );
            } else
              // {
              //   if (_taskController.taskList
              //       .where((date) =>
              //           date.date == DateFormat.yMd().format(_selectedDate))
              //       .isEmpty) {
              //     return _noTaskMessage();
              //   }
              //   else
              //   {
              return Container();
            // }
            // }
          }),
    );
  }

  _noTaskMessage() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: (SizeConfig.screenHeight * 0.22)),
                alignment: Alignment.topCenter,
                height: SizeConfig.screenHeight * 0.7,
                child: Wrap(
                  direction: SizeConfig.orientation == Orientation.landscape
                      ? Axis.horizontal
                      : Axis.vertical,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'images/task.svg',
                      height: 90,
                      semanticsLabel: 'Task',
                      color: primaryClr.withOpacity(0.6),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Text(
                        'noTask'.tr,
                        style: subTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        ),
        padding: const EdgeInsets.only(top: 8),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.525
                : SizeConfig.screenHeight * 0.72)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.32
                : SizeConfig.screenHeight * 0.4),
        child: Column(
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(top: 3),
                height: 4,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        Get.isDarkMode ? Colors.grey[600] : Colors.grey[500]),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            task.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: 'completed'.tr,
                    onTap: () {
                      // notifyhelper.cancleNotification(task);
                      _taskController.markTaskAsCompleted(task.id!);
                      Get.back();
                    },
                    clr: greenClr),
            _buildBottomSheet(
                label: 'show task'.tr,
                onTap: () {
                  Get.to(NotificationScreen(
                    payload:
                        '${task.title}|${task.note}|${task.startTime}|${task.color}',
                  ));
                },
                clr: primaryClr),
            _buildBottomSheet(
                label: 'delete'.tr,
                onTap: () {
                  notifyhelper.cancleNotification(task);
                  _taskController.deleteTask(task);
                  Get.back();
                },
                clr: redClr),
            Divider(
              indent: 30,
              endIndent: 30,
              thickness: 1,
              color: Get.isDarkMode ? Colors.grey : Colors.grey[500],
            ),
            _buildBottomSheet(
                label: 'Cancle'.tr,
                onTap: () {
                  Get.back();
                },
                clr: context.theme.backgroundColor.withOpacity(0.6)),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      // enterBottomSheetDuration: const Duration(milliseconds: 300),
      elevation: 2,
      isScrollControlled: true,
    );
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  Future _showDialog() {
    return Get.defaultDialog(
      title: 'Setting'.tr,
      titleStyle: headingStyle.copyWith(
        color: Get.isDarkMode ? Colors.black : Colors.white,
      ),
      backgroundColor: Get.isDarkMode
          ? Colors.white.withOpacity(0.8)
          : Colors.black.withOpacity(0.8),
      content: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            height: SizeConfig.screenHeight * 0.32,
            width: SizeConfig.screenWidth * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // color: Get.isDarkMode
              //     ? Colors.white.withOpacity(0.9)
              //     : Colors.black.withOpacity(0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _showAction(
                    'Theme'.tr,
                    Get.isDarkMode
                        ? const Icon(
                            Icons.light_mode_rounded,
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.dark_mode_rounded,
                            color: Colors.white,
                          ), () {
                  ThemeServices().switchTheme();
                }, 'theme changed'.tr),
                _showAction(
                    'Delete All Task'.tr,
                    Icon(
                      Icons.delete_forever,
                      color: Get.isDarkMode ? Colors.black : Colors.white,
                    ), () {
                  _taskController.deleteAllTask();
                }, 'deleted task'.tr),
                _showAction(
                    'Cancle All Notification'.tr,
                    Icon(
                      Icons.notifications_off,
                      color: Get.isDarkMode ? Colors.black : Colors.white,
                    ), () {
                  notifyhelper.cancleAllNotification();
                  // setState(() {
                  //   primaryClr = greenClr;
                  // });
                }, 'cancle notification'.tr),
                Expanded(
                  child: Container(
                    // color: Colors.red,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'App Languge'.tr,
                            style: subHeadingStyle.copyWith(
                                color: Get.isDarkMode
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            items: lang
                                .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value.toUpperCase(),
                                        style: titleStyle),
                                  ),
                                )
                                .toList(),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color:
                                  Get.isDarkMode ? Colors.black : Colors.white,
                            ),
                            iconSize: 32,
                            // value: selectedLang,
                            elevation: 2,
                            underline: const SizedBox(
                              height: 0,
                              width: 0,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedLang = newValue!;
                                Get.updateLocale(Locale(selectedLang));
                                _showSnackBar('Setting'.tr, 'app lang'.tr);
                              });
                            },
                            alignment: Alignment.centerRight,
                            style: subTitleStyle,
                            borderRadius: BorderRadius.circular(15),
                            dropdownColor:
                                Get.isDarkMode ? Colors.black : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    // color: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'App Color'.tr,
                            style: subHeadingStyle.copyWith(
                                color: Get.isDarkMode
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: DropdownButton<String>(
                            // isExpanded: true,

                            items: colors
                                .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: GestureDetector(
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Color(int.parse(value)),
                                          radius: 12,
                                        ),
                                      )),
                                )
                                .toList(),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color:
                                  Get.isDarkMode ? Colors.black : Colors.white,
                            ),
                            iconSize: 32,
                            // value: primaryClr.toString(),
                            elevation: 2,
                            underline: const SizedBox(
                              height: 0,
                              width: 0,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                primaryClr = Color(int.parse(newValue!));
                                _showSnackBar('Setting'.tr, 'app color'.tr);
                              });
                            },
                            alignment: Alignment.center,
                            style: subTitleStyle,
                            borderRadius: BorderRadius.circular(15),
                            dropdownColor:
                                Get.isDarkMode ? Colors.black : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SnackbarController _showSnackBar(String title, String desc) {
    return Get.snackbar(
      title,
      desc,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.only(bottom: 8, right: 5, left: 5),
      animationDuration: const Duration(milliseconds: 750),
      // colorText: Colors.red,
      backgroundColor: Get.isDarkMode
          ? Colors.white.withOpacity(0.7)
          : Colors.black.withOpacity(0.7),
      // colorText: Colors.red,
      messageText: Text(
        desc,
        style: subTitleStyle.copyWith(color: primaryClr),
      ),
      titleText: Text(
        title,
        style: titleStyle.copyWith(color: primaryClr),
      ),
      icon: Icon(
        Icons.settings_applications_sharp,
        color: primaryClr,
        size: 40,
      ),
    );
  }

  _showAction(String s, Icon icon, Function() onTaped, String desc) {
    return Expanded(
      child: Container(
        // color: Colors.red,
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: InkWell(
          splashColor: Get.isDarkMode
              ? Colors.white.withOpacity(0.0)
              : Colors.black.withOpacity(0.0),
          highlightColor: Get.isDarkMode
              ? Colors.white.withOpacity(0.0)
              : Colors.black.withOpacity(0.0),
          onTap: () {
            onTaped();
            _showSnackBar('Setting'.tr, desc);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  s,
                  style: subHeadingStyle.copyWith(
                    color: Get.isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
              Expanded(child: icon),
            ],
          ),
        ),
      ),
    );
  }

  String _sayHello() {
    String date = DateFormat('hh:mm:a').format(DateTime.now());
    print(date);
    if (date.split(':')[2] == 'AM') {
      return 'good morning'.tr;
    } else {
      return 'good evining'.tr;
    }
  }
}
