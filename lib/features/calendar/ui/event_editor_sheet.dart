import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/models/calendar_event.dart';
import '../../../core/services/geocoding_service.dart';
import '../logic/calendar_controller.dart';
import '../logic/calendar_conflict_exception.dart';
import '../../auth/logic/auth_controller.dart';

class EventEditorSheet extends ConsumerStatefulWidget {
  final CalendarEvent? event;
  final DateTime initialDate;

  const EventEditorSheet({super.key, this.event, required this.initialDate});

  @override
  ConsumerState<EventEditorSheet> createState() => _EventEditorSheetState();
}

class _EventEditorSheetState extends ConsumerState<EventEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _startDateTime;
  late DateTime _endDateTime;
  late EventType _eventType;
  late EventVisibility _visibility;
  int _bufferBefore = 0;
  int _bufferAfter = 0;
  CalendarLocation? _location;

  bool _isLoading = false;
  ConflictResult? _conflictResult;

  @override
  void initState() {
    super.initState();

    if (widget.event != null) {
      // Edit mode
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description ?? '';
      _startDateTime = widget.event!.start;
      _endDateTime = widget.event!.end;
      _eventType = widget.event!.type;
      _visibility = widget.event!.visibility;
      _bufferBefore = widget.event!.bufferBefore;
      _bufferAfter = widget.event!.bufferAfter;
      _location = widget.event!.location;
    } else {
      // Create mode
      _titleController.text = '';
      _descriptionController.text = '';
      _startDateTime = DateTime(
        widget.initialDate.year,
        widget.initialDate.month,
        widget.initialDate.day,
        9, // 9 AM
      );
      _endDateTime = _startDateTime.add(const Duration(hours: 2));
      _eventType = EventType.private;
      _visibility = EventVisibility.busy;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.event != null;
    final isJobEvent = widget.event?.type == EventType.job;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        final sheetMediaQuery = MediaQuery.of(context);
        final bottomInset = sheetMediaQuery.viewInsets.bottom;
        final safeBottom = sheetMediaQuery.viewPadding.bottom;
        final formBottomPadding = safeBottom + bottomInset + 32;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      isEditMode
                          ? 'calendar.editEvent'.tr()
                          : 'calendar.newEvent'.tr(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Spacer(),
                    if (isJobEvent)
                      Chip(
                        label: Text('calendar.eventTypes.job'.tr()),
                        backgroundColor: Colors.blue,
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('calendar.cancel'.tr()),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.fromLTRB(16, 16, 16, formBottomPadding),
                    children: [
                      if (isJobEvent) ...[
                        // Job events are read-only
                        _buildJobEventInfo(),
                      ] else ...[
                        // Editable fields for private events and availability
                        _buildTitleField(),
                        const SizedBox(height: 16),
                        _buildDescriptionField(),
                        const SizedBox(height: 16),
                        _buildEventTypeSelector(),
                        const SizedBox(height: 16),
                        _buildDateTimeSelectors(),
                        const SizedBox(height: 16),
                        _buildBufferSettings(),
                        const SizedBox(height: 16),
                        _buildVisibilitySelector(),
                        const SizedBox(height: 16),
                        _buildLocationField(),
                        if (_conflictResult != null) ...[
                          const SizedBox(height: 16),
                          _buildConflictWarning(),
                        ],
                        const SizedBox(height: 32),
                        _buildActionButtons(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJobEventInfo() {
    final event = widget.event!;
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'calendar.jobEvent.title'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(dateFormat.format(event.start)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${timeFormat.format(event.start)} - ${timeFormat.format(event.end)}',
                    ),
                  ],
                ),
                if (event.location != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(event.location!.address)),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  'calendar.jobEvent.buffer'.tr(
                    namedArgs: {
                      'before': event.bufferBefore.toString(),
                      'after': event.bufferAfter.toString(),
                    },
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'calendar.jobEvent.readOnlyInfo'.tr(),
          style: TextStyle(
            color: Colors.orange.shade700,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildEventTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'calendar.form.eventType'.tr(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SegmentedButton<EventType>(
          segments: [
            ButtonSegment(
              value: EventType.private,
              label: Text('calendar.form.privateEvent'.tr()),
              icon: const Icon(Icons.event),
            ),
            ButtonSegment(
              value: EventType.availability,
              label: Text('calendar.form.availability'.tr()),
              icon: const Icon(Icons.schedule),
            ),
          ],
          selected: {_eventType},
          onSelectionChanged: (Set<EventType> selection) {
            setState(() {
              if (selection.isNotEmpty) {
                _conflictResult = null;
                _eventType = selection.first;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildDateTimeSelectors() {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'calendar.form.dateTime'.tr(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'calendar.form.date'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  child: Text(dateFormat.format(_startDateTime)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectStartTime(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'calendar.form.from'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  child: Text(timeFormat.format(_startDateTime)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectEndTime(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'calendar.form.to'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  child: Text(timeFormat.format(_endDateTime)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBufferSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'calendar.form.bufferSettings'.tr(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: _bufferBefore.toString(),
                decoration: InputDecoration(
                  labelText: 'calendar.form.bufferBefore'.tr(),
                  border: const OutlineInputBorder(),
                  suffixText: 'calendar.form.minutes'.tr(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _conflictResult = null;
                    _bufferBefore = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                initialValue: _bufferAfter.toString(),
                decoration: InputDecoration(
                  labelText: 'calendar.form.bufferAfter'.tr(),
                  border: const OutlineInputBorder(),
                  suffixText: 'calendar.form.minutes'.tr(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _conflictResult = null;
                    _bufferAfter = int.tryParse(value) ?? 0;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVisibilitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'calendar.form.visibility'.tr(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<EventVisibility>(
          value: _visibility,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: [
            DropdownMenuItem(
              value: EventVisibility.busy,
              child: Text('calendar.form.busy'.tr()),
            ),
            DropdownMenuItem(
              value: EventVisibility.private,
              child: Text('calendar.form.privateVisibility'.tr()),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _visibility = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'calendar.form.location'.tr(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        if (_location != null) ...[
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(_location!.address),
              subtitle: Text(
                '${_location!.lat.toStringAsFixed(6)}, ${_location!.lng.toStringAsFixed(6)}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _conflictResult = null;
                    _location = null;
                  });
                },
              ),
            ),
          ),
        ] else ...[
          OutlinedButton.icon(
            onPressed: _selectLocation,
            icon: const Icon(Icons.add_location),
            label: Text('calendar.form.addLocation'.tr()),
          ),
        ],
      ],
    );
  }

  Widget _buildConflictWarning() {
    final conflict = _conflictResult;
    if (conflict == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isHard = conflict.isHard;
    final color = isHard ? theme.colorScheme.error : Colors.orange.shade800;
    final background = isHard
        ? theme.colorScheme.errorContainer.withValues(alpha: 0.25)
        : Colors.orange.shade50;
    final icon = isHard ? Icons.error_outline : Icons.warning_amber_rounded;

    final conflictingEvent = conflict.conflictingEvent;
    final hasTitle = (conflictingEvent?.title.trim().isNotEmpty ?? false);
    final eventTitle = hasTitle
        ? conflictingEvent!.title
        : 'calendar.conflicts.untitledEvent'.tr();

    String? eventTime;
    if (conflictingEvent != null) {
      final localeTag = context.locale.toLanguageTag();
      final dateFormat = DateFormat.yMMMd(localeTag);
      final timeFormat = DateFormat.Hm(localeTag);
      eventTime =
          '${dateFormat.format(conflictingEvent.start)} · ${timeFormat.format(conflictingEvent.start)} – ${timeFormat.format(conflictingEvent.end)}';
    }

    final message = _resolveConflictMessage(
      conflict,
      eventTitle: eventTitle,
      eventTime: eventTime,
    );

    final headingKey = isHard
        ? 'calendar.conflicts.blockingTitle'
        : 'calendar.conflicts.warningTitle';

    return Card(
      color: background,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headingKey.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(color: color),
                  ),
                  if (eventTime != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'calendar.conflicts.conflictingEvent'.tr(
                        namedArgs: {'title': eventTitle},
                      ),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      eventTime,
                      style: theme.textTheme.bodySmall?.copyWith(color: color),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _resolveConflictMessage(
    ConflictResult conflict, {
    required String eventTitle,
    String? eventTime,
  }) {
    final namedArgs = <String, String>{
      'title': eventTitle,
      if (eventTime != null) 'time': eventTime,
    };

    if (conflict.missingMinutes != null) {
      namedArgs['missing'] = conflict.missingMinutes!.abs().toString();
    }
    if (conflict.actualGapMinutes != null) {
      namedArgs['actual'] = conflict.actualGapMinutes!.abs().toString();
    }
    if (conflict.requiredGapMinutes != null) {
      namedArgs['required'] = conflict.requiredGapMinutes!.abs().toString();
    }

    switch (conflict.code) {
      case CalendarConflictCode.directOverlap:
        return 'calendar.conflicts.directOverlap'.tr(namedArgs: namedArgs);
      case CalendarConflictCode.insufficientGap:
        return 'calendar.conflicts.insufficientGap'.tr(namedArgs: namedArgs);
      case CalendarConflictCode.softGap:
        return 'calendar.conflicts.softGap'.tr(namedArgs: namedArgs);
      case CalendarConflictCode.etaFallback:
        return 'calendar.conflicts.etaFallback'.tr(namedArgs: namedArgs);
      case CalendarConflictCode.validationError:
        return 'calendar.conflicts.validationError'.tr();
      case CalendarConflictCode.unknown:
        return conflict.message ??
            'calendar.conflicts.unknown'.tr(namedArgs: namedArgs);
    }
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (widget.event != null) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: _isLoading ? null : () => _deleteEvent(context),
              child: Text('calendar.delete'.tr()),
            ),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: FilledButton(
            onPressed: _isLoading ? null : _saveEvent,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    widget.event != null
                        ? 'calendar.save'.tr()
                        : 'calendar.create'.tr(),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date != null) {
      setState(() {
        _conflictResult = null;
        _startDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          _startDateTime.hour,
          _startDateTime.minute,
        );
        _endDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          _endDateTime.hour,
          _endDateTime.minute,
        );
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startDateTime),
    );

    if (time != null) {
      setState(() {
        _conflictResult = null;
        _startDateTime = DateTime(
          _startDateTime.year,
          _startDateTime.month,
          _startDateTime.day,
          time.hour,
          time.minute,
        );

        // Ensure end time is after start time
        if (_endDateTime.isBefore(_startDateTime)) {
          _endDateTime = _startDateTime.add(const Duration(hours: 1));
        }
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_endDateTime),
    );

    if (time != null) {
      final newEndTime = DateTime(
        _endDateTime.year,
        _endDateTime.month,
        _endDateTime.day,
        time.hour,
        time.minute,
      );

      if (newEndTime.isAfter(_startDateTime)) {
        setState(() {
          _conflictResult = null;
          _endDateTime = newEndTime;
        });
      } else {
        if (!mounted || !context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('calendar.form.endTimeError'.tr())),
        );
      }
    }
  }

  void _selectLocation() {
    showDialog(
      context: context,
      builder: (context) {
        String address = '';
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('calendar.form.enterLocation'.tr()),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'calendar.form.address'.tr(),
                      hintText: 'calendar.form.addressExample'.tr(),
                      prefixIcon: const Icon(Icons.location_on),
                    ),
                    onChanged: (value) {
                      address = value;
                    },
                    enabled: !isLoading,
                  ),
                  if (isLoading) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text('calendar.form.addressSearching'.tr()),
                      ],
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text('calendar.cancel'.tr()),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (address.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('errors.addressRequired'.tr()),
                              ),
                            );
                            return;
                          }

                          setDialogState(() {
                            isLoading = true;
                          });

                          try {
                            final result =
                                await GeocodingService.geocodeAddress(address);

                            if (!mounted || !context.mounted) {
                              return;
                            }

                            if (result != null) {
                              setState(() {
                                _conflictResult = null;
                                _location = CalendarLocation(
                                  lat: result.lat,
                                  lng: result.lng,
                                  address: result.address,
                                );
                              });
                              if (!context.mounted) {
                                return;
                              }
                              Navigator.of(context).pop();
                            } else {
                              if (!context.mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('errors.geocodeFailed'.tr()),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'calendar.form.addressError'.tr(
                                      namedArgs: {'error': e.toString()},
                                    ),
                                  ),
                                ),
                              );
                            }
                          } finally {
                            if (context.mounted) {
                              setDialogState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                  child: Text('calendar.form.add'.tr()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _conflictResult = null;
    });

    try {
      final user = ref.read(authStateProvider).asData?.value;
      final ownerUid = user?.uid;
      if (ownerUid == null) {
        if (mounted && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('calendar.errors.authRequired'.tr())),
          );
        }
        return;
      }

      final event = CalendarEvent(
        id: widget.event?.id,
        ownerUid: ownerUid,
        type: _eventType,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        start: _startDateTime,
        end: _endDateTime,
        location: _location,
        bufferBefore: _bufferBefore,
        bufferAfter: _bufferAfter,
        visibility: _visibility,
        createdAt: widget.event?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.event != null) {
        await ref
            .read(calendarControllerProvider(ownerUid).notifier)
            .updateEvent(event);
      } else {
        await ref
            .read(calendarControllerProvider(ownerUid).notifier)
            .createEvent(event);
      }

      if (mounted && context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.event != null
                  ? 'calendar.eventUpdated'.tr()
                  : 'calendar.eventCreated'.tr(),
            ),
          ),
        );
      }
    } on CalendarConflictException catch (conflict) {
      if (mounted) {
        setState(() {
          _conflictResult = conflict.conflict;
        });
      }
    } catch (e) {
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'calendar.errors.saveFailed'.tr(
                namedArgs: {'error': e.toString()},
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _deleteEvent(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('calendar.deleteConfirmTitle'.tr()),
        content: Text('calendar.deleteConfirmMessage'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('calendar.cancel'.tr()),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog

              try {
                final user = ref.read(authStateProvider).asData?.value;
                final ownerUid = user?.uid;
                if (ownerUid == null) {
                  if (mounted && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'calendar.errors.authRequiredDelete'.tr(),
                        ),
                      ),
                    );
                  }
                  return;
                }
                await ref
                    .read(calendarControllerProvider(ownerUid).notifier)
                    .deleteEvent(widget.event!.id!);

                if (mounted && context.mounted) {
                  Navigator.of(context).pop(); // Close sheet
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('calendar.eventDeleted'.tr())),
                  );
                }
              } catch (e) {
                if (mounted && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'calendar.deleteError'.tr(
                          namedArgs: {'error': e.toString()},
                        ),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text('calendar.delete'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'calendar.form.title'.tr(),
        hintText: 'calendar.form.titleHint'.tr(),
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'calendar.form.titleRequired'.tr();
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'calendar.form.description'.tr(),
        hintText: 'calendar.form.descriptionHint'.tr(),
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.description),
      ),
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
    );
  }
}
