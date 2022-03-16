import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/pages/home_page.dart';
import '../size_config.dart';
import '../theme.dart';

class TaskTile extends StatelessWidget {
  const TaskTile(this.task, this.selectedDate, {Key? key}) : super(key: key);
  final Task task;
  final DateTime selectedDate;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(
              SizeConfig.orientation == Orientation.landscape ? 4 : 12)),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: task.color == 4
                ? const DecorationImage(
                    image: AssetImage('images/img4.jpg'), fit: BoxFit.cover)
                : task.color == 5
                    ? const DecorationImage(
                        image: AssetImage('images/img1.jpg'), fit: BoxFit.cover)
                    : task.color == 6
                        ? const DecorationImage(
                            image: AssetImage('images/img2.jpg'),
                            fit: BoxFit.cover)
                        : task.color == 7
                            ? const DecorationImage(
                                image: AssetImage('images/img3.jpg'),
                                fit: BoxFit.cover)
                            : null,
            color: task.color! < 4 ? _getBGClr(task.color) : null),
        child: Row(
          children: [
            Expanded(
                child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                    child: Text(
                      task.title!,
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey[200],
                        size: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            '${task.startTime} ',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[200],
                              ),
                            ),
                          ),
                          Text(
                            '-',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[200],
                              ),
                            ),
                          ),
                          Text(
                            ' ${task.endTime}',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[200],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    task.note!,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                ],
              ),
            )),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              height: (task.isCompleted == 0 ||
                      DateTime.now().isBefore(selectedDate))
                  ? 45
                  : 70,
              width: (task.isCompleted == 0 ||
                      DateTime.now().isBefore(selectedDate))
                  ? 3
                  : 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: (task.isCompleted == 0 ||
                        DateTime.now().isBefore(selectedDate))
                    ? Colors.grey[700]
                    : Colors.green,
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (task.isCompleted == 0 ||
                        DateTime.now().isBefore(selectedDate))
                    ? Colors.grey[700]
                    : Colors.green,
              ),
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  (task.isCompleted == 0 ||
                          DateTime.now().isBefore(selectedDate))
                      ? 'Todo'.tr
                      : 'complete'.tr,
                  style: GoogleFonts.cairo(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getBGClr(int? color) {
    switch (color) {
      case 0:
        return bluishClr;
      case 1:
        return orangeClr;
      case 2:
        return redClr;
      case 3:
        return pinkClr;
      // case 4:
      //   return greenClr;
      // case 5:
      //   return redClr;
      default:
        bluishClr;
    }
  }
}
