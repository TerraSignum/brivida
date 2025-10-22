import 'dart:math' as math;

import 'package:brivida_app/core/models/job.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Describes derived values for a job quote.
class JobQuote {
  JobQuote({
    required this.category,
    required this.baseHours,
    required this.extrasHours,
    required this.hourlyRate,
    required this.materialFee,
    required this.isExpress,
    required this.totalCost,
    required this.totalHours,
    required this.defaultSizeM2,
    required this.defaultRooms,
    required this.services,
  });

  final JobCategory category;
  final double baseHours;
  final double extrasHours;
  final double hourlyRate;
  final double materialFee;
  final bool isExpress;
  final double totalCost;
  final double totalHours;
  final double defaultSizeM2;
  final int defaultRooms;
  final List<String> services;

  double get totalMinutes => totalHours * 60;

  DateTime calculateEnd(DateTime start) {
    final minutes = (totalMinutes).round();
    return start.add(Duration(minutes: minutes));
  }
}

/// Base configuration for a given category (size group).
class JobCategoryConfig {
  const JobCategoryConfig({
    required this.category,
    required this.labelKey,
    required this.baseHours,
    required this.defaultSizeM2,
    required this.defaultRooms,
  });

  final JobCategory category;
  final String labelKey;
  final double baseHours;
  final double defaultSizeM2;
  final int defaultRooms;
}

/// Configuration for extras that can be added to a job.
class JobExtraConfig {
  const JobExtraConfig({
    required this.id,
    required this.hours,
    required this.labelKey,
    required this.serviceId,
  });

  final String id;
  final double hours;
  final String labelKey;
  final String serviceId;
}

/// Contains the selection the user made for a job request.
class JobQuoteInput {
  const JobQuoteInput({
    required this.category,
    this.selectedExtras = const <String>{},
    this.materialProvidedByPro = false,
    this.isExpress = false,
  });

  final JobCategory category;
  final Set<String> selectedExtras;
  final bool materialProvidedByPro;
  final bool isExpress;
}

/// Central place for estimating job durations and pricing.
class JobQuoteService {
  const JobQuoteService();

  static const double _baseHourlyRate = 18.0;
  static const double _expressMultiplier = 1.2;
  static const double _materialFee = 7.0;

  static const Map<JobCategory, JobCategoryConfig> _categoryConfigs = {
    JobCategory.s: JobCategoryConfig(
      category: JobCategory.s,
      labelKey: 'job.category.small',
      baseHours: 2.5,
      defaultSizeM2: 45,
      defaultRooms: 2,
    ),
    JobCategory.m: JobCategoryConfig(
      category: JobCategory.m,
      labelKey: 'job.category.medium',
      baseHours: 3.5,
      defaultSizeM2: 65,
      defaultRooms: 3,
    ),
    JobCategory.l: JobCategoryConfig(
      category: JobCategory.l,
      labelKey: 'job.category.large',
      baseHours: 4.5,
      defaultSizeM2: 90,
      defaultRooms: 4,
    ),
    JobCategory.xl: JobCategoryConfig(
      category: JobCategory.xl,
      labelKey: 'job.category.xl',
      baseHours: 5.5,
      defaultSizeM2: 120,
      defaultRooms: 5,
    ),
    JobCategory.gt250: JobCategoryConfig(
      category: JobCategory.gt250,
      labelKey: 'job.category.gt250',
      baseHours: 6.5,
      defaultSizeM2: 150,
      defaultRooms: 6,
    ),
  };

  static const Map<String, JobExtraConfig> _extraConfigs = {
    'windows_inside': JobExtraConfig(
      id: 'windows_inside',
      hours: 1.0,
      labelKey: 'job.extra.windowsInside',
      serviceId: 'windows_inside',
    ),
    'windows_in_out': JobExtraConfig(
      id: 'windows_in_out',
      hours: 1.5,
      labelKey: 'job.extra.windowsInOut',
      serviceId: 'windows_in_out',
    ),
    'kitchen_deep': JobExtraConfig(
      id: 'kitchen_deep',
      hours: 0.75,
      labelKey: 'job.extra.kitchenDeep',
      serviceId: 'kitchen_deep',
    ),
    'bathroom_deep': JobExtraConfig(
      id: 'bathroom_deep',
      hours: 0.75,
      labelKey: 'job.extra.bathroomDeep',
      serviceId: 'bathroom_deep',
    ),
    'laundry': JobExtraConfig(
      id: 'laundry',
      hours: 1.0,
      labelKey: 'job.extra.laundry',
      serviceId: 'laundry',
    ),
    'ironing_light': JobExtraConfig(
      id: 'ironing_light',
      hours: 0.5,
      labelKey: 'job.extra.ironingLight',
      serviceId: 'ironing',
    ),
    'ironing_full': JobExtraConfig(
      id: 'ironing_full',
      hours: 1.0,
      labelKey: 'job.extra.ironingFull',
      serviceId: 'ironing',
    ),
    'balcony': JobExtraConfig(
      id: 'balcony',
      hours: 0.5,
      labelKey: 'job.extra.balcony',
      serviceId: 'balcony',
    ),
    'organization': JobExtraConfig(
      id: 'organization',
      hours: 0.75,
      labelKey: 'job.extra.organization',
      serviceId: 'organization',
    ),
  };

  JobQuote quote(JobQuoteInput input) {
    final categoryConfig = _categoryConfigs[input.category];
    if (categoryConfig == null) {
      throw ArgumentError('Unsupported category ${input.category}');
    }

    final extrasHours = input.selectedExtras.fold<double>(0.0, (sum, extra) {
      final config = _extraConfigs[extra];
      return sum + (config?.hours ?? 0);
    });

    final baseHours = categoryConfig.baseHours;
    final totalHours = math.max(1.5, baseHours + extrasHours);

    var cost = totalHours * _baseHourlyRate;
    if (input.materialProvidedByPro) {
      cost += _materialFee;
    }
    if (input.isExpress) {
      cost *= _expressMultiplier;
    }

    final services = <String>{'house_cleaning'};
    for (final extra in input.selectedExtras) {
      final config = _extraConfigs[extra];
      if (config != null) {
        services.add(config.serviceId);
      }
    }

    return JobQuote(
      category: input.category,
      baseHours: baseHours,
      extrasHours: extrasHours,
      hourlyRate: _baseHourlyRate,
      materialFee: input.materialProvidedByPro ? _materialFee : 0,
      isExpress: input.isExpress,
      totalCost: double.parse(cost.toStringAsFixed(2)),
      totalHours: double.parse(totalHours.toStringAsFixed(2)),
      defaultSizeM2: categoryConfig.defaultSizeM2,
      defaultRooms: categoryConfig.defaultRooms,
      services: services.toList()..sort(),
    );
  }

  static Map<String, JobExtraConfig> get extraConfigs => _extraConfigs;
  static Map<JobCategory, JobCategoryConfig> get categoryConfigs =>
      _categoryConfigs;
}

final jobQuoteServiceProvider = Provider<JobQuoteService>((ref) {
  return const JobQuoteService();
});
