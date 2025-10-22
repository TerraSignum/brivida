import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/models/job.dart';
import '../../../core/utils/debug_logger.dart';
import '../../../core/config/environment.dart';

// Provider for jobs repository
final jobsRepoProvider = Provider<JobsRepository>((ref) {
  DebugLogger.debug('🏗️ Creating JobsRepository provider');

  try {
    final repo = JobsRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    );
    DebugLogger.debug('✅ JobsRepository provider created successfully');
    return repo;
  } catch (e, stackTrace) {
    DebugLogger.error('❌ Error creating JobsRepository', e, stackTrace);
    rethrow;
  }
});

class JobsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;

  JobsRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    FirebaseFunctions? functions,
  }) : _firestore = firestore,
       _auth = auth,
       _functions =
           functions ?? FirebaseFunctions.instanceFor(region: 'europe-west1') {
    final constructorLog = <String, Object?>{'functionsRegion': 'europe-west1'};
    try {
      constructorLog['firestoreApp'] = firestore.app.name;
    } catch (_) {
      constructorLog['firestoreApp'] = 'unknown';
    }
    try {
      constructorLog['authApp'] = auth.app.name;
    } catch (_) {
      constructorLog['authApp'] = 'unknown';
    }
    DebugLogger.lifecycle('JobsRepository', 'constructor', constructorLog);
  }

  CollectionReference<Map<String, dynamic>> get _jobsCollection =>
      _firestore.collection('jobs');

  CollectionReference<Map<String, dynamic>> get _jobsPrivateCollection =>
      _firestore.collection('jobsPrivate');

  // Create a new job
  Future<String> createJob(Job job) async {
    DebugLogger.enter('JobsRepository.createJob', {
      'customerUid': job.customerUid,
      'sizeM2': job.sizeM2,
      'rooms': job.rooms,
      'services': job.services,
      'budget': job.budget,
      'category': job.category.name,
      'baseHours': job.baseHours,
    });
    DebugLogger.startTimer('createJob');

    final user = _auth.currentUser;
    if (user == null) {
      DebugLogger.error('❌ User not authenticated for job creation');
      throw Exception('User not authenticated');
    }

    DebugLogger.debug('👤 Authenticated user creating job', {
      'uid': user.uid,
      'email': user.email,
    });

    try {
      final jobData = job.copyWith(
        customerUid: user.uid,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final estimatedMinutes = ((jobData.baseHours + jobData.extrasHours) * 60)
          .round();
      final jobJson = jobData.toJson()
        ..['window'] = jobData.window.toJson()
        ..['estimatedDurationMinutes'] = estimatedMinutes
        ..['totalHours'] = double.parse(
          (jobData.baseHours + jobData.extrasHours).toStringAsFixed(2),
        )
        ..['materialFeeApplied'] = jobData.materialFeeEur > 0
        ..['expressMultiplier'] = jobData.isExpress ? 1.2 : 1.0;

      DebugLogger.debug('📝 Job data prepared for creation', {
        'customerUid': jobData.customerUid,
        'budget': jobData.budget,
        'category': jobData.category.name,
        'servicesCount': jobData.services.length,
        'hasNotes': jobData.notes.isNotEmpty,
        'estimatedMinutes': estimatedMinutes,
        'totalHours': jobData.baseHours + jobData.extrasHours,
        'materialFeeEur': jobData.materialFeeEur,
        'isExpress': jobData.isExpress,
      });

      DebugLogger.database('create', 'jobs', {
        'customerUid': user.uid,
        'sizeM2': job.sizeM2,
        'rooms': job.rooms,
        'budget': job.budget,
      });

      final docRef = await _jobsCollection.add(jobJson);

      DebugLogger.debug('✅ Job created successfully', {
        'jobId': docRef.id,
        'customerId': user.uid,
      });

      final duration = DebugLogger.stopTimer('createJob');
      DebugLogger.performance('createJob', duration!);
      DebugLogger.exit('JobsRepository.createJob', docRef.id);

      return docRef.id;
    } catch (e, stackTrace) {
      DebugLogger.error('❌ Error creating job', e, stackTrace);
      DebugLogger.stopTimer('createJob');
      DebugLogger.exit('JobsRepository.createJob', 'error');
      rethrow;
    }
  }

  // Get jobs for current user
  Stream<List<Job>> getUserJobs() {
    DebugLogger.enter('JobsRepository.getUserJobs');

    final user = _auth.currentUser;
    if (user == null) {
      DebugLogger.warning('⚠️ No authenticated user for getUserJobs');
      DebugLogger.exit('JobsRepository.getUserJobs', 'empty-no-auth');
      return Stream.value([]);
    }

    DebugLogger.debug('👤 Getting jobs for user', {
      'uid': user.uid,
      'email': user.email,
    });

    DebugLogger.database('query', 'jobs', {
      'customerUid': user.uid,
      'orderBy': 'createdAt',
      'descending': true,
    });

    return _jobsCollection
        .where('customerUid', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          DebugLogger.debug('📊 Jobs query result', {
            'docsCount': snapshot.docs.length,
            'hasChanges': snapshot.metadata.hasPendingWrites,
            'fromCache': snapshot.metadata.isFromCache,
          });

          final jobs = snapshot.docs
              .map((doc) {
                try {
                  final jobData = {...doc.data(), 'id': doc.id};
                  DebugLogger.debug('📄 Processing job document', {
                    'docId': doc.id,
                    'hasId': jobData.containsKey('id'),
                    'hasCustomerUid': jobData.containsKey('customerUid'),
                    'hasStatus': jobData.containsKey('status'),
                  });
                  return Job.fromJson(jobData);
                } catch (e, stackTrace) {
                  DebugLogger.error(
                    '❌ Error parsing job document: docId=${doc.id}',
                    e,
                    stackTrace,
                  );
                  return null;
                }
              })
              .whereType<Job>()
              .toList();

          DebugLogger.debug('✅ Successfully parsed jobs', {
            'totalJobs': jobs.length,
            'userUid': user.uid,
          });

          return jobs;
        });
  }

  // Get a specific job by ID
  Future<Job?> getJob(String jobId) async {
    DebugLogger.enter('JobsRepository.getJob', {'jobId': jobId});
    DebugLogger.startTimer('getJob');

    try {
      DebugLogger.database('read', 'jobs', {'docId': jobId});

      final doc = await _jobsCollection.doc(jobId).get();

      if (!doc.exists) {
        DebugLogger.warning('⚠️ Job document not found', {'jobId': jobId});
        DebugLogger.stopTimer('getJob');
        DebugLogger.exit('JobsRepository.getJob', 'null-not-found');
        return null;
      }

      DebugLogger.debug('📄 Job document found', {
        'jobId': jobId,
        'hasData': doc.data() != null,
        'fromCache': doc.metadata.isFromCache,
      });

      final jobData = {...doc.data()!, 'id': doc.id};
      final job = Job.fromJson(jobData);

      DebugLogger.debug('✅ Job parsed successfully', {
        'jobId': job.id,
        'customerUid': job.customerUid,
        'status': job.status.name,
        'category': job.category.name,
      });

      final duration = DebugLogger.stopTimer('getJob');
      DebugLogger.performance('getJob', duration!);
      DebugLogger.exit('JobsRepository.getJob', job.id);

      return job;
    } catch (e, stackTrace) {
      DebugLogger.error('❌ Error getting job: jobId=$jobId', e, stackTrace);
      DebugLogger.stopTimer('getJob');
      DebugLogger.exit('JobsRepository.getJob', 'error');
      rethrow;
    }
  }

  // Get job stream by ID
  Stream<Job?> getJobStream(String jobId) {
    DebugLogger.enter('JobsRepository.getJobStream', {'jobId': jobId});

    DebugLogger.database('stream', 'jobs', {'docId': jobId});

    return _jobsCollection.doc(jobId).snapshots().map((doc) {
      DebugLogger.debug('📡 Job stream snapshot received', {
        'jobId': jobId,
        'exists': doc.exists,
        'hasData': doc.data() != null,
        'fromCache': doc.metadata.isFromCache,
        'hasPendingWrites': doc.metadata.hasPendingWrites,
      });

      if (!doc.exists) {
        DebugLogger.warning('⚠️ Job stream: document not found', {
          'jobId': jobId,
        });
        return null;
      }

      try {
        final jobData = {...doc.data()!, 'id': doc.id};
        final job = Job.fromJson(jobData);

        DebugLogger.debug('✅ Job stream: data parsed successfully', {
          'jobId': job.id,
          'status': job.status.name,
          'updatedAt': job.updatedAt?.toIso8601String(),
        });

        return job;
      } catch (e, stackTrace) {
        DebugLogger.error(
          '❌ Job stream: error parsing data for jobId=$jobId',
          e,
          stackTrace,
        );
        return null;
      }
    });
  }

  // Update job (limited fields only - status changes happen via Cloud Functions)
  Future<void> updateJob(String jobId, Map<String, dynamic> updates) async {
    DebugLogger.enter('JobsRepository.updateJob', {
      'jobId': jobId,
      'updatesCount': updates.length,
      'updateFields': updates.keys.toList(),
    });
    DebugLogger.startTimer('updateJob');

    final user = _auth.currentUser;
    if (user == null) {
      DebugLogger.error('❌ User not authenticated for job update');
      DebugLogger.stopTimer('updateJob');
      DebugLogger.exit('JobsRepository.updateJob', 'error-no-auth');
      throw Exception('User not authenticated');
    }

    DebugLogger.debug('👤 Authenticated user updating job', {
      'uid': user.uid,
      'email': user.email,
      'jobId': jobId,
    });

    // Only allow updates to specific fields
    final allowedFields = {
      'notes',
      'budget',
      'services',
      'window',
      'sizeM2',
      'rooms',
    };

    DebugLogger.debug('🔐 Filtering update fields', {
      'allowedFields': allowedFields.toList(),
      'requestedFields': updates.keys.toList(),
    });

    final filteredUpdates = <String, dynamic>{};

    for (final entry in updates.entries) {
      if (allowedFields.contains(entry.key)) {
        filteredUpdates[entry.key] = entry.value;
        DebugLogger.debug('✅ Field allowed for update', {
          'field': entry.key,
          'value': entry.value.toString(),
        });
      } else {
        DebugLogger.warning('⚠️ Field not allowed for update', {
          'field': entry.key,
          'value': entry.value.toString(),
        });
      }
    }

    if (filteredUpdates.isNotEmpty) {
      filteredUpdates['updatedAt'] = FieldValue.serverTimestamp();

      DebugLogger.debug('📝 Performing job update', {
        'jobId': jobId,
        'fieldsToUpdate': filteredUpdates.keys.toList(),
        'updateCount': filteredUpdates.length,
      });

      try {
        DebugLogger.database('update', 'jobs', {
          'docId': jobId,
          'fields': filteredUpdates.keys.toList(),
        });

        await _jobsCollection.doc(jobId).update(filteredUpdates);

        DebugLogger.debug('✅ Job updated successfully', {
          'jobId': jobId,
          'updatedFields': filteredUpdates.keys.toList(),
        });

        final duration = DebugLogger.stopTimer('updateJob');
        DebugLogger.performance('updateJob', duration!);
        DebugLogger.exit('JobsRepository.updateJob', 'success');
      } catch (e, stackTrace) {
        DebugLogger.error('❌ Error updating job: jobId=$jobId', e, stackTrace);
        DebugLogger.stopTimer('updateJob');
        DebugLogger.exit('JobsRepository.updateJob', 'error');
        rethrow;
      }
    } else {
      DebugLogger.warning('⚠️ No valid fields to update', {
        'jobId': jobId,
        'originalFieldCount': updates.length,
      });
      DebugLogger.stopTimer('updateJob');
      DebugLogger.exit('JobsRepository.updateJob', 'no-valid-fields');
    }
  }

  Future<void> markJobCompleted(String jobId) async {
    DebugLogger.enter('JobsRepository.markJobCompleted', {'jobId': jobId});
    DebugLogger.startTimer('markJobCompleted');

    try {
      DebugLogger.database('update', 'jobs', {
        'docId': jobId,
        'status': JobStatus.completed.name,
      });

      await _jobsCollection.doc(jobId).update({
        'status': JobStatus.completed.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      DebugLogger.debug('✅ Job marked as completed', {'jobId': jobId});
      final duration = DebugLogger.stopTimer('markJobCompleted');
      if (duration != null) {
        DebugLogger.performance('markJobCompleted', duration);
      }
      DebugLogger.exit('JobsRepository.markJobCompleted', 'success');
    } catch (error, stackTrace) {
      DebugLogger.error(
        '❌ Error marking job completed: jobId=$jobId',
        error,
        stackTrace,
      );
      DebugLogger.stopTimer('markJobCompleted');
      DebugLogger.exit('JobsRepository.markJobCompleted', 'error');
      rethrow;
    }
  }

  // Get open jobs for pro feed (jobs that are open and not created by current user)
  Stream<List<Job>> getOpenJobs() {
    DebugLogger.enter('JobsRepository.getOpenJobs');

    final user = _auth.currentUser;
    if (user == null) {
      DebugLogger.warning('⚠️ No authenticated user for getOpenJobs');
      DebugLogger.exit('JobsRepository.getOpenJobs', 'empty-no-auth');
      return Stream.value([]);
    }

    DebugLogger.debug('👤 Getting open jobs for pro feed', {
      'uid': user.uid,
      'email': user.email,
    });

    DebugLogger.database('query', 'jobs', {
      'status': 'open',
      'orderBy': 'createdAt',
      'descending': true,
      'excludeCustomerUid': user.uid,
    });

    return _jobsCollection
        .where('status', isEqualTo: 'open')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          DebugLogger.debug('📊 Open jobs query result', {
            'totalDocs': snapshot.docs.length,
            'hasChanges': snapshot.metadata.hasPendingWrites,
            'fromCache': snapshot.metadata.isFromCache,
          });

          final jobs = snapshot.docs
              .map((doc) {
                try {
                  final jobData = {...doc.data(), 'id': doc.id};
                  final job = Job.fromJson(jobData);

                  // In development mode, include mock data
                  if (Environment.isDevelopment) {
                    DebugLogger.debug('🎭 Development mode: including job', {
                      'jobId': job.id,
                      'isMock': jobData['isMockData'] ?? false,
                    });
                    return job;
                  }

                  // In production, exclude mock data
                  if (jobData['isMockData'] == true) {
                    DebugLogger.debug('🚫 Excluding mock data in production', {
                      'jobId': job.id,
                    });
                    return null;
                  }

                  return job;
                } catch (e, stackTrace) {
                  DebugLogger.error(
                    '❌ Error parsing open job document: docId=${doc.id}',
                    e,
                    stackTrace,
                  );
                  return null;
                }
              })
              .whereType<Job>()
              .toList();

          final ownJobsCount = jobs
              .where((job) => job.customerUid == user.uid)
              .length;
          if (ownJobsCount > 0) {
            DebugLogger.debug('ℹ️ Including own jobs in feed for visibility', {
              'ownJobsCount': ownJobsCount,
              'userUid': user.uid,
            });
          }

          DebugLogger.debug('✅ Open jobs filtered successfully', {
            'totalOpenJobs': jobs.length,
            'ownJobsVisible': ownJobsCount,
            'userUid': user.uid,
          });

          return jobs;
        });
  }

  // Get jobs visible to current pro
  Stream<List<Job>> getVisibleJobs() {
    DebugLogger.enter('JobsRepository.getVisibleJobs');

    final user = _auth.currentUser;
    if (user == null) {
      DebugLogger.warning('⚠️ No authenticated user for getVisibleJobs');
      DebugLogger.exit('JobsRepository.getVisibleJobs', 'empty-no-auth');
      return Stream.value([]);
    }

    DebugLogger.debug('👤 Getting visible jobs for pro', {
      'uid': user.uid,
      'email': user.email,
    });

    DebugLogger.database('query', 'jobs', {
      'visibleTo': 'array-contains:${user.uid}',
      'orderBy': 'createdAt',
      'descending': true,
    });

    return _jobsCollection
        .where('visibleTo', arrayContains: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          DebugLogger.debug('📊 Visible jobs query result', {
            'docsCount': snapshot.docs.length,
            'hasChanges': snapshot.metadata.hasPendingWrites,
            'fromCache': snapshot.metadata.isFromCache,
          });

          final jobs = snapshot.docs
              .map((doc) {
                try {
                  final jobData = {...doc.data(), 'id': doc.id};
                  return Job.fromJson(jobData);
                } catch (e, stackTrace) {
                  DebugLogger.error(
                    '❌ Error parsing visible job document: docId=${doc.id}',
                    e,
                    stackTrace,
                  );
                  return null;
                }
              })
              .whereType<Job>()
              .toList();

          DebugLogger.debug('✅ Visible jobs parsed successfully', {
            'totalJobs': jobs.length,
            'userUid': user.uid,
          });

          return jobs;
        });
  }

  // PG-14: Set job address via Cloud Function (geocoding)
  Future<Map<String, dynamic>> setJobAddress({
    required String jobId,
    required String addressText,
    String? entranceNotes,
  }) async {
    DebugLogger.enter('JobsRepository.setJobAddress', {
      'jobId': jobId,
      'addressText': addressText,
      'hasEntranceNotes': entranceNotes?.isNotEmpty == true,
    });
    DebugLogger.startTimer('setJobAddress');

    final user = _auth.currentUser;
    if (user == null) {
      DebugLogger.error('❌ User not authenticated for setJobAddress');
      DebugLogger.stopTimer('setJobAddress');
      DebugLogger.exit('JobsRepository.setJobAddress', 'error-no-auth');
      throw Exception('User not authenticated');
    }

    DebugLogger.debug('👤 Setting job address via Cloud Function', {
      'uid': user.uid,
      'jobId': jobId,
      'addressLength': addressText.length,
    });

    final callable = _functions.httpsCallable('setJobAddressCF');

    try {
      DebugLogger.debug('☁️ Calling Cloud Function: setJobAddressCF', {
        'jobId': jobId,
        'addressText':
            '${addressText.substring(0, math.min(50, addressText.length))}...',
      });

      final result = await callable.call({
        'jobId': jobId,
        'addressText': addressText,
        'entranceNotes': entranceNotes,
      });

      final responseData = result.data;
      Map<String, dynamic> payload;

      if (responseData is Map<String, dynamic>) {
        payload = responseData;
      } else if (responseData is Map) {
        payload = Map<String, dynamic>.from(responseData);
      } else {
        throw StateError('Unexpected response type from setJobAddressCF');
      }

      DebugLogger.debug('✅ Job address set successfully', {
        'jobId': jobId,
        'resultData': payload.toString().substring(
          0,
          math.min(100, payload.toString().length),
        ),
      });

      final duration = DebugLogger.stopTimer('setJobAddress');
      DebugLogger.performance('setJobAddress', duration!);
      DebugLogger.exit('JobsRepository.setJobAddress', 'success');

      return payload;
    } catch (e, stackTrace) {
      DebugLogger.error(
        '❌ Error setting job address via Cloud Function',
        e,
        stackTrace,
      );
      DebugLogger.stopTimer('setJobAddress');
      DebugLogger.exit('JobsRepository.setJobAddress', 'error');
      rethrow;
    }
  }

  // PG-14: Get private job location (only for authorized users)
  Future<JobPrivate?> getJobPrivate(String jobId) async {
    DebugLogger.enter('JobsRepository.getJobPrivate', {'jobId': jobId});
    DebugLogger.startTimer('getJobPrivate');

    final user = _auth.currentUser;
    if (user == null) {
      DebugLogger.error('❌ User not authenticated for getJobPrivate');
      DebugLogger.stopTimer('getJobPrivate');
      DebugLogger.exit('JobsRepository.getJobPrivate', 'error-no-auth');
      throw Exception('User not authenticated');
    }

    DebugLogger.debug('👤 Getting private job data', {
      'uid': user.uid,
      'jobId': jobId,
    });

    try {
      DebugLogger.database('read', 'jobsPrivate', {'docId': jobId});

      final doc = await _jobsPrivateCollection.doc(jobId).get();

      if (!doc.exists) {
        DebugLogger.warning('⚠️ Private job document not found', {
          'jobId': jobId,
        });
        DebugLogger.stopTimer('getJobPrivate');
        DebugLogger.exit('JobsRepository.getJobPrivate', 'null-not-found');
        return null;
      }

      DebugLogger.debug('📄 Private job document found', {
        'jobId': jobId,
        'hasData': doc.data() != null,
        'fromCache': doc.metadata.isFromCache,
      });

      final jobPrivateData = {...doc.data()!, 'jobId': doc.id};
      final jobPrivate = JobPrivate.fromJson(jobPrivateData);

      DebugLogger.debug('✅ Private job data parsed successfully', {
        'jobId': jobPrivate.jobId,
        'hasAddressText': jobPrivate.addressText.isNotEmpty,
        'locationLat': jobPrivate.location.lat,
        'locationLng': jobPrivate.location.lng,
        'hasEntranceNotes': jobPrivate.entranceNotes?.isNotEmpty == true,
      });

      final duration = DebugLogger.stopTimer('getJobPrivate');
      DebugLogger.performance('getJobPrivate', duration!);
      DebugLogger.exit('JobsRepository.getJobPrivate', jobPrivate.jobId);

      return jobPrivate;
    } catch (e, stackTrace) {
      DebugLogger.error(
        '❌ Error getting private job data: jobId=$jobId',
        e,
        stackTrace,
      );
      DebugLogger.stopTimer('getJobPrivate');
      DebugLogger.exit('JobsRepository.getJobPrivate', 'error');
      // Access denied or job doesn't exist
      return null;
    }
  }

  // PG-14: Stream private job location
  Stream<JobPrivate?> getJobPrivateStream(String jobId) {
    DebugLogger.enter('JobsRepository.getJobPrivateStream', {'jobId': jobId});

    final user = _auth.currentUser;
    if (user == null) {
      DebugLogger.warning('⚠️ No authenticated user for getJobPrivateStream');
      DebugLogger.exit('JobsRepository.getJobPrivateStream', 'empty-no-auth');
      return Stream.value(null);
    }

    DebugLogger.debug('👤 Starting private job stream', {
      'uid': user.uid,
      'jobId': jobId,
    });

    DebugLogger.database('stream', 'jobsPrivate', {'docId': jobId});

    return _jobsPrivateCollection.doc(jobId).snapshots().map((doc) {
      DebugLogger.debug('📡 Private job stream snapshot received', {
        'jobId': jobId,
        'exists': doc.exists,
        'hasData': doc.data() != null,
        'fromCache': doc.metadata.isFromCache,
        'hasPendingWrites': doc.metadata.hasPendingWrites,
      });

      if (!doc.exists) {
        DebugLogger.warning('⚠️ Private job stream: document not found', {
          'jobId': jobId,
        });
        return null;
      }

      try {
        final jobPrivateData = {...doc.data()!, 'jobId': doc.id};
        final jobPrivate = JobPrivate.fromJson(jobPrivateData);

        DebugLogger.debug('✅ Private job stream: data parsed successfully', {
          'jobId': jobPrivate.jobId,
          'addressText': jobPrivate.addressText.substring(
            0,
            math.min(30, jobPrivate.addressText.length),
          ),
          'updatedAt': jobPrivate.updatedAt?.toIso8601String(),
        });

        return jobPrivate;
      } catch (e, stackTrace) {
        DebugLogger.error(
          '❌ Private job stream: error parsing data for jobId=$jobId',
          e,
          stackTrace,
        );
        return null;
      }
    });
  }

  // PG-14: Calculate ETA using Cloud Function
  Future<Map<String, dynamic>> getEta(String jobId) async {
    DebugLogger.enter('JobsRepository.getEta', {'jobId': jobId});
    DebugLogger.startTimer('getEta');

    final user = _auth.currentUser;
    if (user == null) {
      DebugLogger.error('❌ User not authenticated for getEta');
      DebugLogger.stopTimer('getEta');
      DebugLogger.exit('JobsRepository.getEta', 'error-no-auth');
      throw Exception('User not authenticated');
    }

    DebugLogger.debug('👤 Calculating ETA via Cloud Function', {
      'uid': user.uid,
      'jobId': jobId,
    });

    try {
      DebugLogger.debug('☁️ Calling Cloud Function: getEtaCF', {
        'jobId': jobId,
      });

      final callable = FirebaseFunctions.instance.httpsCallable('getEtaCF');
      final result = await callable.call({'jobId': jobId});

      final etaData = Map<String, dynamic>.from(result.data);

      DebugLogger.debug('✅ ETA calculated successfully', {
        'jobId': jobId,
        'hasDistance': etaData.containsKey('distance'),
        'hasDuration': etaData.containsKey('duration'),
        'resultKeys': etaData.keys.toList(),
      });

      final duration = DebugLogger.stopTimer('getEta');
      DebugLogger.performance('getEta', duration!);
      DebugLogger.exit('JobsRepository.getEta', 'success');

      return etaData;
    } catch (e, stackTrace) {
      DebugLogger.error(
        '❌ Error calculating ETA for jobId=$jobId',
        e,
        stackTrace,
      );
      DebugLogger.stopTimer('getEta');
      DebugLogger.exit('JobsRepository.getEta', 'error');
      rethrow;
    }
  }

  // PG-16: Calculate ETA from specific coordinates (for live location)
  Future<Map<String, dynamic>> getEtaFromCoordinates(
    String jobId,
    double proLat,
    double proLng,
  ) async {
    DebugLogger.enter('JobsRepository.getEtaFromCoordinates', {
      'jobId': jobId,
      'proLat': proLat,
      'proLng': proLng,
    });
    DebugLogger.startTimer('getEtaFromCoordinates');

    final user = _auth.currentUser;
    if (user == null) {
      DebugLogger.error('❌ User not authenticated for getEtaFromCoordinates');
      DebugLogger.stopTimer('getEtaFromCoordinates');
      DebugLogger.exit('JobsRepository.getEtaFromCoordinates', 'error-no-auth');
      throw Exception('User not authenticated');
    }

    DebugLogger.debug(
      '👤 Calculating ETA from coordinates via Cloud Function',
      {'uid': user.uid, 'jobId': jobId, 'fromCoordinates': '$proLat,$proLng'},
    );

    try {
      DebugLogger.debug(
        '☁️ Calling Cloud Function: getEtaCF with coordinates',
        {'jobId': jobId, 'proLat': proLat, 'proLng': proLng},
      );

      final callable = FirebaseFunctions.instance.httpsCallable('getEtaCF');
      final result = await callable.call({
        'jobId': jobId,
        'proLat': proLat,
        'proLng': proLng,
      });

      final etaData = Map<String, dynamic>.from(result.data);

      DebugLogger.debug('✅ ETA from coordinates calculated successfully', {
        'jobId': jobId,
        'fromCoordinates': '$proLat,$proLng',
        'hasDistance': etaData.containsKey('distance'),
        'hasDuration': etaData.containsKey('duration'),
        'resultKeys': etaData.keys.toList(),
      });

      final duration = DebugLogger.stopTimer('getEtaFromCoordinates');
      DebugLogger.performance('getEtaFromCoordinates', duration!);
      DebugLogger.exit('JobsRepository.getEtaFromCoordinates', 'success');

      return etaData;
    } catch (e, stackTrace) {
      DebugLogger.error(
        '❌ Error calculating ETA from coordinates for jobId=$jobId',
        e,
        stackTrace,
      );
      DebugLogger.stopTimer('getEtaFromCoordinates');
      DebugLogger.exit('JobsRepository.getEtaFromCoordinates', 'error');
      rethrow;
    }
  }
}
