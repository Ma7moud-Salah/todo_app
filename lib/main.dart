import 'package:flutter/material.dart';
import 'package:todo/db/db_helper.dart';

import '/ui/theme.dart';

import 'services/theme_services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'ui/pages/home_page.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  DBHelper.initDb();
  GetStorage.init();
  runApp( const MyApp());
  //NotifyHelper().initializeNotifications();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      title: 'Flutter Tasks',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,

      debugShowCheckedModeBanner: false,
      home:const HomePage( )// HomePage()// NotificationScreen(payLoad: 'Mo|Salah|Goda'),
    );
  }
}
