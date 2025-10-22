import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/pro_offer.dart';
import '../../../core/utils/debug_logger.dart';
import '../data/offers_repo.dart';

/// Stream provider exposing current pro offers
final proOffersStreamProvider = StreamProvider<List<ProOffer>>((ref) {
  DebugLogger.debug('🔗 Creating proOffersStreamProvider');
  final repo = ref.watch(offersRepositoryProvider);
  return repo.streamMyOffers();
});

/// Stream provider for a specific offer
final proOfferStreamProvider = StreamProvider.family<ProOffer?, String>((
  ref,
  offerId,
) {
  DebugLogger.debug('🔗 Creating proOfferStreamProvider', {'offerId': offerId});
  final repo = ref.watch(offersRepositoryProvider);
  return repo.streamOffer(offerId);
});

/// Controller facade for pro offer actions
final proOffersControllerProvider = Provider<ProOffersController>((ref) {
  DebugLogger.debug('🔗 Creating ProOffersController provider instance');
  final repo = ref.watch(offersRepositoryProvider);
  return ProOffersController(repo);
});

class ProOffersController {
  ProOffersController(this._repo) {
    DebugLogger.debug('🏗️ ProOffersController instantiated', {
      'repoType': _repo.runtimeType.toString(),
    });
  }

  final OffersRepository _repo;

  Future<String> createOffer(ProOffer offer) async {
    DebugLogger.enter('ProOffersController.createOffer');
    _validateOffer(offer, isUpdate: false);
    final offerId = await _repo.createOffer(offer);
    DebugLogger.exit('ProOffersController.createOffer', offerId);
    return offerId;
  }

  Future<void> updateOffer(ProOffer offer) async {
    if (offer.id == null) {
      throw ArgumentError('Offer ID is required for update');
    }
    DebugLogger.enter('ProOffersController.updateOffer', {'offerId': offer.id});
    _validateOffer(offer, isUpdate: true);
    await _repo.updateOffer(offer);
    DebugLogger.exit('ProOffersController.updateOffer', offer.id);
  }

  Future<void> toggleOfferActive(String offerId, bool isActive) async {
    DebugLogger.enter('ProOffersController.toggleOfferActive', {
      'offerId': offerId,
      'isActive': isActive,
    });
    await _repo.setOfferActive(offerId, isActive);
    DebugLogger.exit('ProOffersController.toggleOfferActive', offerId);
  }

  Future<void> deleteOffer(String offerId) async {
    DebugLogger.enter('ProOffersController.deleteOffer', {'offerId': offerId});
    await _repo.deleteOffer(offerId);
    DebugLogger.exit('ProOffersController.deleteOffer', offerId);
  }

  void _validateOffer(ProOffer offer, {required bool isUpdate}) {
    DebugLogger.debug('🧪 Validating offer payload', {
      'offerId': offer.id,
      'title': offer.title,
      'weekdays': offer.weekdays,
      'timeFrom': offer.timeFrom,
      'timeTo': offer.timeTo,
      'serviceRadiusKm': offer.serviceRadiusKm,
    });

    if (offer.title.trim().isEmpty) {
      throw OfferValidationException('offers.validation.title_required');
    }

    if (offer.weekdays.isEmpty) {
      throw OfferValidationException('offers.validation.weekdays_required');
    }

    if (offer.weekdays.any((day) => day < 1 || day > 7)) {
      throw OfferValidationException('offers.validation.weekday_range');
    }

    final fromMinutes = _parseMinutes(offer.timeFrom);
    final toMinutes = _parseMinutes(offer.timeTo);

    if (fromMinutes == null || toMinutes == null) {
      throw OfferValidationException('offers.validation.time_format');
    }

    if (toMinutes <= fromMinutes) {
      throw OfferValidationException('offers.validation.time_order');
    }

    if (offer.minHours <= 0 || offer.maxHours <= 0) {
      throw OfferValidationException('offers.validation.hours_positive');
    }

    if (offer.minHours > offer.maxHours) {
      throw OfferValidationException('offers.validation.hours_range');
    }

    if (offer.serviceRadiusKm < 5 || offer.serviceRadiusKm > 50) {
      throw OfferValidationException('offers.validation.radius_range');
    }

    if (offer.geoCenter.lat.abs() > 90 || offer.geoCenter.lng.abs() > 180) {
      throw OfferValidationException('offers.validation.geo_invalid');
    }

    if (!isUpdate && offer.id != null) {
      DebugLogger.warning(
        '⚠️ Offer has ID on create, will be ignored by repository',
        {'offerId': offer.id},
      );
    }
  }

  int? _parseMinutes(String value) {
    final parts = value.split(':');
    if (parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }
    return hour * 60 + minute;
  }
}

class OfferValidationException implements Exception {
  OfferValidationException(this.code);
  final String code;

  @override
  String toString() => 'OfferValidationException(code: $code)';
}
