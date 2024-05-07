// ignore_for_file: camel_case_types

import 'dart:async';
import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class localnotificationservice {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =StreamController();
  static onTap(NotificationResponse notificationResponse){

    streamController.add(notificationResponse);

  }
  static Future <void> init() async {
/*
  const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings darwinInitializationSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,

  );
*/
  InitializationSettings settings = const InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  );

await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
          );
  }
//void _onDidReceiveNotificationRespones(NotificationResponse details) {}


//basic notifications
//-----water every 4 hours
    static void showbasicnotifications()async{
      log("bacsic start");
      AndroidNotificationDetails android =const AndroidNotificationDetails(
        "id 0",
        "basic notification",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true
      );
      NotificationDetails details = NotificationDetails(android: android);
      tz.initializeTimeZones();
      //log(tz.local.name);
      //final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      //log("$currentTimeZone---------------------------");
      tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
      
      var currentTime=tz.TZDateTime.now(tz.local);
      if (currentTime.hour>16) {
        await flutterLocalNotificationsPlugin.show(
        0,
        "feeling stressed ?",
        "Drinking enough water can help improve your mood 💧",
        details,
        payload: "payload data");
      } else {
        await flutterLocalNotificationsPlugin.show(
        0,
        "water ",
        "its time to drink water! 💦",
        details,
        payload: "payload data");
      }
      log("basic end");
    }

    //repeated notifications
    static void showRepeatedwaternotifications()async{
      AndroidNotificationDetails android =const AndroidNotificationDetails(
        "id 1",
        "repeated notification",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true
      );

      NotificationDetails details = NotificationDetails(android: android);
      await flutterLocalNotificationsPlugin.periodicallyShow(
        1,
      "Good Morning ♥",
      "its time to drink water! 💦",
      RepeatInterval.hourly,
      details,
      payload:"payload data",);
      log("water joinned repet");
    }

//local Scheduled  notifications
    static void showSchedulednotifications()async{
      AndroidNotificationDetails android =const AndroidNotificationDetails(
        "id 2",
        "Scheduled notification",
        importance: Importance.max,
        priority: Priority.high,
      );
      NotificationDetails details = NotificationDetails(android: android);

      tz.initializeTimeZones();
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone));

      
      await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      "Scheduled  notifications",
      "body",
      //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 20)),
      tz.TZDateTime(
        tz.local,
        2024,
        4,
        30,
        22,
        30
      ),
      details,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime ,
      );
    }



//Scheduled daily notifications
//*dinner--------------> 9*
    static void showDailySchedulednotifications()async{
        log("dinnernotification");
      const AndroidNotificationDetails android = AndroidNotificationDetails(
        "id 3",
        "Daily Dinner Scheduled notification",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );
      NotificationDetails details = const NotificationDetails(
      android: android,
    );
      tz.initializeTimeZones();
      //log(tz.local.name);
      //final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      //log("$currentTimeZone---------------------------");
      tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
      log(tz.local.name);
      
      var currentTime=tz.TZDateTime.now(tz.local);
      log(currentTime.year.toString());
      log(currentTime.month.toString());
      log(currentTime.day.toString());
      log(currentTime.hour.toString());
      log(currentTime.minute.toString());
      log(currentTime.second.toString());

      var scheduledtime =tz.TZDateTime(
        tz.local,
        currentTime.year,
        currentTime.month,
        currentTime.day,
        21,
      );

      log(scheduledtime.year.toString());
      log(scheduledtime.month.toString());
      log(scheduledtime.day.toString());
      log(scheduledtime.hour.toString());
      log(scheduledtime.minute.toString());
      log(scheduledtime.second.toString());

      if (scheduledtime.isBefore(currentTime)) {
      scheduledtime = scheduledtime.add(const Duration(days: 1));
      log(scheduledtime.year.toString());
      log(scheduledtime.month.toString());
      log(scheduledtime.day.toString());
      log(scheduledtime.hour.toString());
      log(scheduledtime.minute.toString());
      log(scheduledtime.second.toString());
      log("durations added -------------------------");
      }

      log("2----------------------------");
      await flutterLocalNotificationsPlugin.zonedSchedule(
      3,
      "Dinner time !🍳",
      "You haven't logged your Dinner for today. Would you like to do it now ?",
      //scheduledtime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2)),
      scheduledtime,
      details,
      payload: "payload",
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime ,
      );
      log("3---------------------");
      log(scheduledtime.year.toString());
      log(scheduledtime.month.toString());
      log(scheduledtime.day.toString());
      log(scheduledtime.hour.toString());
      log(scheduledtime.minute.toString());
      log(scheduledtime.second.toString());
      log("dinner notification done");
    }


//*lunch--------------> 4*
    static void showDailyLunchSchedulednotifications() async{
            log("lunchnotification start");
      const AndroidNotificationDetails android = AndroidNotificationDetails(
        "id 4",
        "Daily Lunch Scheduled notification",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );
      NotificationDetails details = const NotificationDetails(
      android: android,
    );
      tz.initializeTimeZones();
      //log(tz.local.name);
      //final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      //log("$currentTimeZone---------------------------");
      tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
      log(tz.local.name);
      
      var currentTime=tz.TZDateTime.now(tz.local);
      log(currentTime.year.toString());
      log(currentTime.month.toString());
      log(currentTime.day.toString());
      log(currentTime.hour.toString());
      log(currentTime.minute.toString());
      log(currentTime.second.toString());

      var scheduledtime =tz.TZDateTime(
        tz.local,
        currentTime.year,
        currentTime.month,
        currentTime.day,
        16,
      );
      
      log(scheduledtime.year.toString());
      log(scheduledtime.month.toString());
      log(scheduledtime.day.toString());
      log(scheduledtime.hour.toString());
      log(scheduledtime.minute.toString());
      log(scheduledtime.second.toString());

      if (scheduledtime.isBefore(currentTime)) {
      scheduledtime = scheduledtime.add(const Duration(days: 1));
      log(scheduledtime.year.toString());
      log(scheduledtime.month.toString());
      log(scheduledtime.day.toString());
      log(scheduledtime.hour.toString());
      log(scheduledtime.minute.toString());
      log(scheduledtime.second.toString());
      log("durations added -------------------------");
      }

      log("2----------------------------");
      await flutterLocalNotificationsPlugin.zonedSchedule(
      4,
      "Lunch time !🍝",
      "You haven't logged your Lunch for today. Would you like to do it now ?",
      //scheduledtime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2)),
      scheduledtime,
      details,
      
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime ,
      );
      log("3---------------------");
      log(scheduledtime.year.toString());
      log(scheduledtime.month.toString());
      log(scheduledtime.day.toString());
      log(scheduledtime.hour.toString());
      log(scheduledtime.minute.toString());
      log(scheduledtime.second.toString());
      log("lunch notification done");
    }

//*Breakfast--------------> 10*
    static void showDailyBreakfastSchedulednotifications() async{
      log("breakfastnotification");
      const AndroidNotificationDetails android = AndroidNotificationDetails(
        "id 5",
        "Daily Breakfast Scheduled notification",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,

      );
      NotificationDetails details = const NotificationDetails(
      android: android,
    );
      tz.initializeTimeZones();
      //log(tz.local.name);
      //final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      //log("$currentTimeZone---------------------------");
      tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
      log(tz.local.name);
      
      var currentTime=tz.TZDateTime.now(tz.local);
      log(currentTime.year.toString());
      log(currentTime.month.toString());
      log(currentTime.day.toString());
      log(currentTime.hour.toString());
      log(currentTime.minute.toString());
      log(currentTime.second.toString());

      var scheduledtime =tz.TZDateTime(
        tz.local,
        currentTime.year,
        currentTime.month,
        currentTime.day,
        10,
      );
      
      log(scheduledtime.year.toString());
      log(scheduledtime.month.toString());
      log(scheduledtime.day.toString());
      log(scheduledtime.hour.toString());
      log(scheduledtime.minute.toString());
      log(scheduledtime.second.toString());

      if (scheduledtime.isBefore(currentTime)) {
      scheduledtime = scheduledtime.add(const Duration(days: 1));
      log(scheduledtime.year.toString());
      log(scheduledtime.month.toString());
      log(scheduledtime.day.toString());
      log(scheduledtime.hour.toString());
      log(scheduledtime.minute.toString());
      log(scheduledtime.second.toString());
      log("durations added -------------------------");

      }

      log("2----------------------------");
      await flutterLocalNotificationsPlugin.zonedSchedule(
      5,
      "Good morning 🌅",
      "Start your day by logging your Breakfast 🤗",
      //scheduledtime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2)),
      scheduledtime,
      details,
      
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime ,
      );
      log("3---------------------");
      log(scheduledtime.year.toString());
      log(scheduledtime.month.toString());
      log(scheduledtime.day.toString());
      log(scheduledtime.hour.toString());
      log(scheduledtime.minute.toString());
      log(scheduledtime.second.toString());
      log("breakfast notification done");
    }





  static void cancelNotifications(int id){
  flutterLocalNotificationsPlugin.cancel(id);
  }

  static void cancelall(){
    flutterLocalNotificationsPlugin.cancelAll();
  }

    }


