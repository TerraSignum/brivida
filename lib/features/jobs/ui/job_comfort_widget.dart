// PG-16.1: Job Comfort Features for Enhanced Pro-Customer Communication
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/models/app_user.dart';
import '../../../core/models/job.dart';
import '../../../core/utils/debug_logger.dart';
import '../../chat/logic/chat_controller.dart';
import '../../chat/ui/chat_page.dart';
import '../../camera/ui/photo_capture_widget.dart';
import '../logic/job_comfort_controller.dart';

class JobComfortWidget extends ConsumerStatefulWidget {
  final Job job;
  final bool isProView;

  const JobComfortWidget({
    super.key,
    required this.job,
    this.isProView = false,
  });

  @override
  ConsumerState<JobComfortWidget> createState() => _JobComfortWidgetState();
}

class _JobComfortWidgetState extends ConsumerState<JobComfortWidget> {
  bool _showParkingNotes = false;
  bool _showBuildingPhotos = false;
  String? _enteredPin;

  @override
  Widget build(BuildContext context) {
    // Handle null job ID
    if (widget.job.id == null) {
      return const Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Job ID not available'),
        ),
      );
    }

    final comfortState = ref.watch(
      jobComfortControllerProvider(widget.job.id!),
    );

    final AsyncValue<AppUser?> counterpartProfileAsync;
    if (widget.isProView) {
      counterpartProfileAsync = ref.watch(
        chatMemberProfileProvider(widget.job.customerUid),
      );
    } else if (widget.job.assignedProUid != null) {
      counterpartProfileAsync = ref.watch(
        chatMemberProfileProvider(widget.job.assignedProUid!),
      );
    } else {
      counterpartProfileAsync = const AsyncValue<AppUser?>.data(null);
    }

    final callPhoneAsync = counterpartProfileAsync.whenData(
      (profile) => _normalizePhone(profile?.phoneNumber),
    );

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isProView
                  ? 'Job Comfort Features'
                  : 'Job Status & Updates',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // On My Way Button (Pro only)
            if (widget.isProView && _canShowOnMyWayButton()) ...[
              _buildOnMyWaySection(comfortState),
              const SizedBox(height: 16),
            ],

            // Arrival Window Display
            if (comfortState.arrivalWindow != null) ...[
              _buildArrivalWindowDisplay(comfortState.arrivalWindow!),
              const SizedBox(height: 16),
            ],

            // Quick Actions
            _buildQuickActions(callPhoneAsync),
            const SizedBox(height: 16),

            // Parking Notes Section
            if (widget.isProView) ...[
              _buildParkingNotesSection(comfortState),
              const SizedBox(height: 16),
            ],

            // Building Photos Section
            if (widget.isProView) ...[
              _buildBuildingPhotosSection(comfortState),
              const SizedBox(height: 16),
            ],

            // Address Release Toggle (Pro only)
            if (widget.isProView) ...[
              _buildAddressReleaseToggle(comfortState),
              const SizedBox(height: 16),
            ],

            // Arrival PIN Verification
            if (_shouldShowPinVerification(comfortState)) ...[
              _buildPinVerificationSection(comfortState),
              const SizedBox(height: 16),
            ],

            // Quiet Hours Indicator
            if (_isQuietHours()) ...[_buildQuietHoursIndicator()],
          ],
        ),
      ),
    );
  }

  bool _canShowOnMyWayButton() {
    return widget.job.status == JobStatus.assigned &&
        widget.job.id != null &&
        !ref.read(jobComfortControllerProvider(widget.job.id!)).onMyWayPressed;
  }

  Widget _buildOnMyWaySection(JobComfortState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.directions_car, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text(
              'Departure Status',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (!state.onMyWayPressed)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: state.isLoading ? null : () => _onMyWayPressed(),
              icon: const Icon(Icons.near_me),
              label: const Text('I\'m On My Way'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'En route to customer',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (state.onMyWayTime != null)
                  Text(
                    'Since ${_formatTime(state.onMyWayTime!)}',
                    style: TextStyle(
                      color: Colors.green.shade600,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildArrivalWindowDisplay(ArrivalWindow window) {
    final now = DateTime.now();
    final isInWindow =
        now.isAfter(window.earliest) && now.isBefore(window.latest);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isInWindow ? Colors.orange.shade100 : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isInWindow ? Colors.orange.shade300 : Colors.blue.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: isInWindow
                    ? Colors.orange.shade700
                    : Colors.blue.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                'Expected Arrival',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isInWindow
                      ? Colors.orange.shade700
                      : Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${_formatTime(window.earliest)} - ${_formatTime(window.latest)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isInWindow ? Colors.orange.shade800 : Colors.blue.shade800,
            ),
          ),
          if (isInWindow)
            Text(
              'Pro should arrive soon!',
              style: TextStyle(
                color: Colors.orange.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(AsyncValue<String?> phoneAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.quick_contacts_dialer,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            const Text(
              'Quick Actions',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Call Action
            Expanded(child: _buildCallButton(phoneAsync)),
            const SizedBox(width: 8),

            // Chat Action
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _openChat(),
                icon: const Icon(Icons.chat),
                label: const Text('Chat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Navigation Action (Pro only)
            if (widget.isProView)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openNavigation(),
                  icon: const Icon(Icons.navigation),
                  label: const Text('Navigate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCallButton(AsyncValue<String?> phoneAsync) {
    final label = widget.isProView ? 'Call Customer' : 'Call Pro';

    return phoneAsync.when(
      data: (phone) {
        final hasPhone = phone != null && phone.isNotEmpty;
        return ElevatedButton.icon(
          onPressed: hasPhone
              ? () => _makePhoneCall(phone)
              : _showNoPhoneMessage,
          icon: Icon(hasPhone ? Icons.phone : Icons.phone_disabled_outlined),
          label: Text(hasPhone ? label : 'Phone Not Available'),
          style: ElevatedButton.styleFrom(
            backgroundColor: hasPhone ? Colors.green : Colors.grey,
            foregroundColor: Colors.white,
          ),
        );
      },
      loading: () => ElevatedButton.icon(
        onPressed: null,
        icon: const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        label: const Text('Loading...'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade300,
          foregroundColor: Colors.white,
        ),
      ),
      error: (error, stackTrace) {
        DebugLogger.error(
          'COMFORT: Failed to load counterpart phone number',
          error,
          stackTrace,
        );
        return ElevatedButton.icon(
          onPressed: _showCallUnavailableMessage,
          icon: const Icon(Icons.phone_disabled_outlined),
          label: const Text('Call Unavailable'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildParkingNotesSection(JobComfortState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.local_parking, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text(
              'Parking Information',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            IconButton(
              onPressed: () =>
                  setState(() => _showParkingNotes = !_showParkingNotes),
              icon: Icon(
                _showParkingNotes ? Icons.expand_less : Icons.expand_more,
              ),
            ),
          ],
        ),
        if (_showParkingNotes) ...[
          const SizedBox(height: 8),
          TextFormField(
            initialValue: state.parkingNotes,
            decoration: const InputDecoration(
              hintText: 'Add parking instructions for the customer...',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
            maxLines: 3,
            onChanged: (value) => _updateParkingNotes(value),
          ),
          const SizedBox(height: 8),
          Text(
            'Share parking details like "Blue Honda in visitor spot #3" or "Street parking on Main St"',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ],
    );
  }

  Widget _buildBuildingPhotosSection(JobComfortState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text(
              'Building Photos',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            IconButton(
              onPressed: () =>
                  setState(() => _showBuildingPhotos = !_showBuildingPhotos),
              icon: Icon(
                _showBuildingPhotos ? Icons.expand_less : Icons.expand_more,
              ),
            ),
          ],
        ),
        if (_showBuildingPhotos) ...[
          const SizedBox(height: 8),
          if (state.buildingPhotos.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(Icons.add_a_photo, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  const Text('No photos yet'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _captureBuildigPhoto(),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                  ),
                ],
              ),
            )
          else ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: state.buildingPhotos.length + 1,
              itemBuilder: (context, index) {
                if (index == state.buildingPhotos.length) {
                  return GestureDetector(
                    onTap: () => _captureBuildigPhoto(),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_a_photo, color: Colors.grey),
                    ),
                  );
                }

                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    state.buildingPhotos[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Photos help customers find your location easier',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildAddressReleaseToggle(JobComfortState state) {
    return Row(
      children: [
        Icon(Icons.location_on, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Share exact address with customer',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Switch(
          value: state.exactAddressShared,
          onChanged: (value) => _toggleAddressSharing(value),
        ),
      ],
    );
  }

  Widget _buildPinVerificationSection(JobComfortState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pin, color: Colors.purple.shade700),
              const SizedBox(width: 8),
              Text(
                'Arrival Verification',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (widget.isProView) ...[
            const Text('Show this PIN to the customer upon arrival:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.shade300),
              ),
              child: Text(
                state.arrivalPin ?? 'Generating...',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ] else ...[
            const Text('Ask the pro for the 4-digit arrival PIN:'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter 4-digit PIN',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              onChanged: (value) => setState(() => _enteredPin = value),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _enteredPin?.length == 4
                    ? () => _verifyArrivalPin()
                    : null,
                child: const Text('Verify Arrival'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuietHoursIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.indigo.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.nightlight_round, color: Colors.indigo.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Quiet hours active - Please minimize noise',
              style: TextStyle(
                color: Colors.indigo.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  bool _shouldShowPinVerification(JobComfortState state) {
    return widget.job.status == JobStatus.assigned && state.arrivalPin != null;
  }

  bool _isQuietHours() {
    final hour = DateTime.now().hour;
    return hour >= 22 || hour <= 7; // 10 PM to 7 AM
  }

  // Action handlers
  void _onMyWayPressed() {
    if (widget.job.id != null) {
      ref
          .read(jobComfortControllerProvider(widget.job.id!).notifier)
          .setOnMyWay();
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final sanitized = phoneNumber.replaceAll(RegExp(r'[\s()-]'), '');
    final uri = Uri(scheme: 'tel', path: sanitized);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to start phone call')),
        );
      }
    } catch (error, stackTrace) {
      DebugLogger.error(
        'COMFORT: Failed to launch phone call',
        error,
        stackTrace,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to start phone call')),
        );
      }
    }
  }

  void _showNoPhoneMessage() {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Phone number not available')));
  }

  void _showCallUnavailableMessage() {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Phone call unavailable')));
  }

  void _openChat() {
    if (widget.job.id != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ChatPage(chatId: widget.job.id!), // Use chatId for job-based chat
        ),
      );
    }
  }

  void _openNavigation() async {
    // Use addressCity or addressHint for navigation since serviceAddress doesn't exist
    String? address = widget.job.addressCity;
    if (address == null && widget.job.addressHint != null) {
      address = widget.job.addressHint;
    }

    if (address != null) {
      final encodedAddress = Uri.encodeComponent(address);
      final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encodedAddress',
      );

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address not available for navigation')),
        );
      }
    }
  }

  void _updateParkingNotes(String notes) {
    if (widget.job.id != null) {
      ref
          .read(jobComfortControllerProvider(widget.job.id!).notifier)
          .updateParkingNotes(notes);
    }
  }

  void _captureBuildigPhoto() async {
    final status = await Permission.camera.request();
    if (status.isGranted && widget.job.id != null && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoCaptureWidget(
            onPhotoTaken: (String photoUrl) {
              ref
                  .read(jobComfortControllerProvider(widget.job.id!).notifier)
                  .addBuildingPhoto(photoUrl);
            },
          ),
        ),
      );
    }
  }

  void _toggleAddressSharing(bool value) {
    if (widget.job.id != null) {
      ref
          .read(jobComfortControllerProvider(widget.job.id!).notifier)
          .toggleAddressSharing(value);
    }
  }

  void _verifyArrivalPin() {
    if (_enteredPin != null && widget.job.id != null) {
      ref
          .read(jobComfortControllerProvider(widget.job.id!).notifier)
          .verifyArrivalPin(_enteredPin!);
    }
  }

  String? _normalizePhone(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}

// Data models for comfort features
class ArrivalWindow {
  final DateTime earliest;
  final DateTime latest;

  const ArrivalWindow({required this.earliest, required this.latest});
}

class JobComfortState {
  final bool isLoading;
  final bool onMyWayPressed;
  final DateTime? onMyWayTime;
  final ArrivalWindow? arrivalWindow;
  final String parkingNotes;
  final List<String> buildingPhotos;
  final bool exactAddressShared;
  final String? arrivalPin;
  final bool pinVerified;

  const JobComfortState({
    this.isLoading = false,
    this.onMyWayPressed = false,
    this.onMyWayTime,
    this.arrivalWindow,
    this.parkingNotes = '',
    this.buildingPhotos = const [],
    this.exactAddressShared = false,
    this.arrivalPin,
    this.pinVerified = false,
  });

  JobComfortState copyWith({
    bool? isLoading,
    bool? onMyWayPressed,
    DateTime? onMyWayTime,
    ArrivalWindow? arrivalWindow,
    String? parkingNotes,
    List<String>? buildingPhotos,
    bool? exactAddressShared,
    String? arrivalPin,
    bool? pinVerified,
  }) {
    return JobComfortState(
      isLoading: isLoading ?? this.isLoading,
      onMyWayPressed: onMyWayPressed ?? this.onMyWayPressed,
      onMyWayTime: onMyWayTime ?? this.onMyWayTime,
      arrivalWindow: arrivalWindow ?? this.arrivalWindow,
      parkingNotes: parkingNotes ?? this.parkingNotes,
      buildingPhotos: buildingPhotos ?? this.buildingPhotos,
      exactAddressShared: exactAddressShared ?? this.exactAddressShared,
      arrivalPin: arrivalPin ?? this.arrivalPin,
      pinVerified: pinVerified ?? this.pinVerified,
    );
  }
}
