import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../core/models/job.dart';
import '../../../core/utils/debug_logger.dart';
import '../../../core/utils/navigation_helpers.dart';
import '../../../core/services/geocoding_service.dart';
import '../logic/job_quote_service.dart';
import '../logic/jobs_controller.dart';
import '../../tutorial/logic/tutorial_registry.dart';
import '../../tutorial/ui/tutorial_trigger.dart';

class JobFormPage extends ConsumerStatefulWidget {
  const JobFormPage({super.key});

  @override
  ConsumerState<JobFormPage> createState() => _JobFormPageState();
}

class _JobFormPageState extends ConsumerState<JobFormPage> {
  static const List<String> _extraOrder = [
    'windows_inside',
    'windows_in_out',
    'kitchen_deep',
    'bathroom_deep',
    'laundry',
    'ironing_light',
    'ironing_full',
    'balcony',
    'organization',
  ];

  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _hintController = TextEditingController();
  final _entranceNotesController = TextEditingController();
  final _notesController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _selectedLatLng;
  String? _selectedAddressLabel;
  bool _isUpdatingAddressText = false;

  JobCategory _selectedCategory = JobCategory.m;
  final Set<String> _selectedExtras = <String>{};
  bool _materialProvidedByPro = false;
  bool _isExpress = false;
  JobQuote? _quote;
  DateTime? _startDate;
  TimeOfDay? _startTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quote = _calculateQuote();
    _addressController.addListener(_onAddressChanged);
  }

  @override
  void dispose() {
    _addressController.removeListener(_onAddressChanged);
    _mapController?.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _hintController.dispose();
    _entranceNotesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  JobQuote _calculateQuote() {
    final service = ref.read(jobQuoteServiceProvider);
    return service.quote(
      JobQuoteInput(
        category: _selectedCategory,
        selectedExtras: _selectedExtras,
        materialProvidedByPro: _materialProvidedByPro,
        isExpress: _isExpress,
      ),
    );
  }

  DateTime? get _startDateTime {
    final date = _startDate;
    final time = _startTime;
    if (date == null || time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  DateTime? get _endDateTime {
    final start = _startDateTime;
    final quote = _quote;
    if (start == null || quote == null) return null;
    return quote.calculateEnd(start);
  }

  Duration? get _duration {
    final quote = _quote;
    if (quote == null) return null;
    return Duration(minutes: quote.totalMinutes.round());
  }

  bool get _hasSchedule => _startDate != null && _startTime != null;

  String _localizedDuration(AppLocalizations l, Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (minutes == 0) {
      return l.jobFormDurationHours(hours);
    }

    return l.jobFormDurationHoursMinutes(hours, minutes);
  }

  String _formatCurrency(BuildContext context, double amount) {
    final locale = Localizations.localeOf(context);
    final formatter = NumberFormat.currency(
      locale: locale.toLanguageTag(),
      symbol: '€',
    );
    return formatter.format(amount);
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context);
    return DateFormat.yMMMMEEEEd(locale.toLanguageTag()).format(date);
  }

  String _formatTime(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context);
    return DateFormat.Hm(locale.toLanguageTag()).format(date);
  }

  void _onCategorySelected(JobCategory category) {
    if (_selectedCategory == category) return;
    setState(() {
      _selectedCategory = category;
      _quote = _calculateQuote();
    });
  }

  void _toggleExtra(String id) {
    setState(() {
      if (_selectedExtras.contains(id)) {
        _selectedExtras.remove(id);
      } else {
        _selectedExtras.add(id);
      }
      _quote = _calculateQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      final l = AppLocalizations.of(context);
      final quote = _quote;
      final start = _startDateTime;
      final end = _endDateTime;
      final duration = _duration;
      final mediaQuery = MediaQuery.of(context);
      final bottomPadding = mediaQuery.viewPadding.bottom;

      final scaffold = Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => popOrGoHome(context, homeRoute: '/jobs'),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(l.jobNewTitle),
        ),
        body: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16, 16, 16, 32 + bottomPadding),
              children: [
                _buildAddressSection(l),
                const SizedBox(height: 24),
                _buildCategorySection(l),
                const SizedBox(height: 24),
                _buildExtrasSection(l),
                const SizedBox(height: 24),
                _buildOptionsSection(l),
                const SizedBox(height: 24),
                _buildScheduleSection(l),
                const SizedBox(height: 24),
                _buildSummarySection(l, quote, start, end, duration),
                const SizedBox(height: 24),
                _buildNotesSection(l),
                const SizedBox(height: 32),
                _buildSubmitButton(l),
              ],
            ),
          ),
        ),
      );

      return TutorialTrigger(screen: TutorialScreen.jobForm, child: scaffold);
    } catch (e, stackTrace) {
      DebugLogger.error(
        '📝 JOB_FORM: Error building JobFormPage',
        e,
        stackTrace,
      );
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => popOrGoHome(context, homeRoute: '/jobs'),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Job Form Error'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'JobFormPage Build Error',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Error: $e',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildCategorySection(AppLocalizations l) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.jobFormCategoryTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: JobCategory.values.map((category) {
                final isSelected = category == _selectedCategory;
                return ChoiceChip(
                  label: Text(_categoryLabel(l, category)),
                  selected: isSelected,
                  onSelected: (_) => _onCategorySelected(category),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtrasSection(AppLocalizations l) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.jobFormExtrasTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(l.jobFormExtrasSubtitle, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _extraOrder.map((id) {
                final config = JobQuoteService.extraConfigs[id];
                if (config == null) return const SizedBox.shrink();

                final selected = _selectedExtras.contains(id);
                return FilterChip(
                  label: Text(_extraLabel(l, id)),
                  selected: selected,
                  onSelected: (_) => _toggleExtra(id),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsSection(AppLocalizations l) {
    final theme = Theme.of(context);

    return Card(
      child: Column(
        children: [
          SwitchListTile.adaptive(
            title: Text(l.jobFormOptionMaterialsProvided),
            subtitle: Text(l.jobFormOptionMaterialsProvidedSubtitle),
            value: _materialProvidedByPro,
            onChanged: (value) {
              setState(() {
                _materialProvidedByPro = value;
                _quote = _calculateQuote();
              });
            },
            secondary: Icon(
              _materialProvidedByPro
                  ? Icons.inventory_2
                  : Icons.home_repair_service,
              color: theme.colorScheme.primary,
            ),
          ),
          const Divider(height: 0),
          SwitchListTile.adaptive(
            title: Text(l.jobFormOptionExpress),
            subtitle: Text(l.jobFormOptionExpressSubtitle),
            value: _isExpress,
            onChanged: (value) {
              setState(() {
                _isExpress = value;
                _quote = _calculateQuote();
              });
            },
            secondary: Icon(
              Icons.flash_on,
              color: _isExpress
                  ? theme.colorScheme.primary
                  : theme.iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection(AppLocalizations l) {
    final theme = Theme.of(context);
    final startDateText = _startDate != null
        ? _formatDate(context, _startDate!)
        : l.jobFormSelectDate;
    final startTimeText = _startTime != null
        ? _startTime!.format(context)
        : l.jobFormSelectTime;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.jobFormSchedule, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(l.jobFormStartDate),
              subtitle: Text(startDateText),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(l.jobFormStartTime),
              subtitle: Text(startTimeText),
              onTap: () => _selectTime(context),
            ),
            if (!_hasSchedule)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l.jobFormScheduleRequired,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(
    AppLocalizations l,
    JobQuote? quote,
    DateTime? start,
    DateTime? end,
    Duration? duration,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.jobFormSummaryTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.hourglass_bottom),
              title: Text(l.jobFormSummaryDuration),
              subtitle: duration != null
                  ? Text(_localizedDuration(l, duration))
                  : Text(l.jobFormSummaryPending),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule),
              title: Text(l.jobFormSummaryEnd),
              subtitle: end != null
                  ? Text(_formatTime(context, end))
                  : Text(l.jobFormSummaryPending),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.euro),
              title: Text(l.jobFormSummaryPrice),
              subtitle: quote != null
                  ? Text(_formatCurrency(context, quote.totalCost))
                  : Text(l.jobFormSummaryPending),
            ),
            const SizedBox(height: 8),
            Text(
              l.jobFormSummaryDisclaimer,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(AppLocalizations l) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.jobFormNotes, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(labelText: l.jobFormNotesHint),
              maxLines: 4,
              maxLength: 500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(AppLocalizations l) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitJob,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(l.jobFormSubmit),
      ),
    );
  }

  Widget _buildAddressSection(AppLocalizations l) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(l.jobFormAddress, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: l.jobFormAddress,
                hintText: 'Rua Example 123, Funchal, Madeira',
                prefixIcon: const Icon(Icons.home),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: l.jobFormCity,
                      hintText: 'Funchal',
                      prefixIcon: const Icon(Icons.location_city),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l.jobFormCityRequired;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _districtController,
                    decoration: InputDecoration(
                      labelText: l.jobFormDistrict,
                      hintText: 'São Martinho',
                      prefixIcon: const Icon(Icons.map),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hintController,
              decoration: InputDecoration(
                labelText: l.jobFormHint,
                hintText: l.jobFormHintExample,
                prefixIcon: const Icon(Icons.info_outline),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _entranceNotesController,
              decoration: InputDecoration(
                labelText: l.jobFormDoorcode,
                hintText: l.jobFormDoorcodeExample,
                prefixIcon: const Icon(Icons.vpn_key),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildLocationPreview(l, theme),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Widget _buildLocationPreview(AppLocalizations l, ThemeData theme) {
    final hasLocation = _selectedLatLng != null;
    final displayLabel = hasLocation
        ? (_selectedAddressLabel ?? _addressController.text.trim())
        : l.jobFormLocationPlaceholder;
    final helperText = hasLocation
        ? l.jobFormLocationCoordinates(
            lat: _selectedLatLng!.latitude.toStringAsFixed(4),
            lng: _selectedLatLng!.longitude.toStringAsFixed(4),
          )
        : l.jobFormLocationHelper;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.jobFormLocationTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.place_outlined),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        displayLabel,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(helperText, style: theme.textTheme.bodySmall),
                if (hasLocation) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 200,
                      child: GoogleMap(
                        key: ValueKey(
                          '${_selectedLatLng!.latitude}_${_selectedLatLng!.longitude}',
                        ),
                        initialCameraPosition: CameraPosition(
                          target: _selectedLatLng!,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('job_location'),
                            position: _selectedLatLng!,
                            infoWindow: InfoWindow(title: displayLabel),
                          ),
                        },
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        tiltGesturesEnabled: false,
                        onMapCreated: (controller) {
                          _mapController = controller;
                          _updateMapCamera();
                        },
                        gestureRecognizers:
                            <Factory<OneSequenceGestureRecognizer>>{
                              Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer(),
                              ),
                            },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.jobFormLocationMapCaption,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _isLoading ? null : () => _selectLocation(l),
                    icon: const Icon(Icons.search),
                    label: Text(
                      hasLocation
                          ? l.jobFormLocationChange
                          : l.jobFormLocationSelect,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasLocation && _selectedAddressLabel != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l.jobFormLocationSelected(address: _selectedAddressLabel!),
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  Future<void> _selectLocation(AppLocalizations l) async {
    final result = await showDialog<GeocodingResult>(
      context: context,
      builder: (dialogContext) {
        final textController = TextEditingController(
          text: _selectedAddressLabel ?? _addressController.text.trim(),
        );
        String? errorText;
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> search() async {
              final query = textController.text.trim();
              if (query.isEmpty) {
                setState(() {
                  errorText = l.jobFormLocationAddressRequired;
                });
                return;
              }

              FocusScope.of(context).unfocus();

              final navigator = Navigator.of(dialogContext);

              setState(() {
                isLoading = true;
                errorText = null;
              });

              final geocodeResult = await GeocodingService.geocodeAddress(
                query,
              );

              if (!context.mounted) {
                return;
              }

              if (geocodeResult != null) {
                if (navigator.canPop()) {
                  navigator.pop(geocodeResult);
                }
              } else {
                setState(() {
                  isLoading = false;
                  errorText = l.jobFormLocationNoResults;
                });
              }
            }

            return AlertDialog(
              title: Text(l.jobFormLocationDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      labelText: l.jobFormLocationDialogAddressLabel,
                      hintText: l.jobFormLocationDialogAddressHint,
                      errorText: errorText,
                    ),
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => search(),
                  ),
                  const SizedBox(height: 12),
                  if (isLoading) ...[
                    const LinearProgressIndicator(),
                    const SizedBox(height: 8),
                    Text(
                      l.jobFormLocationDialogSearching,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: Text(l.commonCancel),
                ),
                FilledButton.icon(
                  onPressed: isLoading ? null : search,
                  icon: const Icon(Icons.search),
                  label: Text(l.jobFormLocationDialogSearch),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && mounted) {
      setState(() {
        _selectedLatLng = LatLng(result.lat, result.lng);
        _selectedAddressLabel = result.address;
        _isUpdatingAddressText = true;
        _addressController.text = result.address;
        _isUpdatingAddressText = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateMapCamera());
    }
  }

  void _updateMapCamera() {
    final controller = _mapController;
    final target = _selectedLatLng;
    if (controller == null || target == null) {
      return;
    }

    controller.animateCamera(CameraUpdate.newLatLngZoom(target, 15));
  }

  void _onAddressChanged() {
    if (_isUpdatingAddressText) {
      return;
    }

    if (_selectedLatLng != null || _selectedAddressLabel != null) {
      setState(() {
        _selectedLatLng = null;
        _selectedAddressLabel = null;
      });
    }
  }

  Future<void> _submitJob() async {
    final l = AppLocalizations.of(context);

    DebugLogger.enter('JobFormPage._submitJob');
    DebugLogger.userAction('job_form_submit_attempted', {
      'category': _selectedCategory.name,
      'extrasCount': _selectedExtras.length,
      'materialProvidedByPro': _materialProvidedByPro,
      'isExpress': _isExpress,
      'hasStartDate': _startDate != null,
      'hasStartTime': _startTime != null,
    });

    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      DebugLogger.warning('⚠️ Form validation failed');
      DebugLogger.userAction('job_form_validation_failed');
      return;
    }

    if (!_hasSchedule) {
      DebugLogger.warning('⚠️ Schedule information missing');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.jobFormScheduleRequired)));
      return;
    }

    final startDateTime = _startDateTime;
    final quote = _quote;

    if (startDateTime == null || quote == null) {
      DebugLogger.error('❌ Missing quote or start date when submitting job');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.jobFormSummaryPending)));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final combinedNotes = _composeNotes(l);
      final addressText = _addressController.text.trim();
      final entranceNotes = _entranceNotesController.text.trim();

      DebugLogger.debug('📝 Job data prepared for submission', {
        'category': _selectedCategory.name,
        'extras': _selectedExtras.toList(),
        'materialProvidedByPro': _materialProvidedByPro,
        'isExpress': _isExpress,
        'start': startDateTime.toIso8601String(),
        'calculatedHours': quote.totalHours,
        'calculatedBudget': quote.totalCost,
        'hasAddressText': addressText.isNotEmpty,
        'hasEntranceNotes': entranceNotes.isNotEmpty,
        'mapSelection': _selectedLatLng != null,
      });

      final controller = ref.read(jobsControllerProvider);
      final result = await controller.createJob(
        category: _selectedCategory,
        extras: _selectedExtras,
        materialProvidedByPro: _materialProvidedByPro,
        isExpress: _isExpress,
        start: startDateTime,
        notes: combinedNotes,
        addressCity: _cityController.text.trim().isEmpty
            ? null
            : _cityController.text.trim(),
        addressDistrict: _districtController.text.trim().isEmpty
            ? null
            : _districtController.text.trim(),
        addressHint: _hintController.text.trim().isEmpty
            ? null
            : _hintController.text.trim(),
        addressText: addressText.isEmpty ? null : addressText,
        entranceNotes: entranceNotes.isEmpty ? null : entranceNotes,
        hasPrivateLocation: addressText.isNotEmpty,
      );

      DebugLogger.debug('✅ Job created successfully via form');
      DebugLogger.userAction('job_creation_success', {
        'category': _selectedCategory.name,
        'extrasCount': _selectedExtras.length,
        'budget': quote.totalCost,
        'addressSynced': result.addressSynchronized,
      });

      if (!result.addressSynchronized) {
        DebugLogger.warning('⚠️ Job address could not be synced', {
          'jobId': result.jobId,
        });
      }

      if (mounted) {
        final message = result.addressSynchronized
            ? l.jobCreateSuccess
            : '${l.jobCreateSuccess}\n${l.jobFormLocationSaveWarning}';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
        );
        context.go('/jobs');
      }
    } catch (e, stackTrace) {
      DebugLogger.error('❌ Error creating job via form', e, stackTrace);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.jobFormSubmitError),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      DebugLogger.exit('JobFormPage._submitJob', 'done');
    }
  }

  String _composeNotes(AppLocalizations l) {
    final parts = <String>[];

    final notes = _notesController.text.trim();
    final address = _addressController.text.trim();
    final entrance = _entranceNotesController.text.trim();

    if (notes.isNotEmpty) {
      parts.add(notes);
    }

    if (address.isNotEmpty) {
      parts.add('${l.jobFormAddress}: $address');
    }

    if (entrance.isNotEmpty) {
      parts.add('${l.jobFormDoorcode}: $entrance');
    }

    return parts.join('\n\n');
  }

  String _categoryLabel(AppLocalizations l, JobCategory category) {
    switch (category) {
      case JobCategory.s:
        return l.jobFormCategorySmall;
      case JobCategory.m:
        return l.jobFormCategoryMedium;
      case JobCategory.l:
        return l.jobFormCategoryLarge;
      case JobCategory.xl:
        return l.jobFormCategoryXl;
      case JobCategory.gt250:
        return l.jobFormCategoryVilla;
    }
  }

  String _extraLabel(AppLocalizations l, String id) {
    switch (id) {
      case 'windows_inside':
        return l.jobFormExtraWindowsInside;
      case 'windows_in_out':
        return l.jobFormExtraWindowsInOut;
      case 'kitchen_deep':
        return l.jobFormExtraKitchenDeep;
      case 'bathroom_deep':
        return l.jobFormExtraBathroomDeep;
      case 'laundry':
        return l.jobFormExtraLaundry;
      case 'ironing_light':
        return l.jobFormExtraIroningLight;
      case 'ironing_full':
        return l.jobFormExtraIroningFull;
      case 'balcony':
        return l.jobFormExtraBalcony;
      case 'organization':
        return l.jobFormExtraOrganization;
      default:
        return id;
    }
  }
}
