part of 'sensor_cubit.dart';

abstract class SensorStates {}

class SensorStateInitial extends SensorStates {}

class AccelerometerState extends SensorStates {
  var accelerometerReading;
  AccelerometerState(this.accelerometerReading);
}

class GyroscopeState extends SensorStates {
  var gyroscopeReading;
  GyroscopeState(this.gyroscopeReading);
}
