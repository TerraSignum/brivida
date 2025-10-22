// PG-16: Live Share Controller for managing real-time location sharing
import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

import '../../../core/models/live_location.dart';
import '../data/live_repo.dart';

// State for live location sharing
class LiveShareState {
  final bool isSharing;
  final bool hasPermission;
  final LiveLocation? lastLocation;
  final String? error;
  final DateTime? lastUpdate;

  const LiveShareState({
    this.isSharing = false,
    this.hasPermission = false,
    this.lastLocation,
    this.error,
    this.lastUpdate,
  });

  LiveShareState copyWith({
    bool? isSharing,
    bool? hasPermission,
    LiveLocation? lastLocation,
    String? error,
    DateTime? lastUpdate,
  }) {
    return LiveShareState(
      isSharing: isSharing ?? this.isSharing,
      hasPermission: hasPermission ?? this.hasPermission,
      lastLocation: lastLocation ?? this.lastLocation,
      error: error,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

// Live Share Controller
class LiveShareController extends StateNotifier<LiveShareState> {
  final LiveLocationRepository _liveRepo;
  final Location _location;

  StreamSubscription<LocationData>? _locationSubscription;
  String? _currentJobId;
  Timer? _timeoutTimer;
  bool _backgroundModeEnabled = false;

  LiveShareController(this._liveRepo)
    : _location = Location(),
      super(const LiveShareState());

  /// Start sharing live location for a job
  Future<void> startSharing(String jobId) async {
    developer.log(
      'Starting live location sharing for job: $jobId',
      name: 'LiveShareController',
    );

    try {
      // Check permissions first
      if (!await _checkAndRequestPermissions()) {
        state = state.copyWith(
          error: 'Location permissions are required for live sharing',
          hasPermission: false,
        );
        return;
      }

      // Stop any existing sharing
      await stopSharing();

      // Configure location service
      await _configureLocationService();

      // Start location subscription
      _currentJobId = jobId;
      await _startLocationUpdates(jobId);

      // Push an initial reading immediately if possible
      try {
        final initialLocation = await _location.getLocation();
        await _handleLocationUpdate(jobId, initialLocation);
      } catch (e) {
        developer.log(
          'Unable to obtain initial location: $e',
          name: 'LiveShareController',
        );
      }

      // Mark as sharing
      await _liveRepo.startSharing(jobId);

      if (!mounted) return;

      state = state.copyWith(isSharing: true, hasPermission: true, error: null);

      // Auto-stop after 4 hours as safety measure
      _timeoutTimer = Timer(const Duration(hours: 4), () {
        developer.log(
          'Auto-stopping location sharing after 4 hours',
          name: 'LiveShareController',
        );
        stopSharing();
      });

      developer.log(
        'Live location sharing started successfully for job: $jobId',
        name: 'LiveShareController',
      );
    } catch (e) {
      developer.log(
        'Error starting live location sharing: $e',
        name: 'LiveShareController',
      );
      if (!mounted) return;

      state = state.copyWith(
        error: 'Failed to start location sharing: ${e.toString()}',
        isSharing: false,
      );
    }
  }

  /// Stop sharing live location
  Future<void> stopSharing() async {
    developer.log(
      'Stopping live location sharing',
      name: 'LiveShareController',
    );

    try {
      // Cancel location updates
      await _locationSubscription?.cancel();
      _locationSubscription = null;

      // Cancel timeout timer
      _timeoutTimer?.cancel();
      _timeoutTimer = null;

      // Disable background updates to save battery
      if (_backgroundModeEnabled) {
        try {
          final disabled = await _location.enableBackgroundMode(enable: false);
          if (disabled) {
            _backgroundModeEnabled = false;
          }
        } catch (e) {
          developer.log(
            'Error disabling background mode: $e',
            name: 'LiveShareController',
          );
        }
      }

      // Stop sharing in repository
      if (_currentJobId != null) {
        await _liveRepo.stopSharing(_currentJobId!);
        _currentJobId = null;
      }

      if (!mounted) return;

      state = state.copyWith(isSharing: false, error: null);

      developer.log(
        'Live location sharing stopped',
        name: 'LiveShareController',
      );
    } catch (e) {
      developer.log(
        'Error stopping live location sharing: $e',
        name: 'LiveShareController',
      );
      if (!mounted) return;

      state = state.copyWith(
        error: 'Failed to stop location sharing: ${e.toString()}',
      );
    }
  }

  /// Check and request necessary permissions
  Future<bool> _checkAndRequestPermissions() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          return false;
        }
      }

      // Check location permission
      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return false;
        }
      }

      // For background updates, we also need to check background permission
      final backgroundPermission = await perm.Permission.locationAlways.status;
      if (backgroundPermission.isDenied) {
        final result = await perm.Permission.locationAlways.request();
        if (!result.isGranted) {
          developer.log(
            'Background location permission denied - sharing will stop when app is backgrounded',
            name: 'LiveShareController',
          );
        }
      }

      return true;
    } catch (e) {
      developer.log(
        'Error checking permissions: $e',
        name: 'LiveShareController',
      );
      return false;
    }
  }

  /// Configure location service settings
  Future<void> _configureLocationService() async {
    try {
      await _location.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 10000, // 10 seconds
        distanceFilter: 10, // 10 meters
      );

      // Enable background mode for continuous updates
      final enabled = await _location.enableBackgroundMode(enable: true);
      _backgroundModeEnabled = enabled;
    } catch (e) {
      developer.log(
        'Error configuring location service: $e',
        name: 'LiveShareController',
      );
      rethrow;
    }
  }

  /// Start listening to location updates
  Future<void> _startLocationUpdates(String jobId) async {
    try {
      _locationSubscription = _location.onLocationChanged.listen(
        (LocationData locationData) {
          unawaited(_handleLocationUpdate(jobId, locationData));
        },
        onError: (error) {
          developer.log(
            'Location stream error: $error',
            name: 'LiveShareController',
          );
          if (!mounted) {
            return;
          }
          state = state.copyWith(
            error: 'Location update failed: ${error.toString()}',
          );
        },
      );
    } catch (e) {
      developer.log(
        'Error starting location updates: $e',
        name: 'LiveShareController',
      );
      rethrow;
    }
  }

  /// Handle incoming location updates
  Future<void> _handleLocationUpdate(
    String jobId,
    LocationData locationData,
  ) async {
    if (locationData.latitude == null || locationData.longitude == null) {
      developer.log(
        'Received invalid location data',
        name: 'LiveShareController',
      );
      return;
    }

    try {
      final liveLocation = LiveLocation(
        lat: locationData.latitude!,
        lng: locationData.longitude!,
        updatedAt: DateTime.now(),
        accuracy: locationData.accuracy,
        heading: locationData.heading,
      );

      // Update in repository (with rate limiting)
      await _liveRepo.updateLocation(jobId, liveLocation);

      // Update local state
      if (!mounted) return;

      state = state.copyWith(
        lastLocation: liveLocation,
        lastUpdate: liveLocation.updatedAt,
        error: null,
      );

      developer.log(
        'Location updated: ${liveLocation.lat}, ${liveLocation.lng} (accuracy: ${liveLocation.accuracy}m)',
        name: 'LiveShareController',
      );
    } catch (e) {
      developer.log(
        'Error handling location update: $e',
        name: 'LiveShareController',
      );
      if (!mounted) return;

      state = state.copyWith(
        error: 'Failed to update location: ${e.toString()}',
      );
    }
  }

  /// Pause sharing temporarily (but don't stop completely)
  Future<void> pauseSharing() async {
    try {
      _locationSubscription?.pause();
      if (_backgroundModeEnabled) {
        final disabled = await _location.enableBackgroundMode(enable: false);
        if (disabled) {
          _backgroundModeEnabled = false;
        }
      }
      developer.log('Location sharing paused', name: 'LiveShareController');
    } catch (e) {
      developer.log(
        'Error pausing location sharing: $e',
        name: 'LiveShareController',
      );
    }
  }

  /// Resume sharing after pause
  Future<void> resumeSharing() async {
    try {
      _locationSubscription?.resume();
      if (!_backgroundModeEnabled) {
        final enabled = await _location.enableBackgroundMode(enable: true);
        _backgroundModeEnabled = enabled;
      }
      developer.log('Location sharing resumed', name: 'LiveShareController');
    } catch (e) {
      developer.log(
        'Error resuming location sharing: $e',
        name: 'LiveShareController',
      );
    }
  }

  /// Get current sharing status
  bool get isCurrentlySharing => state.isSharing && _currentJobId != null;

  /// Get current job ID being shared
  String? get currentJobId => _currentJobId;

  @override
  void dispose() {
    unawaited(stopSharing());
    super.dispose();
  }
}

// Provider for LiveShareController
final liveShareControllerProvider =
    StateNotifierProvider.family<LiveShareController, LiveShareState, String>((
      ref,
      jobId,
    ) {
      final liveRepo = ref.read(liveRepositoryProvider);
      return LiveShareController(liveRepo);
    });

// Provider for LiveLocationRepository
final liveRepositoryProvider = Provider<LiveLocationRepository>((ref) {
  return LiveLocationRepository();
});

// Provider to check if sharing is active for a specific job
final isSharingProvider = Provider.family<bool, String>((ref, jobId) {
  final controller = ref.watch(liveShareControllerProvider(jobId));
  return controller.isSharing;
});

// Provider to get last location for a specific job
final lastLocationProvider = Provider.family<LiveLocation?, String>((
  ref,
  jobId,
) {
  final controller = ref.watch(liveShareControllerProvider(jobId));
  return controller.lastLocation;
});

// Provider to stream live location for viewing (customer side)
final liveLocationStreamProvider =
    StreamProvider.family<LiveLocation?, (String, String)>((ref, params) {
      final (jobId, proUid) = params;
      final liveRepo = ref.read(liveRepositoryProvider);
      return liveRepo.streamProLocation(jobId, proUid);
    });

// Provider to stream all pro locations for a job
final allProLocationsStreamProvider =
    StreamProvider.family<Map<String, LiveLocation>, String>((ref, jobId) {
      final liveRepo = ref.read(liveRepositoryProvider);
      return liveRepo.streamAllPros(jobId);
    });
