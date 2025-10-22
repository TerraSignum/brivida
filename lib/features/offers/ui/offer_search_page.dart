import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/models/offer_request.dart';
import '../../../core/models/offer_search.dart';
import '../../../core/models/pro_offer.dart';
import '../../../core/utils/debug_logger.dart';
import '../../../core/services/geocoding_service.dart';
import '../logic/offer_search_controller.dart';
import '../utils/offer_extra_options.dart';
import '../../tutorial/logic/tutorial_registry.dart';
import '../../tutorial/ui/tutorial_trigger.dart';

class OfferSearchPage extends ConsumerStatefulWidget {
  const OfferSearchPage({super.key});

  static const routeName = '/offers/search';

  @override
  ConsumerState<OfferSearchPage> createState() => _OfferSearchPageState();
}

class _OfferSearchPageState extends ConsumerState<OfferSearchPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  final Set<String> _selectedExtras = <String>{};

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  double _durationHours = 3;
  double _radiusKm = 20;
  bool _recurring = false;
  LatLng? _selectedLatLng;
  String? _selectedAddressLabel;
  GoogleMapController? _mapController;
  String? _locationError;

  @override
  void dispose() {
    _addressController.dispose();
    _noteController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<OfferSearchState>(offerSearchControllerProvider, (
      previous,
      next,
    ) {
      if (previous?.lastRequestId != next.lastRequestId &&
          next.lastRequestId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'offerSearch.messages.requestSent'.tr(context: context),
            ),
          ),
        );
        ref.read(offerSearchControllerProvider.notifier).clearRequestFeedback();
      }

      if (next.requestErrorCode != null &&
          previous?.requestErrorCode != next.requestErrorCode) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'offerSearch.messages.requestError'.tr(
                context: context,
                namedArgs: {'code': next.requestErrorCode!},
              ),
            ),
          ),
        );
      }
    });

    final state = ref.watch(offerSearchControllerProvider);
    final localeName = context.locale.toString();
    final hoursFormat = NumberFormat('0.0', localeName);
    final integerFormat = NumberFormat('0', localeName);
    final durationText = hoursFormat.format(_durationHours);
    final radiusText = integerFormat.format(_radiusKm);

    final durationLabel = 'offerSearch.filters.duration'.tr(
      namedArgs: {'hours': durationText},
    );
    final radiusLabel = 'offerSearch.filters.radius'.tr(
      namedArgs: {'km': radiusText},
    );

    final content = PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _handleBack(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => _handleBack(context)),
          title: Text('offerSearch.pageTitle'.tr()),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.of(context).viewPadding.bottom,
            ),
            children: [
              _buildDateTimePicker(context),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'offerSearch.filters.address.label'.tr(),
                  hintText: 'offerSearch.filters.address.hint'.tr(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'offerSearch.validation.address'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildLocationSection(context),
              const SizedBox(height: 16),
              Text(durationLabel),
              Slider(
                value: _durationHours,
                onChanged: (value) => setState(() => _durationHours = value),
                min: 2,
                max: 8,
                divisions: 12,
                label: durationLabel,
              ),
              const SizedBox(height: 16),
              Text(radiusLabel),
              Slider(
                value: _radiusKm,
                onChanged: (value) => setState(() => _radiusKm = value),
                min: 5,
                max: 50,
                divisions: 45,
                label: radiusLabel,
              ),
              SwitchListTile.adaptive(
                value: _recurring,
                onChanged: (value) => setState(() => _recurring = value),
                title: Text('offerSearch.filters.recurring'.tr()),
              ),
              const Divider(height: 32),
              Text('offerSearch.filters.extras'.tr()),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: offerExtraOptions.map((option) {
                  final isSelected = _selectedExtras.contains(option.id);
                  return FilterChip(
                    label: Text(option.labelKey.tr()),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedExtras.add(option.id);
                        } else {
                          _selectedExtras.remove(option.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: state.isLoading ? null : _searchOffers,
                icon: state.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search),
                label: Text('offerSearch.filters.search'.tr()),
              ),
              const SizedBox(height: 24),
              if (state.errorCode != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    'offerSearch.messages.searchError'.tr(
                      namedArgs: {'code': state.errorCode!},
                    ),
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'offerSearch.results.title'.tr(
                  namedArgs: {'count': state.results.length.toString()},
                ),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ...state.results.map(
                (result) => _OfferResultCard(
                  result: result,
                  durationHours: _durationHours,
                  extras: Set<String>.from(_selectedExtras),
                  extraOptions: offerExtraOptions,
                  recurring: _recurring,
                  address: _addressController.text,
                  noteController: _noteController,
                  onSubmit: _submitRequest,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return TutorialTrigger(screen: TutorialScreen.offerSearch, child: content);
  }

  void _handleBack(BuildContext context) {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      context.pop();
      return;
    }

    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }

    context.go('/home');
  }

  Widget _buildLocationSection(BuildContext context) {
    final theme = Theme.of(context);
    final hasLocation = _selectedLatLng != null;
    final displayLabel = hasLocation
        ? (_selectedAddressLabel ?? _addressController.text.trim())
        : 'offerSearch.location.placeholder'.tr();
    final helperText = hasLocation
        ? 'offerSearch.location.coordinates'.tr(
            namedArgs: {
              'lat': _selectedLatLng!.latitude.toStringAsFixed(4),
              'lng': _selectedLatLng!.longitude.toStringAsFixed(4),
            },
          )
        : 'offerSearch.location.helper'.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'offerSearch.location.title'.tr(),
          style: theme.textTheme.titleMedium,
        ),
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
                            markerId: const MarkerId('offer_location'),
                            position: _selectedLatLng!,
                            infoWindow: InfoWindow(title: displayLabel),
                          ),
                        },
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        tiltGesturesEnabled: false,
                        rotateGesturesEnabled: false,
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
                    'offerSearch.location.mapCaption'.tr(),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _selectLocation(),
                    icon: const Icon(Icons.search),
                    label: Text(
                      hasLocation
                          ? 'offerSearch.location.change'.tr()
                          : 'offerSearch.location.select'.tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_locationError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _locationError!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _selectLocation() async {
    final initialQuery =
        _selectedAddressLabel ?? _addressController.text.trim();

    final selection = await showModalBottomSheet<_LocationSelectionResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => _OfferLocationPickerSheet(
        initialQuery: initialQuery,
        initialLatLng: _selectedLatLng,
      ),
    );

    if (selection == null) {
      return;
    }

    setState(() {
      _selectedLatLng = selection.latLng;
      _selectedAddressLabel = selection.address;
      _addressController.text = selection.address;
      _locationError = null;
    });
    _updateMapCamera();
  }

  void _updateMapCamera() {
    final latLng = _selectedLatLng;
    if (latLng == null || _mapController == null) {
      return;
    }

    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 15)),
    );
  }

  Widget _buildDateTimePicker(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('offerSearch.filters.date'.tr()),
            subtitle: Text(_selectedDate.toLocal().toString().split(' ').first),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 60)),
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
            leading: const Icon(Icons.calendar_today),
          ),
        ),
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('offerSearch.filters.time'.tr()),
            subtitle: Text(_selectedTime.format(context)),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
              );
              if (picked != null) {
                setState(() => _selectedTime = picked);
              }
            },
            leading: const Icon(Icons.schedule),
          ),
        ),
      ],
    );
  }

  Map<String, bool> _buildExtrasMap() =>
      buildExtrasMapFromSelection(_selectedExtras);

  OfferExtras _buildOfferExtras() =>
      buildOfferExtrasFromSelection(_selectedExtras);

  Future<void> _searchOffers() async {
    final formValid = _formKey.currentState!.validate();
    final latLng = _selectedLatLng;

    if (!formValid || latLng == null) {
      setState(() {
        _locationError = latLng == null
            ? 'offerSearch.validation.location'.tr(context: context)
            : _locationError;
      });
      return;
    }

    if (_locationError != null) {
      setState(() {
        _locationError = null;
      });
    }

    final filter = OfferSearchFilter(
      when: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      durationHours: _durationHours,
      geo: OfferLocation(lat: latLng.latitude, lng: latLng.longitude),
      radiusKm: _radiusKm.round(),
      recurring: _recurring,
      extras: _buildOfferExtras(),
    );

    DebugLogger.userAction('offer_search_requested', {
      'radiusKm': filter.radiusKm,
      'durationHours': filter.durationHours,
      'recurring': filter.recurring,
    });

    await ref.read(offerSearchControllerProvider.notifier).searchOffers(filter);
  }

  Future<void> _submitRequest(OfferSearchResult result, String note) async {
    final latLng = _selectedLatLng;
    if (latLng == null) {
      final message = 'offerSearch.validation.location'.tr(context: context);
      setState(() {
        _locationError = message;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    if (_locationError != null) {
      setState(() {
        _locationError = null;
      });
    }
    final extrasMap = _buildExtrasMap();

    final job = OfferRequestJob(
      address: _addressController.text.trim(),
      geo: OfferLocation(lat: latLng.latitude, lng: latLng.longitude),
      start: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      ),
      durationH: _durationHours,
      extras: extrasMap,
      recurring: _recurring ? 'recurring' : 'once',
    );

    const price = OfferRequestPrice();

    await ref
        .read(offerSearchControllerProvider.notifier)
        .submitRequest(
          offerId: result.offerId,
          job: job,
          price: price,
          note: note.isEmpty ? null : note,
        );
  }
}

class _OfferResultCard extends StatelessWidget {
  const _OfferResultCard({
    required this.result,
    required this.durationHours,
    required this.extras,
    required this.extraOptions,
    required this.recurring,
    required this.address,
    required this.noteController,
    required this.onSubmit,
  });

  final OfferSearchResult result;
  final double durationHours;
  final Set<String> extras;
  final List<OfferExtraOption> extraOptions;
  final bool recurring;
  final String address;
  final TextEditingController noteController;
  final Future<void> Function(OfferSearchResult, String note) onSubmit;

  @override
  Widget build(BuildContext context) {
    final localeName = context.locale.toString();
    final decimalFormat = NumberFormat('0.0', localeName);
    final distanceFormat = NumberFormat('0.0', localeName);
    final durationText = decimalFormat.format(durationHours);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    result.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (result.distanceKm > 0)
                  Chip(
                    avatar: const Icon(Icons.location_on, size: 16),
                    label: Text(
                      'offerSearch.results.distance'.tr(
                        namedArgs: {
                          'km': distanceFormat.format(result.distanceKm),
                        },
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'offerSearch.results.pro'.tr(
                namedArgs: {'name': result.pro.displayName},
              ),
            ),
            if (result.pro.rating > 0)
              Text(
                'offerSearch.results.rating'.tr(
                  namedArgs: {
                    'rating': decimalFormat.format(result.pro.rating),
                  },
                ),
              ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(
                    'offerSearch.results.window'.tr(
                      namedArgs: {
                        'from': result.window.from,
                        'to': result.window.to,
                      },
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    'offerSearch.results.durationChip'.tr(
                      namedArgs: {'hours': durationText},
                    ),
                  ),
                ),
                if (recurring)
                  Chip(label: Text('offerSearch.results.recurringChip'.tr())),
                ...extraOptions
                    .where((option) => extras.contains(option.id))
                    .map(
                      (option) => Chip(
                        label: Text(option.labelKey.tr(context: context)),
                      ),
                    ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                if (address.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'offerSearch.messages.addressRequired'.tr(),
                      ),
                    ),
                  );
                  return;
                }

                noteController.text = '';

                final note = await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'offerSearch.results.noteTitle'.tr(
                              namedArgs: {'name': result.pro.displayName},
                            ),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: noteController,
                            decoration: InputDecoration(
                              labelText: 'offerSearch.results.noteLabel'.tr(),
                              hintText: 'offerSearch.results.noteHint'.tr(),
                            ),
                            maxLines: 4,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(
                                context,
                              ).pop(noteController.text.trim()),
                              child: Text('offerSearch.results.submit'.tr()),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );

                if (note == null) {
                  return;
                }

                await onSubmit(result, note);
              },
              icon: const Icon(Icons.send),
              label: Text('offerSearch.results.cta'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationSelectionResult {
  const _LocationSelectionResult({required this.latLng, required this.address});

  final LatLng latLng;
  final String address;
}

class _OfferLocationPickerSheet extends StatefulWidget {
  const _OfferLocationPickerSheet({
    required this.initialQuery,
    this.initialLatLng,
  });

  final String initialQuery;
  final LatLng? initialLatLng;

  @override
  State<_OfferLocationPickerSheet> createState() =>
      _OfferLocationPickerSheetState();
}

class _OfferLocationPickerSheetState extends State<_OfferLocationPickerSheet> {
  late final TextEditingController _searchController;
  GoogleMapController? _mapController;
  LatLng? _selectedLatLng;
  String? _resolvedAddress;
  String? _errorText;
  bool _isLoading = false;

  static const LatLng _fallbackCenter = LatLng(38.7223, -9.1393); // Lisbon

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _selectedLatLng = widget.initialLatLng;
    if (widget.initialLatLng != null && widget.initialQuery.isNotEmpty) {
      _resolvedAddress = widget.initialQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  bool get _hasSelection => _selectedLatLng != null;

  Future<void> _searchAddress() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _errorText = 'offerSearch.location.dialog.addressRequired'.tr();
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final result = await GeocodingService.geocodeAddress(query);

    if (!mounted) {
      return;
    }

    if (result == null) {
      setState(() {
        _isLoading = false;
        _errorText = 'offerSearch.location.dialog.noResults'.tr();
      });
      return;
    }

    _applyLocation(LatLng(result.lat, result.lng), address: result.address);
  }

  Future<void> _handleMapSelection(LatLng latLng) async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final address = await GeocodingService.reverseGeocode(
      latLng.latitude,
      latLng.longitude,
    );

    if (!mounted) {
      return;
    }

    _applyLocation(latLng, address: address);
  }

  void _applyLocation(LatLng latLng, {String? address}) {
    setState(() {
      _selectedLatLng = latLng;
      _resolvedAddress =
          address ??
          '${latLng.latitude.toStringAsFixed(4)}, '
              '${latLng.longitude.toStringAsFixed(4)}';
      _isLoading = false;
    });
    _animateTo(latLng);
  }

  void _animateTo(LatLng target) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 16)),
    );
  }

  void _confirmSelection() {
    if (!_hasSelection) return;

    Navigator.of(context).pop(
      _LocationSelectionResult(
        latLng: _selectedLatLng!,
        address:
            _resolvedAddress ??
            '${_selectedLatLng!.latitude.toStringAsFixed(4)}, '
                '${_selectedLatLng!.longitude.toStringAsFixed(4)}',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'offerSearch.location.dialog.addressLabel'.tr(),
                    hintText: 'offerSearch.location.dialog.addressHint'.tr(),
                    suffixIcon: IconButton(
                      onPressed: _isLoading ? null : _searchAddress,
                      icon: const Icon(Icons.search),
                    ),
                    errorText: _errorText,
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _searchAddress(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(
                  'offerSearch.location.mapCaption'.tr(),
                  style: theme.textTheme.bodySmall,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _selectedLatLng ?? _fallbackCenter,
                            zoom: _selectedLatLng != null ? 15 : 12,
                          ),
                          myLocationButtonEnabled: false,
                          myLocationEnabled: false,
                          zoomControlsEnabled: false,
                          mapToolbarEnabled: false,
                          markers: {
                            if (_selectedLatLng != null)
                              Marker(
                                markerId: const MarkerId('offer_location'),
                                position: _selectedLatLng!,
                                infoWindow: InfoWindow(title: _resolvedAddress),
                              ),
                          },
                          onMapCreated: (controller) {
                            _mapController = controller;
                            if (_selectedLatLng != null) {
                              _animateTo(_selectedLatLng!);
                            }
                          },
                          onTap: (latLng) => _handleMapSelection(latLng),
                          onLongPress: (latLng) => _handleMapSelection(latLng),
                          gestureRecognizers:
                              <Factory<OneSequenceGestureRecognizer>>{
                                Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer(),
                                ),
                              },
                        ),
                        if (_isLoading)
                          const Align(
                            alignment: Alignment.topCenter,
                            child: LinearProgressIndicator(minHeight: 3),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_resolvedAddress != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(
                    _resolvedAddress!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: FilledButton.icon(
                  onPressed: _hasSelection && !_isLoading
                      ? _confirmSelection
                      : null,
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text('offerSearch.location.confirm'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
