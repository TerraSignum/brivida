import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/models/pro_offer.dart';
import '../../../core/utils/debug_logger.dart';
import '../../../core/services/geocoding_service.dart';
import '../utils/offer_extra_options.dart';
import '../logic/pro_offers_controller.dart';

class ProOfferEditorPage extends ConsumerStatefulWidget {
  const ProOfferEditorPage({super.key, this.offer});

  final ProOffer? offer;

  @override
  ConsumerState<ProOfferEditorPage> createState() => _ProOfferEditorPageState();
}

class _ProOfferEditorPageState extends ConsumerState<ProOfferEditorPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  final _formKey = GlobalKey<FormState>();
  late Set<int> _selectedWeekdays;
  late TimeOfDay _timeFrom;
  late TimeOfDay _timeTo;
  late int _minHours;
  late int _maxHours;
  late bool _acceptsRecurring;
  late Set<String> _selectedExtras;
  late double _radiusKm;
  OfferLocation? _geoCenter;
  String? _locationLabel;
  GoogleMapController? _mapController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final offer = widget.offer;
    _titleController = TextEditingController(text: offer?.title ?? '');
    _notesController = TextEditingController(text: offer?.notes ?? '');
    _selectedWeekdays = offer?.weekdays.toSet() ?? <int>{1, 3, 5};
    _timeFrom =
        _parseTimeOfDay(offer?.timeFrom) ?? const TimeOfDay(hour: 9, minute: 0);
    _timeTo =
        _parseTimeOfDay(offer?.timeTo) ?? const TimeOfDay(hour: 13, minute: 0);
    _minHours = offer?.minHours ?? 2;
    _maxHours = offer?.maxHours ?? 4;
    _acceptsRecurring = offer?.acceptsRecurring ?? false;
    _selectedExtras = offer != null
        ? selectedExtrasFromOffer(offer.extras)
        : <String>{};
    _radiusKm = (offer?.serviceRadiusKm ?? 15).toDouble();
    _geoCenter = offer?.geoCenter;
    if (offer != null) {
      _locationLabel = _formatLatLng(offer.geoCenter);
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _resolveInitialAddress(),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.offer != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? 'proOffers.editor.editTitle'.tr()
              : 'proOffers.editor.createTitle'.tr(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'proOffers.editor.fields.title.label'.tr(),
                  hintText: 'proOffers.editor.fields.title.hint'.tr(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'proOffers.editor.errors.titleRequired'.tr();
                  }
                  if (value.trim().length < 3) {
                    return 'proOffers.editor.errors.titleTooShort'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                'proOffers.editor.weekdays'.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: List<int>.generate(7, (index) => index + 1).map((
                  weekday,
                ) {
                  final selected = _selectedWeekdays.contains(weekday);
                  return FilterChip(
                    label: Text(_weekdayLabel(context, weekday)),
                    selected: selected,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _selectedWeekdays.add(weekday);
                        } else {
                          _selectedWeekdays.remove(weekday);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTimeField(context, true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTimeField(context, false)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _minHours,
                      decoration: InputDecoration(
                        labelText: 'proOffers.editor.minHours'.tr(),
                      ),
                      items: List.generate(7, (index) => index + 2)
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                'proOffers.editor.hoursOption'.tr(
                                  namedArgs: {'hours': value.toString()},
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _minHours = value;
                          if (_maxHours < _minHours) {
                            _maxHours = _minHours;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _maxHours,
                      decoration: InputDecoration(
                        labelText: 'proOffers.editor.maxHours'.tr(),
                      ),
                      items: List.generate(7, (index) => index + 2)
                          .where((value) => value >= _minHours)
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(
                                'proOffers.editor.hoursOption'.tr(
                                  namedArgs: {'hours': value.toString()},
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _maxHours = value;
                          if (_minHours > _maxHours) {
                            _minHours = _maxHours;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile.adaptive(
                value: _acceptsRecurring,
                onChanged: (value) => setState(() => _acceptsRecurring = value),
                title: Text('proOffers.editor.recurring.title'.tr()),
                subtitle: Text('proOffers.editor.recurring.subtitle'.tr()),
              ),
              const Divider(height: 32),
              Text(
                'proOffers.editor.extras'.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
              const Divider(height: 32),
              Text(
                'proOffers.editor.radius.title'.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Slider(
                value: _radiusKm,
                onChanged: (value) => setState(() => _radiusKm = value),
                min: 5,
                max: 50,
                divisions: 45,
                label: 'proOffers.editor.radius.value'.tr(
                  namedArgs: {'km': _radiusKm.round().toString()},
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'proOffers.editor.radius.value'.tr(
                    namedArgs: {'km': _radiusKm.round().toString()},
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLocationSection(context),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'proOffers.editor.fields.notes.label'.tr(),
                  hintText: 'proOffers.editor.fields.notes.hint'.tr(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _submit,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    isEditing
                        ? 'proOffers.editor.submitUpdate'.tr()
                        : 'proOffers.editor.submitCreate'.tr(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField(BuildContext context, bool isFrom) {
    final label = isFrom
        ? 'proOffers.editor.timeFrom'.tr()
        : 'proOffers.editor.timeTo'.tr();
    return FormField<TimeOfDay>(
      validator: (_) {
        final error = _validateTimeRange();
        if (error == null) {
          return null;
        }
        return isFrom ? null : error;
      },
      builder: (field) {
        final value = isFrom ? _timeFrom : _timeTo;
        return InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: value,
            );
            if (picked != null) {
              setState(() {
                if (isFrom) {
                  _timeFrom = picked;
                } else {
                  _timeTo = picked;
                }
              });
              field.didChange(picked);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: const Icon(Icons.access_time),
              errorText: field.errorText,
            ),
            child: Text(
              _formatTimeReadable(context, value),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        );
      },
    );
  }

  String? _validateTimeRange() {
    final fromMinutes = _timeFrom.hour * 60 + _timeFrom.minute;
    final toMinutes = _timeTo.hour * 60 + _timeTo.minute;
    if (toMinutes <= fromMinutes) {
      return 'proOffers.editor.errors.timeOrder'.tr();
    }
    return null;
  }

  TimeOfDay? _parseTimeOfDay(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final parts = value.split(':');
    if (parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatTimeReadable(BuildContext context, TimeOfDay time) {
    final materialLocalizations = MaterialLocalizations.of(context);
    return materialLocalizations.formatTimeOfDay(
      time,
      alwaysUse24HourFormat: true,
    );
  }

  String _weekdayLabel(BuildContext context, int weekday) {
    final baseMonday = DateTime(2023, 1, 2); // Monday reference
    final date = baseMonday.add(Duration(days: weekday - 1));
    final locale = context.locale.toString();
    return DateFormat.EEEE(locale).format(date);
  }

  Widget _buildLocationSection(BuildContext context) {
    final hasLocation = _geoCenter != null;
    final theme = Theme.of(context);
    final displayLabel = hasLocation
        ? _locationLabel ?? _formatLatLng(_geoCenter!)
        : 'proOffers.editor.location.placeholder'.tr();
    final helperText = hasLocation
        ? 'proOffers.editor.location.coordinates'.tr(
            namedArgs: {
              'lat': _geoCenter!.lat.toStringAsFixed(4),
              'lng': _geoCenter!.lng.toStringAsFixed(4),
            },
          )
        : 'proOffers.editor.location.helper'.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'proOffers.editor.location.title'.tr(),
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
                    const Icon(Icons.location_on_outlined),
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
                        key: ValueKey('${_geoCenter!.lat}_${_geoCenter!.lng}'),
                        initialCameraPosition: CameraPosition(
                          target: LatLng(_geoCenter!.lat, _geoCenter!.lng),
                          zoom: 14,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('offer_location'),
                            position: LatLng(_geoCenter!.lat, _geoCenter!.lng),
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
                    'proOffers.editor.location.mapCaption'.tr(),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _isSaving ? null : _selectLocation,
                    icon: const Icon(Icons.search),
                    label: Text(
                      hasLocation
                          ? 'proOffers.editor.location.change'.tr()
                          : 'proOffers.editor.location.select'.tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasLocation && _locationLabel != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'proOffers.editor.location.selected'.tr(
                namedArgs: {'address': _locationLabel!},
              ),
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  Future<void> _selectLocation() async {
    final result = await showDialog<GeocodingResult>(
      context: context,
      builder: (dialogContext) {
        final textController = TextEditingController(
          text: _locationLabel ?? '',
        );
        String? errorText;
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> search() async {
              final query = textController.text.trim();
              if (query.isEmpty) {
                setState(() {
                  errorText = 'proOffers.editor.errors.addressRequired'.tr();
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
                  errorText = 'proOffers.editor.location.dialog.noResults'.tr();
                });
              }
            }

            return AlertDialog(
              title: Text('proOffers.editor.location.dialog.title'.tr()),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      labelText: 'proOffers.editor.location.dialog.addressLabel'
                          .tr(),
                      hintText: 'proOffers.editor.location.dialog.addressHint'
                          .tr(),
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
                      'proOffers.editor.location.dialog.searching'.tr(),
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
                  child: Text('common.cancel'.tr()),
                ),
                FilledButton.icon(
                  onPressed: isLoading ? null : search,
                  icon: const Icon(Icons.search),
                  label: Text('proOffers.editor.location.dialog.search'.tr()),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && mounted) {
      setState(() {
        _geoCenter = OfferLocation(lat: result.lat, lng: result.lng);
        _locationLabel = result.address;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateMapCamera());
    }
  }

  Future<void> _resolveInitialAddress() async {
    final location = _geoCenter;
    if (location == null) {
      return;
    }

    final resolved = await GeocodingService.reverseGeocode(
      location.lat,
      location.lng,
    );
    if (!mounted || resolved == null) {
      return;
    }

    setState(() {
      _locationLabel = resolved;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateMapCamera());
  }

  String _formatLatLng(OfferLocation location) {
    return '${location.lat.toStringAsFixed(4)}, ${location.lng.toStringAsFixed(4)}';
  }

  void _updateMapCamera() {
    final controller = _mapController;
    final location = _geoCenter;
    if (controller == null || location == null) {
      return;
    }

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(location.lat, location.lng), 14),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedWeekdays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('proOffers.editor.errors.weekdaysRequired'.tr()),
        ),
      );
      return;
    }
    if (_geoCenter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('proOffers.editor.errors.locationMissing'.tr())),
      );
      return;
    }

    final controller = ref.read(proOffersControllerProvider);
    final isEditing = widget.offer != null;

    setState(() => _isSaving = true);

    final extras = buildOfferExtrasFromSelection(_selectedExtras);

    final offer = ProOffer(
      id: widget.offer?.id,
      proId: widget.offer?.proId ?? '',
      title: _titleController.text.trim(),
      weekdays: _selectedWeekdays.toList()..sort(),
      timeFrom: _formatTime(_timeFrom),
      timeTo: _formatTime(_timeTo),
      minHours: _minHours,
      maxHours: _maxHours,
      acceptsRecurring: _acceptsRecurring,
      extras: extras,
      geoCenter: _geoCenter!,
      serviceRadiusKm: _radiusKm.round(),
      notes: _notesController.text.trim(),
      isActive: widget.offer?.isActive ?? true,
      createdAt: widget.offer?.createdAt,
      updatedAt: widget.offer?.updatedAt,
    );

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      if (isEditing) {
        await controller.updateOffer(offer);
      } else {
        await controller.createOffer(offer);
      }
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'proOffers.editor.successUpdate'.tr()
                  : 'proOffers.editor.successCreate'.tr(),
            ),
          ),
        );
        navigator.pop();
      }
    } on OfferValidationException catch (error) {
      DebugLogger.error('❌ Offer validation error', error, StackTrace.current);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'proOffers.editor.errors.validation'.tr(
              namedArgs: {'code': error.code},
            ),
          ),
        ),
      );
    } catch (error, stackTrace) {
      DebugLogger.error('❌ offer save error', error, stackTrace);
      messenger.showSnackBar(
        SnackBar(content: Text('proOffers.editor.errors.saveFailed'.tr())),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
