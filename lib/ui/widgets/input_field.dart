import 'package:flutter/material.dart';
import 'package:todo_app/ui/size_config.dart';
import 'package:todo_app/ui/theme.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              title,
              style: titleStyle,
            ),
          ),
          SizedBox(
            width: SizeConfig.screenWidth,
            child: TextFormField(
              controller: controller,
              maxLines: 3,
              minLines: 1,
              readOnly: widget == null ? false : true,
              cursorColor: primaryClr,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                suffixIcon: widget ?? const SizedBox(),
                hintText: hint,
                hintStyle: subTitleStyle,
                isDense: true,
                enabled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryClr)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
