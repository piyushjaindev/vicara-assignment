import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../services/websocket.dart';

part 'sensor_states.dart';

class SensorCubit extends Cubit<SensorStates> {
  SensorCubit(this._socket) : super(SensorStateInitial());

  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;

  late StreamSubscription _accelerometerListener;
  late StreamSubscription _gyroscopeListener;
  late Timer _timer;

  WebSocket _socket;

  void init() {
    _accelerometerListener = accelerometerEvents.listen((accelerometer) {
      _accelerometerEvent = accelerometer;
      emit(AccelerometerState(accelerometer));
    });

    _gyroscopeListener = gyroscopeEvents.listen((gyroscope) {
      _gyroscopeEvent = gyroscope;
      emit(GyroscopeState(gyroscope));
    });

    _timer = Timer.periodic(Duration(seconds: 1), _sendEventToSocket);
  }

  void _sendEventToSocket(Timer _) async {
    print('callback');
    if (_accelerometerEvent != null)
      _socket.addSocketEvent('accelerometer', {
        'x': _accelerometerEvent!.x.toStringAsPrecision(5),
        'y': _accelerometerEvent!.y.toStringAsPrecision(5),
        'z': _accelerometerEvent!.z.toStringAsPrecision(5),
      });
    if (_gyroscopeEvent != null)
      _socket.addSocketEvent('gyroscope', {
        'x': _gyroscopeEvent!.x.toStringAsPrecision(5),
        'y': _gyroscopeEvent!.y.toStringAsPrecision(5),
        'z': _gyroscopeEvent!.z.toStringAsPrecision(5),
      });
  }

  @override
  Future<void> close() {
    _accelerometerListener.cancel();
    _gyroscopeListener.cancel();
    _timer.cancel();
    return super.close();
  }
}
