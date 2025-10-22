import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/job.dart';
import '../../../core/utils/debug_logger.dart';
import '../../payments/data/payment_repo.dart';
import '../data/job_completion_repository.dart';
import '../data/jobs_repo.dart';
import '../models/job_completion.dart';

class JobCompletionChecklistItemState {
  const JobCompletionChecklistItemState({
    required this.id,
    required this.label,
    required this.completed,
  });

  final String id;
  final String label;
  final bool completed;

  JobCompletionChecklistItemState copyWith({bool? completed}) {
    return JobCompletionChecklistItemState(
      id: id,
      label: label,
      completed: completed ?? this.completed,
    );
  }

  JobCompletionChecklistItem toModel() {
    return JobCompletionChecklistItem(label: label, completed: completed);
  }
}

class JobCompletionPhotoState {
  const JobCompletionPhotoState({
    required this.id,
    required this.url,
    required this.isUploading,
  });

  final String id;
  final String url;
  final bool isUploading;

  JobCompletionPhotoState copyWith({String? url, bool? isUploading}) {
    return JobCompletionPhotoState(
      id: id,
      url: url ?? this.url,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}

class JobCompletionState {
  const JobCompletionState({
    required this.checklist,
    required this.photos,
    required this.note,
    required this.status,
    required this.isSubmitting,
    required this.isApproving,
    required this.isUploadingPhoto,
    this.errorMessage,
  });

  factory JobCompletionState.initial() => const JobCompletionState(
    checklist: <JobCompletionChecklistItemState>[],
    photos: <JobCompletionPhotoState>[],
    note: '',
    status: 'draft',
    isSubmitting: false,
    isApproving: false,
    isUploadingPhoto: false,
    errorMessage: null,
  );

  final List<JobCompletionChecklistItemState> checklist;
  final List<JobCompletionPhotoState> photos;
  final String note;
  final String status;
  final bool isSubmitting;
  final bool isApproving;
  final bool isUploadingPhoto;
  final String? errorMessage;

  bool get hasPendingSubmission => status == 'submitted';
  bool get isApproved => status == 'approved';

  JobCompletionState copyWith({
    List<JobCompletionChecklistItemState>? checklist,
    List<JobCompletionPhotoState>? photos,
    String? note,
    String? status,
    bool? isSubmitting,
    bool? isApproving,
    bool? isUploadingPhoto,
    String? errorMessage,
  }) {
    return JobCompletionState(
      checklist: checklist ?? this.checklist,
      photos: photos ?? this.photos,
      note: note ?? this.note,
      status: status ?? this.status,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isApproving: isApproving ?? this.isApproving,
      isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
      errorMessage: errorMessage,
    );
  }
}

class JobCompletionController extends StateNotifier<JobCompletionState> {
  JobCompletionController(
    this._jobId,
    this._completionRepository,
    this._jobsRepository,
    this._paymentRepository, {
    Uuid? uuid,
    ImagePicker? imagePicker,
  }) : _uuid = uuid ?? const Uuid(),
       _imagePicker = imagePicker ?? ImagePicker(),
       super(JobCompletionState.initial());

  final String _jobId;
  final JobCompletionRepository _completionRepository;
  final JobsRepository _jobsRepository;
  final PaymentRepository _paymentRepository;
  final Uuid _uuid;
  final ImagePicker _imagePicker;

  Job? _job;
  bool _initialized = false;
  String? _lastCompletionMarker;

  void hydrate(Job job, JobCompletion? completion, {required bool isPro}) {
    _job = job;

    if (!_initialized) {
      state = state.copyWith(
        checklist: _buildInitialChecklist(job),
        photos: const <JobCompletionPhotoState>[],
        note: '',
        status: completion?.status ?? 'draft',
        errorMessage: null,
      );
      _initialized = true;
    }

    if (completion != null) {
      final marker = (completion.updatedAt ?? completion.submittedAt)
          .millisecondsSinceEpoch
          .toString();
      if (_lastCompletionMarker != marker) {
        _lastCompletionMarker = marker;
        state = state.copyWith(
          checklist: completion.checklist
              .map(
                (item) => JobCompletionChecklistItemState(
                  id: _uuid.v5(Uuid.NAMESPACE_URL, '${item.label}-$marker'),
                  label: item.label,
                  completed: item.completed,
                ),
              )
              .toList(),
          photos: completion.photoUrls
              .map(
                (url) => JobCompletionPhotoState(
                  id: _uuid.v5(Uuid.NAMESPACE_URL, '$url-$marker'),
                  url: url,
                  isUploading: false,
                ),
              )
              .toList(),
          note: completion.note,
          status: completion.status,
          errorMessage: null,
        );
      }
    }

    if (completion == null && state.checklist.isEmpty) {
      state = state.copyWith(checklist: _buildInitialChecklist(job));
    }
  }

  List<JobCompletionChecklistItemState> _buildInitialChecklist(Job job) {
    final items = <String>{};
    if (job.checklist.isNotEmpty) {
      items.addAll(job.checklist);
    } else if (job.services.isNotEmpty) {
      items.addAll(job.services);
    }

    if (items.isEmpty) {
      return [
        JobCompletionChecklistItemState(
          id: _uuid.v4(),
          label: 'General cleaning complete',
          completed: false,
        ),
      ];
    }

    return items
        .map(
          (label) => JobCompletionChecklistItemState(
            id: _uuid.v4(),
            label: label,
            completed: false,
          ),
        )
        .toList();
  }

  void toggleChecklistItem(String id) {
    final updated = state.checklist
        .map(
          (item) =>
              item.id == id ? item.copyWith(completed: !item.completed) : item,
        )
        .toList();
    state = state.copyWith(checklist: updated, errorMessage: null);
  }

  void setNote(String value) {
    if (value == state.note) return;
    state = state.copyWith(note: value, errorMessage: null);
  }

  Future<void> pickAndAddPhoto() async {
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (file == null) return;
      await addPhoto(File(file.path));
    } catch (error, stackTrace) {
      DebugLogger.error(
        '❌ JOB_COMPLETION: Failed to pick photo',
        error,
        stackTrace,
      );
      state = state.copyWith(errorMessage: 'jobCompletion.error.photoPicker');
    }
  }

  Future<void> addPhoto(File file) async {
    final tempId = _uuid.v4();
    state = state.copyWith(
      isUploadingPhoto: true,
      photos: [
        ...state.photos,
        JobCompletionPhotoState(id: tempId, url: '', isUploading: true),
      ],
      errorMessage: null,
    );

    try {
      final url = await _completionRepository.uploadPhoto(_jobId, file);
      state = state.copyWith(
        isUploadingPhoto: false,
        photos: state.photos
            .map(
              (photo) => photo.id == tempId
                  ? photo.copyWith(url: url, isUploading: false)
                  : photo,
            )
            .toList(),
      );
    } catch (error, stackTrace) {
      DebugLogger.error(
        '❌ JOB_COMPLETION: Photo upload failed',
        error,
        stackTrace,
      );
      state = state.copyWith(
        isUploadingPhoto: false,
        photos: state.photos.where((photo) => photo.id != tempId).toList(),
        errorMessage: 'jobCompletion.error.upload',
      );
    }
  }

  void removePhoto(String id) {
    state = state.copyWith(
      photos: state.photos.where((photo) => photo.id != id).toList(),
      errorMessage: null,
    );
  }

  Future<void> submit({required String role}) async {
    if (state.isSubmitting) return;

    final job = _job;
    if (job == null || job.id == null) {
      state = state.copyWith(errorMessage: 'jobCompletion.error.noJob');
      return;
    }

    if (state.photos.any((photo) => photo.isUploading)) {
      state = state.copyWith(
        errorMessage: 'jobCompletion.error.photoUploading',
      );
      return;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await _completionRepository.submitCompletion(
        jobId: job.id!,
        checklist: state.checklist.map((item) => item.toModel()).toList(),
        photoUrls: state.photos
            .where((photo) => photo.url.isNotEmpty)
            .map((item) => item.url)
            .toList(),
        note: state.note,
        role: role,
      );
      state = state.copyWith(isSubmitting: false, status: 'submitted');
    } catch (error, stackTrace) {
      DebugLogger.error('❌ JOB_COMPLETION: Submit failed', error, stackTrace);
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'jobCompletion.error.submit',
      );
    }
  }

  Future<void> approve({required Job job}) async {
    if (state.isApproving) return;
    if (job.id == null) {
      state = state.copyWith(errorMessage: 'jobCompletion.error.noJob');
      return;
    }

    state = state.copyWith(isApproving: true, errorMessage: null);

    try {
      await _completionRepository.approveCompletion(job.id!);
      await _jobsRepository.markJobCompleted(job.id!);

      if (job.paymentId != null &&
          (job.paymentStatus == PaymentStatus.captured ||
              job.paymentStatus == PaymentStatus.pending)) {
        try {
          await _paymentRepository.releaseTransfer(
            paymentId: job.paymentId!,
            manualRelease: true,
          );
        } catch (paymentError, paymentStack) {
          DebugLogger.error(
            '⚠️ JOB_COMPLETION: Payment release failed',
            paymentError,
            paymentStack,
          );
        }
      }

      state = state.copyWith(isApproving: false, status: 'approved');
    } catch (error, stackTrace) {
      DebugLogger.error('❌ JOB_COMPLETION: Approve failed', error, stackTrace);
      state = state.copyWith(
        isApproving: false,
        errorMessage: 'jobCompletion.error.approve',
      );
    }
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }
}

final jobCompletionControllerProvider = StateNotifierProvider.autoDispose
    .family<JobCompletionController, JobCompletionState, String>((ref, jobId) {
      final completionRepo = ref.watch(jobCompletionRepositoryProvider);
      final jobsRepo = ref.watch(jobsRepoProvider);
      final paymentRepo = ref.watch(paymentRepositoryProvider);
      final controller = JobCompletionController(
        jobId,
        completionRepo,
        jobsRepo,
        paymentRepo,
      );
      ref.onDispose(controller.clearError);
      return controller;
    });
