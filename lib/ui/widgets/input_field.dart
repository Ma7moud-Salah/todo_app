import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/size_config.dart';

import '../theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        //padding:const EdgeInsets.only(top: 8),
        margin: const EdgeInsets.only(top: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titleStyle,
            ),
            Container(
              padding: const EdgeInsets.only(left: 14),
              margin: const EdgeInsets.only(top: 8),
              width: SizeConfig.screenWidth,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey),
                // color: primaryClr
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      autofocus: false,
                      readOnly: widget == null ? false : true,
                      cursorColor:
                          Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                      style: subTitleStyle,
                      decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: subTitleStyle,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0,
                                  color: context.theme.backgroundColor)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 0,
                                  color: context.theme.backgroundColor))),
                    ),
                  ),
                  widget ?? Container()
                ],
              ),
            )
          ],
        ));
  }
}
