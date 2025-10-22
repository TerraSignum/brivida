// PG-16: Customer Live Map Widget - shows real-time pro location
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/job.dart';
import '../../../core/models/live_location.dart';
import '../logic/live_share_controller.dart';
import '../../jobs/data/jobs_repo.dart';
import '../../jobs/logic/jobs_controller.dart';

class CustomerLiveMapWidget extends ConsumerStatefulWidget {
  final Job job;

  const CustomerLiveMapWidget({super.key, required this.job});

  @override
  ConsumerState<CustomerLiveMapWidget> createState() =>
      _CustomerLiveMapWidgetState();
}

class _CustomerLiveMapWidgetState extends ConsumerState<CustomerLiveMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Only show for customers viewing their own jobs with assigned pros
    if (user == null ||
        widget.job.customerUid != user.uid ||
        widget.job.assignedProUid == null ||
        widget.job.id == null) {
      return const SizedBox.shrink();
    }

    // Watch live location stream for the assigned pro
    final liveLocationAsync = ref.watch(
      liveLocationStreamProvider((widget.job.id!, widget.job.assignedProUid!)),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Live Professional Location',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Live location map
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: liveLocationAsync.when(
                  data: (liveLocation) => _buildMap(liveLocation),
                  loading: () => _buildLoadingMap(),
                  error: (error, stack) => _buildErrorMap(error.toString()),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Live location status
            liveLocationAsync.when(
              data: (liveLocation) => _buildLocationStatus(liveLocation),
              loading: () => _buildLoadingStatus(),
              error: (error, stack) => _buildErrorStatus(),
            ),

            const SizedBox(height: 12),

            // ETA calculation button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: liveLocationAsync.value != null
                        ? () => _calculateLiveEta(liveLocationAsync.value!)
                        : null,
                    icon: const Icon(Icons.schedule),
                    label: const Text('ETA Now'),
                  ),
                ),
              ],
            ),

            // Privacy note
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 14, color: Colors.blue),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Location updates automatically when the professional shares their position.',
                      style: TextStyle(fontSize: 11, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(LiveLocation? liveLocation) {
    // Get job location for reference
    final jobPrivateAsync = ref.watch(jobPrivateProvider(widget.job.id!));

    return jobPrivateAsync.when(
      data: (jobPrivate) {
        if (jobPrivate == null) {
          return _buildErrorMap('Job location not available');
        }

        final jobLatLng = LatLng(
          jobPrivate.location.lat,
          jobPrivate.location.lng,
        );

        // Update markers
        _markers = {
          // Job location marker
          Marker(
            markerId: const MarkerId('job_location'),
            position: jobLatLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: InfoWindow(
              title: 'Job Location',
              snippet: jobPrivate.addressFormatted,
            ),
          ),
        };

        // Add pro location marker if available
        if (liveLocation != null && liveLocation.isRecentLocation) {
          final proLatLng = LatLng(liveLocation.lat, liveLocation.lng);
          _markers.add(
            Marker(
              markerId: const MarkerId('pro_location'),
              position: proLatLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
              infoWindow: InfoWindow(
                title: 'Professional',
                snippet: 'Updated ${liveLocation.lastUpdatedText}',
              ),
            ),
          );
        }

        // Determine camera position - if pro location is available, center between both
        CameraPosition cameraPosition;
        if (liveLocation != null && liveLocation.isRecentLocation) {
          // Calculate bounds to show both markers
          final boundsCenter = _calculateBounds([
            jobLatLng,
            LatLng(liveLocation.lat, liveLocation.lng),
          ]);
          cameraPosition = CameraPosition(target: boundsCenter, zoom: 14);
        } else {
          // Just show job location
          cameraPosition = CameraPosition(target: jobLatLng, zoom: 16);
        }

        return GoogleMap(
          initialCameraPosition: cameraPosition,
          markers: _markers,
          myLocationEnabled: false, // Don't show customer location for privacy
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          mapToolbarEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;

            // Auto-adjust bounds if we have both markers
            if (liveLocation != null && liveLocation.isRecentLocation) {
              _fitBounds([
                jobLatLng,
                LatLng(liveLocation.lat, liveLocation.lng),
              ]);
            }
          },
        );
      },
      loading: () => _buildLoadingMap(),
      error: (error, stack) => _buildErrorMap('Failed to load job location'),
    );
  }

  Widget _buildLoadingMap() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text('Loading map...'),
        ],
      ),
    );
  }

  Widget _buildErrorMap(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 32),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStatus(LiveLocation? liveLocation) {
    if (liveLocation == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.location_off, size: 16, color: Colors.grey),
            SizedBox(width: 8),
            Text('Professional not sharing location'),
          ],
        ),
      );
    }

    final isRecent = liveLocation.isRecentLocation;
    final color = isRecent ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isRecent ? Icons.location_on : Icons.location_off,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                isRecent ? 'Live location active' : 'Location outdated',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Last update: ${liveLocation.lastUpdatedText}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (liveLocation.accuracy != null) ...[
            const SizedBox(height: 2),
            Text(
              liveLocation.accuracyText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: liveLocation.hasAccurateReading
                    ? Colors.green[600]
                    : Colors.orange[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingStatus() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Checking location status...'),
        ],
      ),
    );
  }

  Widget _buildErrorStatus() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, size: 16, color: Colors.red),
          const SizedBox(width: 8),
          Text(
            'Failed to load location status',
            style: TextStyle(color: Colors.red[700]),
          ),
        ],
      ),
    );
  }

  void _calculateLiveEta(LiveLocation proLocation) async {
    try {
      final repo = ref.read(jobsRepoProvider);

      // Calculate ETA using the pro's current position
      final eta = await repo.getEtaFromCoordinates(
        widget.job.id!,
        proLocation.lat,
        proLocation.lng,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ETA: ${eta['duration']} (${eta['distance']})'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to calculate ETA: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Helper to calculate bounds for multiple points
  LatLng _calculateBounds(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(0, 0);
    if (points.length == 1) return points.first;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLng = minLng < point.longitude ? minLng : point.longitude;
      maxLng = maxLng > point.longitude ? maxLng : point.longitude;
    }

    return LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);
  }

  // Helper to fit map bounds
  void _fitBounds(List<LatLng> points) {
    if (_mapController == null || points.length < 2) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLng = minLng < point.longitude ? minLng : point.longitude;
      maxLng = maxLng > point.longitude ? maxLng : point.longitude;
    }

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        100.0, // padding
      ),
    );
  }
}
