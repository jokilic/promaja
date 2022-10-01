import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:get/get.dart';
import 'package:location/location.dart' as location;

import 'logger_service.dart';

///
/// Service used for fetching location data
/// Has methods for two plugins - `Location` and `Geolocator`
///

class LocationService extends GetxService {
  ///
  /// DEPENDENCIES
  ///

  final logger = Get.find<LoggerService>();

  ///
  /// METHODS
  ///

  /// Get location with [Geolocator] package
  Future<geolocator.Position?> getLocationWithGeolocatorPackage() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    try {
      serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        logger
          ..e('LOCATION')
          ..e('--------------------')
          ..e('Location not enabled')
          ..e('--------------------\n');
        return null;
      }

      permission = await geolocator.Geolocator.checkPermission();
      if (permission == geolocator.LocationPermission.denied) {
        permission = await geolocator.Geolocator.requestPermission();
        if (permission == geolocator.LocationPermission.denied) {
          logger
            ..e('LOCATION')
            ..e('--------------------')
            ..e('Location permission denied')
            ..e('--------------------\n');
          return null;
        }
      }

      if (permission == geolocator.LocationPermission.deniedForever) {
        logger
          ..e('LOCATION')
          ..e('--------------------')
          ..e('Location permission denied forever')
          ..e('--------------------\n');
        return null;
      }

      final position = await geolocator.Geolocator.getCurrentPosition(timeLimit: const Duration(seconds: 60), desiredAccuracy: geolocator.LocationAccuracy.high);

      logger
        ..v('LOCATION')
        ..v('--------------------')
        ..v('Location fetched')
        ..v('$position')
        ..v('--------------------\n');

      return position;
    } catch (e) {
      logger
        ..e('LOCATION')
        ..e('--------------------')
        ..e('Location error')
        ..e('$e')
        ..e('--------------------\n');
    }
    return null;
  }

  /// Get location with [Location] package
  Future<location.LocationData?> getLocationWithLocationPackage() async {
    final locationInstance = location.Location();

    bool? serviceEnabled;
    location.PermissionStatus? permission;

    try {
      serviceEnabled = await locationInstance.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await locationInstance.requestService();
        if (!serviceEnabled) {
          logger
            ..e('LOCATION')
            ..e('--------------------')
            ..e('Location not enabled')
            ..e('--------------------\n');
          return null;
        }
      }
      permission = await locationInstance.hasPermission();
      if (permission == location.PermissionStatus.denied) {
        permission = await locationInstance.requestPermission();
        if (permission == location.PermissionStatus.denied) {
          logger
            ..e('LOCATION')
            ..e('--------------------')
            ..e('Location permission denied')
            ..e('--------------------\n');
          return null;
        }
      }

      if (permission == location.PermissionStatus.deniedForever) {
        logger
          ..e('LOCATION')
          ..e('--------------------')
          ..e('Location permission denied forever')
          ..e('--------------------\n');
        return null;
      }

      await locationInstance.changeSettings(accuracy: location.LocationAccuracy.balanced);

      final locationData = await locationInstance.getLocation();

      if (locationData.latitude != null && locationData.longitude != null) {
        logger
          ..v('LOCATION')
          ..v('--------------------')
          ..v('Location fetched')
          ..v('$locationData')
          ..v('--------------------\n');

        return locationData;
      }

      logger
        ..e('LOCATION')
        ..e('--------------------')
        ..e('Location data is null')
        ..e('--------------------\n');
      return null;
    } catch (e) {
      logger
        ..e('LOCATION')
        ..e('--------------------')
        ..e('Location error')
        ..e('$e')
        ..e('--------------------\n');
    }

    return null;
  }
}
