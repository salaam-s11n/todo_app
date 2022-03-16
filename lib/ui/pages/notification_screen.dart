// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    Key? key,
    required this.payload,
  }) : super(key: key);

  final String payload;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';
  int color = 0;
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
    color = int.parse(_payload.toString().split('|')[3]);
    print(color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: appBarFun(context),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Text('hello'.tr, style: headingStyle),
                const SizedBox(
                  height: 10,
                ),
                Text('newRimend'.tr, style: subHeadingStyle),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                image: color == 4
                    ? const DecorationImage(
                        image: AssetImage('images/img4.jpg'),
                        fit: BoxFit.fitHeight)
                    : color == 5
                        ? const DecorationImage(
                            image: AssetImage('images/img1.jpg'),
                            fit: BoxFit.fitHeight)
                        : color == 6
                            ? const DecorationImage(
                                image: AssetImage('images/img2.jpg'),
                                fit: BoxFit.fitHeight)
                            : color == 7
                                ? const DecorationImage(
                                    image: AssetImage('images/img3.jpg'),
                                    fit: BoxFit.fitHeight)
                                : null,
                color: color < 4 ? _getBGClr(color) : null,
                // image: DecorationImage(
                //     image: AssetImage('images/img1.jpg'), fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.title_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FittedBox(
                          child: Text('title'.tr,
                              style:
                                  headingStyle.copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      _payload.toString().split('|')[0],
                      style: subHeadingStyle.copyWith(color: Colors.white),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FittedBox(
                          child: Text(
                            'note'.tr,
                            style: headingStyle.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      _payload.toString().split('|')[1],
                      style: subTitleStyle.copyWith(color: Colors.white),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pending_actions,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FittedBox(
                          child: Text(
                            'date'.tr,
                            style: headingStyle.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FittedBox(
                      child: Text(
                        _payload.toString().split('|')[2],
                        style: subHeadingStyle.copyWith(color: Colors.white),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBarFun(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: context.theme.backgroundColor,
      title: Text(
        'task'.tr,
        style: subHeadingStyle,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded),
        color: Get.isDarkMode ? Colors.white : Colors.black,
        onPressed: () => Get.back(),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
          child: InkWell(
            onTap: () {
              // notifyhelper.displayNotification(
              //     title: 'Theme Changed', body: 'done');
              // notifyhelper.scheduledNotification();
            },
            child: Card(
              elevation: 6,
              shadowColor: Get.isDarkMode ? Colors.white60 : Colors.grey[200],
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
