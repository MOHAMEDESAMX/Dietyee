
import 'dart:developer';
import 'package:diety/Core/model/notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:async';

class WorkManagerSercice{

  @pragma('vm:entry-point')
  void regestermytask()async{
  await Workmanager().registerPeriodicTask(
    "1",
    "callback",
    frequency: const Duration(hours: 23),
    tag: "lunch notification"
    );
        log("regester lunch task");
  }

  
  @pragma('vm:entry-point')
  void regesterdinner()async{
  await Workmanager().registerPeriodicTask(
    "2",
    "dinner notifications",
    frequency: const Duration(hours: 23),
    tag: "dinner notification"

    );
        log("regester dinner task");

  }


  @pragma('vm:entry-point')
  void watertask()async{
  await Workmanager().registerPeriodicTask(
    "3",
    "water notifications",
    frequency: const Duration(hours: 4),
    tag: "water notification"
    );
        log("regester water task");

  }

  
  @pragma('vm:entry-point')
  void breakfasttask()async{
  await Workmanager().registerPeriodicTask(
    "4",
    "breakfast notifications",
    frequency: const Duration(hours: 23),
    tag: "breakfast notification"
    );
        log("regester breakfast task");

  }


//init workmanager service
  Future<void> init()async{
  await Workmanager().initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
      log("repeted dinner");
  //regester my task
  regestermytask();
        log("task regestered");
  }

  Future<void> dinner()async{
    log("the dinner logging");
  await Workmanager().initialize(
    dinnernotification, // The top level function, aka callbackDispatcher
    isInDebugMode: false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
        log("called dinner");

  //regester my task
  regesterdinner();
        log("dinner task regestered");

  }

  Future<void> lunch()async{
  await Workmanager().initialize(
    lunchnotification, // The top level function, aka callbackDispatcher
    isInDebugMode: false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
        log("called lunch");
  //regester my task
  regestermytask();
        log("lunch task regestered");
  }


  Future<void> repetedDinner()async{
  await Workmanager().initialize(
    dinnernotification, // The top level function, aka callbackDispatcher
    isInDebugMode: false, // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
      log("repeted dinner");
  //regester my task
  regestermytask();
      log("task regestered");

  }
  
  Future<void> repetedwater()async{
            log("water logging");

  await Workmanager().initialize(
    waternotification, // The top level function, aka callbackDispatcher
    isInDebugMode: false, // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  //regester my task
  watertask();
  }

    Future<void> breakfast()async{
            log("breakfast logging");
  await Workmanager().initialize(
    breakfastnotification, // The top level function, aka callbackDispatcher
    isInDebugMode: false, // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  //regester my task
  breakfasttask();
  }


  void canceltask(String uniqueName){
    Workmanager().cancelByUniqueName(uniqueName);
  }

  void cancelAll(){
    Workmanager().cancelAll();
  }

}



@pragma('vm:entry-point')
void actiontaskes (){
    Workmanager().executeTask((taskName, inputData){
      localnotificationservice.showbasicnotifications();
    return Future.value(true);
    });
  }
  //repeted
  @pragma('vm:entry-point')
void waternotification (){
    Workmanager().executeTask((taskName, inputData){
      localnotificationservice.showbasicnotifications();
    return Future.value(true);
    });
  }



//schedual notifications
//dinner notification at 9 pm
@pragma('vm:entry-point')
void dinnernotification (){
    log("dinner executing");
    Workmanager().executeTask((taskName, inputData){
      localnotificationservice.showDailySchedulednotifications();
      
    return Future.value(true);
    });
    log("dinner workexecuted");
  }

@pragma('vm:entry-point')
void lunchnotification(){
    Workmanager().executeTask((taskName, inputData){
      log("Native called background task:-- $taskName");
      localnotificationservice.showDailyLunchSchedulednotifications();
    return Future.value(true);
    });
    log("lunch workexecute");
  }


@pragma('vm:entry-point')
void breakfastnotification(){
    Workmanager().executeTask((taskName, inputData){
      localnotificationservice.showDailyBreakfastSchedulednotifications();
    return Future.value(true);
    });
    log("breakfast workexecute");
  }

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    log("Native called background task: $task"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}