import 'package:event_bus/event_bus.dart';

class AppEventManager {
  static final AppEventManager _singleton = AppEventManager._internal();
  factory AppEventManager() => _singleton;
  AppEventManager._internal();
  EventBus _eventBus = EventBus();
  EventBus get eventBus => _eventBus;
  void dispose(){
    _eventBus.destroy();
    _eventBus = EventBus();
  }
}
