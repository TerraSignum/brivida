import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/pro_offer.dart';
import '../../../core/utils/debug_logger.dart';

final offersRepositoryProvider = Provider<OffersRepository>((ref) {
  DebugLogger.debug('🔗 Creating OffersRepository');
  return OffersRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

class OffersRepository {
  OffersRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('proOffers');

  Stream<List<ProOffer>> streamMyOffers() {
    final user = _auth.currentUser;
    if (user == null) {
      DebugLogger.warning('⚠️ OffersRepository.streamMyOffers: no auth user');
      return const Stream.empty();
    }

    DebugLogger.debug('📡 Streaming offers for pro', {'uid': user.uid});

    return _collection
        .where('proId', isEqualTo: user.uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final offers = snapshot.docs
              .map((doc) {
                try {
                  final data = {...doc.data(), 'id': doc.id};
                  return ProOffer.fromJson(data);
                } catch (e, stackTrace) {
                  DebugLogger.error(
                    '❌ Failed to parse ProOffer document: ${doc.id}',
                    e,
                    stackTrace,
                  );
                  return null;
                }
              })
              .whereType<ProOffer>()
              .toList();

          DebugLogger.debug('✅ Loaded offers for pro', {
            'count': offers.length,
          });
          return offers;
        });
  }

  Stream<ProOffer?> streamOffer(String offerId) {
    DebugLogger.debug('📡 Streaming offer', {'offerId': offerId});
    return _collection.doc(offerId).snapshots().map((doc) {
      if (!doc.exists) {
        return null;
      }
      try {
        final data = {...doc.data()!, 'id': doc.id};
        return ProOffer.fromJson(data);
      } catch (e, stackTrace) {
        DebugLogger.error(
          '❌ Failed to parse ProOffer snapshot: $offerId',
          e,
          stackTrace,
        );
        return null;
      }
    });
  }

  Future<ProOffer?> fetchOffer(String offerId) async {
    DebugLogger.debug('📄 Fetching offer', {'offerId': offerId});
    final doc = await _collection.doc(offerId).get();
    if (!doc.exists) {
      return null;
    }
    return ProOffer.fromJson({...doc.data()!, 'id': doc.id});
  }

  Future<String> createOffer(ProOffer draft) async {
    final user = _requireUser();
    final data = _prepareWritePayload(draft, user.uid, isUpdate: false);
    final docRef = await _collection.add(data);
    DebugLogger.debug('✅ Offer created', {'offerId': docRef.id});
    return docRef.id;
  }

  Future<void> updateOffer(ProOffer offer) async {
    if (offer.id == null) {
      throw ArgumentError('Offer ID required for update');
    }
    final user = _requireUser();
    final data = _prepareWritePayload(offer, user.uid, isUpdate: true);
    await _collection.doc(offer.id!).update(data);
    DebugLogger.debug('✅ Offer updated', {'offerId': offer.id});
  }

  Future<void> deleteOffer(String offerId) async {
    final user = _requireUser();
    DebugLogger.debug('🗑️ Deleting offer', {
      'offerId': offerId,
      'uid': user.uid,
    });
    await _collection.doc(offerId).delete();
  }

  Future<void> setOfferActive(String offerId, bool isActive) async {
    DebugLogger.debug('🔄 Setting offer active state', {
      'offerId': offerId,
      'isActive': isActive,
    });
    await _collection.doc(offerId).update({
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Map<String, dynamic> _prepareWritePayload(
    ProOffer offer,
    String proId, {
    required bool isUpdate,
  }) {
    final sortedWeekdays = [...offer.weekdays]..sort();

    final data = offer.toJson()
      ..remove('id')
      ..['proId'] = proId
      ..['weekdays'] = sortedWeekdays
      ..['extras'] = offer.extras.toJson()
      ..['geoCenter'] = offer.geoCenter.toJson()
      ..['createdAt'] = isUpdate
          ? offer.createdAt == null
                ? FieldValue.serverTimestamp()
                : Timestamp.fromDate(offer.createdAt!)
          : FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp();

    if (isUpdate) {
      data.remove('createdAt');
      if (offer.createdAt != null) {
        data['createdAt'] = Timestamp.fromDate(offer.createdAt!);
      }
    }

    return data;
  }

  User _requireUser() {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('User must be authenticated');
    }
    return user;
  }
}
