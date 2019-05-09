library shake;
import 'dart:async';
import 'dart:math';
import 'package:sensors/sensors.dart';
import 'package:flutter/foundation.dart';

class ShakeGesture {
  ShakeGesture.waitForStart(
      {@required this.onPhoneShake,
        this.shakeThresholdGravity = 2.7,
        this.shakeSlopTimeMS = 500,
        this.shakeCountResetTime = 3000});

  ShakeGesture.autoStart(
      {@required this.onPhoneShake,
        this.shakeThresholdGravity = 2.7,
        this.shakeSlopTimeMS = 500,
        this.shakeCountResetTime = 3000}) {
    startListening();
  }
  final Function onPhoneShake;
  final double shakeThresholdGravity;
  final int shakeSlopTimeMS;
  final int shakeCountResetTime;

  int _mShakeTimestamp = DateTime.now().millisecondsSinceEpoch;
  int _mShakeCount = 0;

  StreamSubscription<AccelerometerEvent> streamSubscription;

  void startListening() {
    streamSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      final double x = event.x;
      final double y = event.y;
      final double z = event.z;

      final double gX = x / 9.80665;
      final double gY = y / 9.80665;
      final double gZ = z / 9.80665;

      // gForce will be close to 1 when there is no movement.
      final double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

      if (gForce > shakeThresholdGravity) {
        final int now = DateTime.now().millisecondsSinceEpoch;
        // ignore shake events too close to each other (500ms)
        if (_mShakeTimestamp + shakeSlopTimeMS > now) {
          return;
        }

        // reset the shake count after 3 seconds of no shakes
        if (_mShakeTimestamp + shakeCountResetTime < now) {
          _mShakeCount = 0;
        }

        _mShakeTimestamp = now;
        _mShakeCount++;

        onPhoneShake(_mShakeCount);
      }
    });
  }

  /// Stops listening to accelerometer events
  void stopListening() {
    streamSubscription?.cancel();
  }
}