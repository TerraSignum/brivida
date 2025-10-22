import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/lead.dart';
import '../../../core/utils/debug_logger.dart';
import '../../../core/config/environment.dart';
import '../../../core/services/cloud_function_names.dart';

// Provider for leads repository
final leadsRepoProvider = Provider<LeadsRepository>((ref) {
  DebugLogger.debug('🔗 Creating LeadsRepository provider instance');
  return LeadsRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    functions: FirebaseFunctions.instanceFor(region: 'europe-west1'),
  );
});

class LeadsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;

  LeadsRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required FirebaseFunctions functions,
  }) : _firestore = firestore,
       _auth = auth,
       _functions = functions {
    DebugLogger.debug('🏗️ LeadsRepository created', {
      'firestoreType': _firestore.runtimeType.toString(),
      'authType': _auth.runtimeType.toString(),
      'functionsType': _functions.runtimeType.toString(),
    });
  }

  CollectionReference<Map<String, dynamic>> get _leadsCollection =>
      _firestore.collection('leads');

  // Create a new lead (pro applying to job)
  Future<String> createLead({
    required String jobId,
    required String customerUid,
    String message = '',
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final lead = Lead(
      jobId: jobId,
      customerUid: customerUid,
      proUid: user.uid,
      message: message,
      status: LeadStatus.pending,
      createdAt: DateTime.now(),
    );

    final docRef = await _leadsCollection.add(lead.toJson());
    return docRef.id;
  }

  // Get leads for current pro
  Stream<List<Lead>> getProLeads() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _leadsCollection
        .where('proUid', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Lead.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Get leads for a specific job (customer view)
  Stream<List<Lead>> getJobLeads(String jobId) {
    return _leadsCollection
        .where('jobId', isEqualTo: jobId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Lead.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Get pending leads for current pro
  Stream<List<Lead>> getPendingLeads() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _leadsCollection
        .where('proUid', isEqualTo: user.uid)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final leads = snapshot.docs
              .map((doc) {
                try {
                  final leadData = {...doc.data(), 'id': doc.id};
                  final lead = Lead.fromJson(leadData);

                  // In development mode, include mock data
                  if (Environment.isDevelopment) {
                    DebugLogger.debug('🎭 Development mode: including lead', {
                      'leadId': lead.id,
                      'isMock': leadData['isMockData'] ?? false,
                    });
                    return lead;
                  }

                  // In production, exclude mock data
                  if (leadData['isMockData'] == true) {
                    DebugLogger.debug('🚫 Excluding mock lead in production', {
                      'leadId': lead.id,
                    });
                    return null;
                  }

                  return lead;
                } catch (e) {
                  DebugLogger.error('❌ Error parsing lead document', e);
                  return null;
                }
              })
              .whereType<Lead>()
              .toList();

          return leads;
        });
  }

  // Accept a lead (via Cloud Function)
  Future<void> acceptLead(String leadId) async {
    final callable = _functions.httpsCallable(CloudFunctionNames.acceptLeadCF);

    try {
      await callable.call({'leadId': leadId});
    } catch (e) {
      throw Exception('Failed to accept lead: $e');
    }
  }

  // Decline a lead (via Cloud Function)
  Future<void> declineLead(String leadId) async {
    final callable = _functions.httpsCallable(CloudFunctionNames.declineLeadCF);

    try {
      await callable.call({'leadId': leadId});
    } catch (e) {
      throw Exception('Failed to decline lead: $e');
    }
  }

  // Get specific lead
  Future<Lead?> getLead(String leadId) async {
    final doc = await _leadsCollection.doc(leadId).get();
    if (!doc.exists) return null;

    return Lead.fromJson({...doc.data()!, 'id': doc.id});
  }

  // Get lead stream
  Stream<Lead?> getLeadStream(String leadId) {
    return _leadsCollection.doc(leadId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Lead.fromJson({...doc.data()!, 'id': doc.id});
    });
  }
}
