import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/lead.dart';
import '../data/leads_repo.dart';

// Provider for pro leads
final proLeadsProvider = StreamProvider<List<Lead>>((ref) {
  final repo = ref.watch(leadsRepoProvider);
  return repo.getProLeads();
});

// Provider for pending leads only
final pendingLeadsProvider = StreamProvider<List<Lead>>((ref) {
  final repo = ref.watch(leadsRepoProvider);
  return repo.getPendingLeads();
});

// Provider for leads of a specific job
final jobLeadsProvider =
    StreamProvider.family<List<Lead>, String>((ref, jobId) {
  final repo = ref.watch(leadsRepoProvider);
  return repo.getJobLeads(jobId);
});

// Provider for specific lead
final leadProvider = StreamProvider.family<Lead?, String>((ref, leadId) {
  final repo = ref.watch(leadsRepoProvider);
  return repo.getLeadStream(leadId);
});

// Controller for lead operations
final leadsControllerProvider = Provider<LeadsController>((ref) {
  return LeadsController(ref.watch(leadsRepoProvider));
});

class LeadsController {
  final LeadsRepository _repo;

  LeadsController(this._repo);

  // Create a new lead (pro applying to job)
  Future<String> createLead({
    required String jobId,
    required String customerUid,
    String message = '',
  }) async {
    return await _repo.createLead(
      jobId: jobId,
      customerUid: customerUid,
      message: message,
    );
  }

  // Accept a lead
  Future<void> acceptLead(String leadId) async {
    await _repo.acceptLead(leadId);
  }

  // Decline a lead
  Future<void> declineLead(String leadId) async {
    await _repo.declineLead(leadId);
  }

  // Get single lead
  Future<Lead?> getLead(String leadId) async {
    return await _repo.getLead(leadId);
  }
}
