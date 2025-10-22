import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../core/models/job.dart';
import '../data/jobs_repo.dart';

/// PG-17/18: Enhanced job form with categories, extras, materials, express, recurring
class EnhancedJobFormPage extends ConsumerStatefulWidget {
  const EnhancedJobFormPage({super.key});

  @override
  ConsumerState<EnhancedJobFormPage> createState() =>
      _EnhancedJobFormPageState();
}

class _EnhancedJobFormPageState extends ConsumerState<EnhancedJobFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _sizeController = TextEditingController();
  final _roomsController = TextEditingController();
  final _budgetController = TextEditingController();
  final _notesController = TextEditingController();

  // PG-14: Address fields
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _hintController = TextEditingController();

  // PG-17/18: Enhanced fields
  JobCategory _selectedCategory = JobCategory.m;
  final List<String> _selectedExtras = [];
  bool _materialProvidedByPro = false;
  bool _isExpress = false;
  RecurrenceType _recurrenceType = RecurrenceType.none;

  DateTime? _startDate;
  TimeOfDay? _startTime;

  bool _isLoading = false;
  double _estimatedHours = 4.0;
  double _estimatedCost = 60.0;

  // PG-17: Available extra services with time impact
  final Map<String, Map<String, dynamic>> _availableExtras = {
    'windows_inside': {
      'label': 'Fenster innen reinigen',
      'hours': 1.0,
      'description': 'Alle Fenster von innen putzen',
      'icon': Icons.window,
    },
    'windows_in_out': {
      'label': 'Fenster innen + außen',
      'hours': 2.0,
      'description': 'Fenster beidseitig reinigen',
      'icon': Icons.window_outlined,
    },
    'kitchen_deep': {
      'label': 'Küche intensiv',
      'hours': 0.5,
      'description': 'Backofen, Kühlschrank, Mikrowelle',
      'icon': Icons.kitchen,
    },
    'ironing_small': {
      'label': 'Bügeln (klein)',
      'hours': 0.5,
      'description': 'Bis zu 5 Kleidungsstücke',
      'icon': Icons.iron,
    },
    'ironing_large': {
      'label': 'Bügeln (groß)',
      'hours': 1.0,
      'description': 'Mehr als 5 Kleidungsstücke',
      'icon': Icons.iron_outlined,
    },
    'balcony': {
      'label': 'Balkon/Terrasse',
      'hours': 0.5,
      'description': 'Außenbereich reinigen',
      'icon': Icons.balcony,
    },
    'laundry': {
      'label': 'Wäsche waschen',
      'hours': 1.0,
      'description': 'Kompletter Waschgang',
      'icon': Icons.local_laundry_service,
    },
  };

  @override
  void initState() {
    super.initState();
    _updateEstimates();
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _roomsController.dispose();
    _budgetController.dispose();
    _notesController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  void _updateEstimates() {
    // Calculate estimated hours and cost based on category and extras
    setState(() {
      double baseHours = _getCategoryHours(_selectedCategory);
      double extraHours = _selectedExtras.fold(0.0, (sum, extra) {
        return sum + (_availableExtras[extra]?['hours'] ?? 0.0);
      });

      _estimatedHours = (baseHours + extraHours).clamp(1.0, 8.0);

      // Base calculation: 15€/h
      double baseCost = _estimatedHours * 15.0;

      // Material fee
      if (_materialProvidedByPro) {
        baseCost += 7.0;
      }

      // Express surcharge
      if (_isExpress) {
        baseCost *= 1.20;
      }

      _estimatedCost = baseCost;
    });
  }

  double _getCategoryHours(JobCategory category) {
    switch (category) {
      case JobCategory.s:
        return 3.0;
      case JobCategory.m:
        return 4.0;
      case JobCategory.l:
        return 5.0;
      case JobCategory.xl:
        return 6.0;
      case JobCategory.gt250:
        return 6.0; // Custom, but start with default
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(l.jobFormTitle),
        actions: [
          if (_isExpress)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '⚡ EXPRESS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildEstimateCard(l),
              const SizedBox(height: 16),
              _buildCategorySection(l),
              const SizedBox(height: 16),
              _buildExtrasSection(l),
              const SizedBox(height: 16),
              _buildMaterialSection(l),
              const SizedBox(height: 16),
              _buildExpressSection(l),
              const SizedBox(height: 16),
              _buildRecurrenceSection(l),
              const SizedBox(height: 16),
              _buildAddressSection(l),
              const SizedBox(height: 16),
              _buildDateTimeSection(l),
              const SizedBox(height: 16),
              _buildNotesSection(l),
              const SizedBox(height: 32),
              _buildSubmitButton(l),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstimateCard(AppLocalizations l) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Geschätzte Dauer',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${_estimatedHours.toStringAsFixed(1)}h',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Geschätzter Preis',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '€${_estimatedCost.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            if (_materialProvidedByPro ||
                _isExpress ||
                _recurrenceType != RecurrenceType.none) ...[
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  if (_materialProvidedByPro)
                    Chip(
                      label: const Text('Material inklusive (+€7)'),
                      backgroundColor: Colors.green.shade100,
                      avatar: const Icon(Icons.inventory_2, size: 16),
                    ),
                  if (_isExpress)
                    Chip(
                      label: const Text('Express (+20%)'),
                      backgroundColor: Colors.orange.shade100,
                      avatar: const Icon(Icons.flash_on, size: 16),
                    ),
                  if (_recurrenceType != RecurrenceType.none)
                    Chip(
                      label: Text(_getRecurrenceLabel(_recurrenceType)),
                      backgroundColor: Colors.purple.shade100,
                      avatar: const Icon(Icons.repeat, size: 16),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(AppLocalizations l) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wohnungsgröße',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: JobCategory.values.map((category) {
                final isSelected = _selectedCategory == category;
                return ChoiceChip(
                  label: Text(_getCategoryLabel(category)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = category;
                        _updateEstimates();
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _sizeController,
                    decoration: const InputDecoration(
                      labelText: 'Wohnfläche',
                      suffixText: 'm²',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _roomsController,
                    decoration: const InputDecoration(
                      labelText: 'Anzahl Zimmer',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtrasSection(AppLocalizations l) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zusatzleistungen',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ..._availableExtras.entries.map((entry) {
              final extraId = entry.key;
              final extra = entry.value;
              final isSelected = _selectedExtras.contains(extraId);

              return CheckboxListTile(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedExtras.add(extraId);
                    } else {
                      _selectedExtras.remove(extraId);
                    }
                    _updateEstimates();
                  });
                },
                title: Row(
                  children: [
                    Icon(extra['icon'] as IconData, size: 20),
                    const SizedBox(width: 8),
                    Text(extra['label'] as String),
                    const Spacer(),
                    Text(
                      '+${extra['hours']}h',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                subtitle: Text(extra['description'] as String),
                contentPadding: EdgeInsets.zero,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialSection(AppLocalizations l) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reinigungsmittel',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _materialProvidedByPro,
              onChanged: (value) {
                setState(() {
                  _materialProvidedByPro = value;
                  _updateEstimates();
                });
              },
              title: const Text('Reinigungskraft bringt Material mit'),
              subtitle: Text(_materialProvidedByPro
                  ? 'Professionelle Reinigungsmittel inklusive (+€7)'
                  : 'Sie stellen die Reinigungsmittel zur Verfügung'),
              secondary: Icon(
                _materialProvidedByPro ? Icons.inventory_2 : Icons.home,
                color: _materialProvidedByPro ? Colors.green : Colors.grey,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpressSection(AppLocalizations l) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Express-Service',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _isExpress,
              onChanged: (value) {
                setState(() {
                  _isExpress = value;
                  _updateEstimates();
                });
              },
              title: const Text('⚡ Express-Buchung'),
              subtitle: Text(_isExpress
                  ? 'Sofortige Benachrichtigung aller Pros (+20% Aufschlag)'
                  : 'Normale Bearbeitung'),
              secondary: Icon(
                _isExpress ? Icons.flash_on : Icons.schedule,
                color: _isExpress ? Colors.orange : Colors.grey,
              ),
              contentPadding: EdgeInsets.zero,
            ),
            if (_isExpress) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Express-Jobs erhalten sofortige Priorität und werden allen verfügbaren Pros in der Nähe gesendet.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecurrenceSection(AppLocalizations l) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wiederkehrende Termine',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: RecurrenceType.values.map((type) {
                final isSelected = _recurrenceType == type;
                return ChoiceChip(
                  label: Text(_getRecurrenceLabel(type)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _recurrenceType = type;
                        _updateEstimates();
                      });
                    }
                  },
                );
              }).toList(),
            ),
            if (_recurrenceType != RecurrenceType.none) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.repeat, color: Colors.purple, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Rabatt für wiederkehrende Termine:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('• Ab 2. Termin: -10% Rabatt'),
                    const Text('• Ab 5. Termin: -15% Rabatt'),
                    const SizedBox(height: 8),
                    Text(
                      'Es werden automatisch bis zu 3 Folgetermine erstellt.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection(AppLocalizations l) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adresse',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Straße und Hausnummer',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Stadt',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _districtController,
                    decoration: const InputDecoration(
                      labelText: 'Stadtteil',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hintController,
              decoration: const InputDecoration(
                labelText: 'Hinweise (Klingel, Eingang, etc.)',
                prefixIcon: Icon(Icons.info_outline),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSection(AppLocalizations l) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wunschtermin',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_startDate != null
                        ? '${_startDate?.day}.${_startDate?.month}.${_startDate?.year}'
                        : 'Datum wählen'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectTime(context),
                    icon: const Icon(Icons.access_time),
                    label: Text(_startTime != null
                        ? '${_startTime?.hour.toString().padLeft(2, '0')}:${_startTime?.minute.toString().padLeft(2, '0')}'
                        : 'Zeit wählen'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(AppLocalizations l) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Besondere Wünsche',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notizen, spezielle Anforderungen...',
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: _isExpress ? Colors.orange : null,
        ),
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(
                _isExpress
                    ? '⚡ Express-Auftrag erstellen (€${_estimatedCost.toStringAsFixed(0)})'
                    : 'Auftrag erstellen (€${_estimatedCost.toStringAsFixed(0)})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  String _getCategoryLabel(JobCategory category) {
    switch (category) {
      case JobCategory.s:
        return 'S (≤60m²)';
      case JobCategory.m:
        return 'M (61-120m²)';
      case JobCategory.l:
        return 'L (121-200m²)';
      case JobCategory.xl:
        return 'XL (201-250m²)';
      case JobCategory.gt250:
        return 'GT250 (>250m²)';
    }
  }

  String _getRecurrenceLabel(RecurrenceType type) {
    switch (type) {
      case RecurrenceType.none:
        return 'Einmalig';
      case RecurrenceType.weekly:
        return 'Wöchentlich';
      case RecurrenceType.biweekly:
        return 'Alle 2 Wochen';
      case RecurrenceType.monthly:
        return 'Monatlich';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null) {
      setState(() {
        _startDate = date;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time != null) {
      setState(() {
        _startTime = time;
      });
    }
  }

  Future<void> _submitForm() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    if (_startDate == null || _startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte wählen Sie Datum und Uhrzeit')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Double-check that required values are available
      final startDate = _startDate;
      final startTime = _startTime;

      if (startDate == null || startTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bitte wählen Sie Datum und Uhrzeit')),
        );
        return;
      }

      final startDateTime = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        startTime.hour,
        startTime.minute,
      );

      final job = Job(
        customerUid: '', // Will be set by controller
        rooms: int.tryParse(_roomsController.text) ?? 1,
        sizeM2: double.tryParse(_sizeController.text) ?? 50.0,
        services: ['general_cleaning'], // Will be enhanced later
        budget: _estimatedCost,
        status: JobStatus.open,
        paymentStatus: PaymentStatus.none,
        notes: _notesController.text,
        window: JobWindow(
          start: startDateTime,
          end: startDateTime.add(Duration(hours: _estimatedHours.round())),
        ),
        hasPrivateLocation: false,
        visibleTo: [],

        // PG-17/18: Enhanced fields
        category: _selectedCategory,
        baseHours: _getCategoryHours(_selectedCategory),
        extras: _selectedExtras,
        extrasHours: _selectedExtras.fold(0.0, (sum, extra) {
          return sum + (_availableExtras[extra]?['hours'] ?? 0.0);
        }),
        materialProvidedByPro: _materialProvidedByPro,
        materialFeeEur: _materialProvidedByPro ? 7.0 : 0.0,
        isExpress: _isExpress,
        recurrence: {
          'type': _recurrenceType.name,
          'intervalDays': _recurrenceType == RecurrenceType.weekly
              ? 7
              : _recurrenceType == RecurrenceType.biweekly
                  ? 14
                  : _recurrenceType == RecurrenceType.monthly
                      ? 30
                      : 0,
        },
        occurrenceIndex: 1,
        extraServices: _selectedExtras,
        materialsRequired: !_materialProvidedByPro,
        checklist: [],
        completedPhotos: [],

        // Address fields
        addressCity: _cityController.text,
        addressDistrict: _districtController.text,
        addressHint: _hintController.text,
      );

      await ref.read(jobsRepoProvider).createJob(job);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isExpress
                ? '⚡ Express-Auftrag erfolgreich erstellt!'
                : 'Auftrag erfolgreich erstellt!'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
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
}
