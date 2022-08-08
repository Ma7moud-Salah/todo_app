import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payLoad}) : super(key: key);
  final String payLoad;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payLoad = '';

  @override
  void initState() {
    // TODO: implement initState
    _payLoad = widget.payLoad;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_forward_ios,
              color: Get.isDarkMode ? Colors.white : darkGreyClr),
        ),
        elevation: 0,
        title: Text(
          _payLoad.toString().split('|')[0],
          style: TextStyle(color: Get.isDarkMode ? Colors.white : darkGreyClr),
        ),
        backgroundColor: context.theme.backgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Text(
                  'Hello Mo',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Get.isDarkMode ? Colors.white : darkGreyClr,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'You have a New Reminder',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Get.isDarkMode ? Colors.grey[100] : darkGreyClr,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30), color: primaryClr),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.text_format,
                            size: 35,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Title',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _payLoad.toString().split('|')[0],
                        style:
                            const TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.description,
                            size: 35,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Description',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _payLoad.toString().split('|')[1],
                        style:
                            const TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.description,
                            size: 35,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Date',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _payLoad.toString().split('|')[2],
                        style:
                            const TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
