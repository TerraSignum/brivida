import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../config/environment.dart';
import '../utils/debug_logger.dart';

class MockDataService {
  static FirebaseFirestore? _firestoreOverride;
  static FirebaseAuth? _authOverride;
  static Timer? _liveLocationTimer;
  static int _liveLocationTick = 0;

  static FirebaseFirestore get _firestore =>
      _firestoreOverride ?? FirebaseFirestore.instance;
  static FirebaseAuth get _auth => _authOverride ?? FirebaseAuth.instance;

  @visibleForTesting
  static void configureForTesting({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) {
    _firestoreOverride = firestore;
    _authOverride = auth;
  }

  @visibleForTesting
  static void resetTestOverrides() {
    _firestoreOverride = null;
    _authOverride = null;
    _stopLiveLocationSimulation();
  }

  /// Initializes mock data only in development mode
  static Future<void> initializeMockData({
    bool force = false,
    bool enableLiveLocationSimulation = false,
  }) async {
    if (!force && !Environment.allowMockData) {
      DebugLogger.debug(
        '🚫 MOCK: Skipping mock data - enable USE_FIREBASE_EMULATORS for debug seeding',
      );
      return;
    }

    // Check if user is authenticated - if not, mock data creation will fail
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      DebugLogger.debug(
        '🔐 MOCK: No authenticated user, skipping mock data creation (will be called again after auth)',
      );
      return;
    }

    DebugLogger.debug('🎭 MOCK: Initializing mock data for development...', {
      'uid': currentUser.uid,
      'email': currentUser.email,
    });

    try {
      // Check if mock data already exists
      final mockJobsQuery = await _firestore
          .collection('jobs')
          .where('isMockData', isEqualTo: true)
          .limit(1)
          .get();

      final mockDataExists = mockJobsQuery.docs.isNotEmpty;

      if (mockDataExists) {
        DebugLogger.debug('🎭 MOCK: Mock data already exists, skipping...');
        if (enableLiveLocationSimulation &&
            (force || Environment.allowMockData)) {
          await _prepareLiveLocationSimulation(force: force);
        }
        return;
      }

      // Create mock data with current user as base
      await _createMockJobs();
      await _createMockLeads();
      await _createMockCalendarEvents();

      DebugLogger.debug('✅ MOCK: Mock data initialization completed');

      if (enableLiveLocationSimulation &&
          (force || Environment.allowMockData)) {
        await _prepareLiveLocationSimulation(force: force);
      }
    } catch (e, stackTrace) {
      DebugLogger.error(
        '❌ MOCK: Failed to initialize mock data: $e',
        e,
        stackTrace,
      );
      // Don't rethrow - app should continue working
    }
  }

  /// Creates mock jobs for testing
  static Future<void> _createMockJobs() async {
    final currentUser = _auth.currentUser!; // We know user is authenticated
    DebugLogger.debug('🎭 MOCK: Creating mock jobs...');

    final mockJobs = [
      {
        'id': 'mock_job_001',
        'customerUid': currentUser.uid, // Use real user ID
        'customerName': currentUser.displayName ?? 'Test User',
        'customerEmail': currentUser.email ?? 'test@example.com',
        'title': 'Wöchentliche Hausreinigung',
        'description':
            'Komplette Reinigung einer 3-Zimmer-Wohnung inklusive Bad und Küche',
        'location': {
          'address': 'Musterstraße 123, 10115 Berlin',
          'lat': 52.520008,
          'lng': 13.404954,
        },
        'serviceType': 'weekly_cleaning',
        'roomCount': 3,
        'squareMeters': 85.0,
        'budget': {'min': 45.0, 'max': 65.0, 'currency': 'EUR'},
        'preferredDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 3)),
        ),
        'timeSlot': 'morning',
        'urgency': 'normal',
        'status': 'open',
        'payment_status': 'pending',
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
        'isMockData': true,
        'requirements': ['pet_friendly', 'own_supplies'],
        'imageUrls': [],
      },
      {
        'id': 'mock_job_002',
        'customerUid': 'mock_customer_002',
        'customerName': 'Max Weber',
        'customerEmail': 'max.weber@example.com',
        'title': 'Büroreinigung nach Umzug',
        'description': 'Grundreinigung eines kleinen Büros nach dem Umzug',
        'location': {
          'address': 'Alexanderplatz 1, 10178 Berlin',
          'lat': 52.521918,
          'lng': 13.413215,
        },
        'serviceType': 'deep_cleaning',
        'roomCount': 2,
        'squareMeters': 40.0,
        'budget': {'min': 80.0, 'max': 120.0, 'currency': 'EUR'},
        'preferredDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 1)),
        ),
        'timeSlot': 'afternoon',
        'urgency': 'urgent',
        'status': 'open',
        'payment_status': 'pending',
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
        'isMockData': true,
        'requirements': ['flexible_timing'],
        'imageUrls': [],
      },
      {
        'id': 'mock_job_003',
        'customerUid': 'mock_customer_003',
        'customerName': 'Sarah Klein',
        'customerEmail': 'sarah.klein@example.com',
        'title': 'Fensterreinigung Einfamilienhaus',
        'description':
            'Außen- und Innenreinigung aller Fenster im Einfamilienhaus',
        'location': {
          'address': 'Gartenstraße 45, 10115 Berlin',
          'lat': 52.525589,
          'lng': 13.389234,
        },
        'serviceType': 'window_cleaning',
        'roomCount': 5,
        'squareMeters': 120.0,
        'budget': {'min': 60.0, 'max': 90.0, 'currency': 'EUR'},
        'preferredDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 7)),
        ),
        'timeSlot': 'morning',
        'urgency': 'normal',
        'status': 'in_progress',
        'payment_status': 'paid',
        'created_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 2)),
        ),
        'updated_at': Timestamp.now(),
        'isMockData': true,
        'requirements': ['ladder_provided'],
        'imageUrls': [],
        'assignedProUid': 'mock_pro_001',
      },
    ];

    for (final job in mockJobs) {
      await _firestore.collection('jobs').doc(job['id'] as String).set(job);
      DebugLogger.debug('🎭 MOCK: Created job: ${job['title']}');
    }
  }

  /// Creates mock leads for testing
  static Future<void> _createMockLeads() async {
    final currentUser = _auth.currentUser!; // We know user is authenticated
    DebugLogger.debug('🎭 MOCK: Creating mock leads...');

    final mockLeads = [
      {
        'id': 'mock_lead_001',
        'jobId': 'mock_job_001',
        'proUid': 'mock_pro_001',
        'proName': 'Maria Reinigungsservice',
        'proEmail': 'maria@reinigung-berlin.de',
        'customerUid': currentUser.uid, // Add customer reference
        'status': 'pending',
        'bidAmount': 55.0,
        'currency': 'EUR',
        'message':
            'Gerne übernehme ich Ihre wöchentliche Hausreinigung. Ich bringe alle Reinigungsmittel mit und bin sehr erfahren.',
        'estimatedDuration': 3.0, // hours
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
        'isMockData': true,
        'response_time': 15, // minutes
      },
      {
        'id': 'mock_lead_002',
        'jobId': 'mock_job_001',
        'proUid': 'mock_pro_002',
        'proName': 'Clean & Fresh GmbH',
        'proEmail': 'info@cleanfresh.de',
        'status': 'pending',
        'bidAmount': 48.0,
        'currency': 'EUR',
        'message':
            'Wir sind ein professionelles Reinigungsunternehmen mit 10 Jahren Erfahrung. Faire Preise, zuverlässiger Service.',
        'estimatedDuration': 2.5,
        'created_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        'updated_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        'isMockData': true,
        'response_time': 8,
      },
      {
        'id': 'mock_lead_003',
        'jobId': 'mock_job_002',
        'proUid': 'mock_pro_001',
        'proName': 'Maria Reinigungsservice',
        'proEmail': 'maria@reinigung-berlin.de',
        'status': 'accepted',
        'bidAmount': 95.0,
        'currency': 'EUR',
        'message':
            'Büroreinigungen sind meine Spezialität. Ich kann bereits morgen früh anfangen.',
        'estimatedDuration': 4.0,
        'created_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 2)),
        ),
        'updated_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 1)),
        ),
        'accepted_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 1)),
        ),
        'isMockData': true,
        'response_time': 5,
      },
      {
        'id': 'mock_lead_004',
        'jobId': 'mock_job_003',
        'proUid': 'mock_pro_003',
        'proName': 'Fenster-Profis Berlin',
        'proEmail': 'kontakt@fenster-profis.de',
        'status': 'accepted',
        'bidAmount': 75.0,
        'currency': 'EUR',
        'message':
            'Spezialist für Fensterreinigung. Eigene Ausrüstung und Versicherung vorhanden.',
        'estimatedDuration': 3.5,
        'created_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 2)),
        ),
        'updated_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 2)),
        ),
        'accepted_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 2)),
        ),
        'isMockData': true,
        'response_time': 12,
      },
    ];

    for (final lead in mockLeads) {
      await _firestore.collection('leads').doc(lead['id'] as String).set(lead);
      DebugLogger.debug('🎭 MOCK: Created lead from ${lead['proName']}');
    }
  }

  /// Creates mock calendar events for testing
  static Future<void> _createMockCalendarEvents() async {
    final currentUser = _auth.currentUser!; // We know user is authenticated
    DebugLogger.debug('🎭 MOCK: Creating mock calendar events...');

    final mockEvents = [
      {
        'id': 'mock_event_001',
        'title': 'Büroreinigung - ${currentUser.displayName ?? 'Test User'}',
        'description': 'Mock calendar event for testing - Alexanderplatz 1',
        'type': 'job_appointment',
        'jobId': 'mock_job_001', // Reference our mock job
        'leadId': 'mock_lead_001', // Reference our mock lead
        'customerUid': currentUser.uid, // Use real user ID
        'proUid': 'mock_pro_001',
        'startTime': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 1, hours: 9)),
        ),
        'endTime': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 1, hours: 13)),
        ),
        'location': {
          'address': 'Alexanderplatz 1, 10178 Berlin',
          'lat': 52.521918,
          'lng': 13.413215,
        },
        'status': 'confirmed',
        'created_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 1)),
        ),
        'updated_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(hours: 1)),
        ),
        'isMockData': true,
        'reminders': [30, 60], // minutes before
      },
      {
        'id': 'mock_event_002',
        'title': 'Fensterreinigung - Sarah Klein',
        'description': 'Außen- und Innenreinigung aller Fenster',
        'type': 'job_appointment',
        'jobId': 'mock_job_003',
        'leadId': 'mock_lead_004',
        'customerUid': 'mock_customer_003',
        'proUid': 'mock_pro_003',
        'startTime': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 7, hours: 8)),
        ),
        'endTime': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 7, hours: 11, minutes: 30)),
        ),
        'location': {
          'address': 'Gartenstraße 45, 10115 Berlin',
          'lat': 52.505189,
          'lng': 13.325133,
        },
        'status': 'confirmed',
        'created_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 2)),
        ),
        'updated_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 2)),
        ),
        'isMockData': true,
        'reminders': [30, 120],
      },
      {
        'id': 'mock_event_003',
        'title': 'Kundentermin - Beratung',
        'description': 'Beratungsgespräch für regelmäßige Reinigung',
        'type': 'consultation',
        'customerUid': 'mock_customer_001',
        'proUid': 'mock_pro_001',
        'startTime': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 2, hours: 15)),
        ),
        'endTime': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 2, hours: 16)),
        ),
        'location': {
          'address': 'Musterstraße 123, 10115 Berlin',
          'lat': 52.520008,
          'lng': 13.404954,
        },
        'status': 'confirmed',
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
        'isMockData': true,
        'reminders': [60],
      },
      {
        'id': 'mock_event_004',
        'title': 'Materialbestellung',
        'description': 'Einkauf neuer Reinigungsmittel',
        'type': 'personal_task',
        'proUid': 'mock_pro_001',
        'startTime': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 5, hours: 10)),
        ),
        'endTime': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 5, hours: 11)),
        ),
        'location': {
          'address': 'Baumarkt XY, Spandauer Str. 25, 10178 Berlin',
          'lat': 52.530644,
          'lng': 13.384002,
        },
        'status': 'pending',
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
        'isMockData': true,
        'reminders': [30],
      },
    ];

    for (final event in mockEvents) {
      await _firestore
          .collection('calendarEvents')
          .doc(event['id'] as String)
          .set(event);
      DebugLogger.debug('🎭 MOCK: Created calendar event: ${event['title']}');
    }
  }

  static Future<void> _prepareLiveLocationSimulation({
    required bool force,
  }) async {
    _stopLiveLocationSimulation();
    await _seedLiveLocationDocuments();

    if (force) {
      return;
    }

    _startLiveLocationSimulation();
  }

  static Future<void> _seedLiveLocationDocuments() async {
    for (final track in _liveSimulationTracks.values) {
      track.reset();
      final point = track.nextPoint();
      await _writeLiveLocation(point, isInitialSeed: true);
    }
    _liveLocationTick = 0;
    DebugLogger.debug('📍 MOCK: Seeded live location documents for simulation');
  }

  static void _startLiveLocationSimulation() {
    if (_liveLocationTimer != null) {
      DebugLogger.debug('📍 MOCK: Live location simulation already running');
      return;
    }

    DebugLogger.debug('📍 MOCK: Starting live location simulation timer');
    _liveLocationTimer = Timer.periodic(_LiveLocationTrack.defaultInterval, (
      _,
    ) async {
      _liveLocationTick++;
      await _advanceLiveLocationSimulation();
    });
  }

  static Future<void> _advanceLiveLocationSimulation() async {
    for (final track in _liveSimulationTracks.values) {
      final point = track.nextPoint();
      await _writeLiveLocation(point);
    }
  }

  static void _stopLiveLocationSimulation() {
    if (_liveLocationTimer != null) {
      DebugLogger.debug('📍 MOCK: Stopping live location simulation');
      _liveLocationTimer?.cancel();
      _liveLocationTimer = null;
    }
    _resetLiveLocationSimulation();
  }

  static void _resetLiveLocationSimulation() {
    for (final track in _liveSimulationTracks.values) {
      track.reset();
    }
    _liveLocationTick = 0;
  }

  static Future<void> _writeLiveLocation(
    _SimulatedLocationPoint point, {
    bool isInitialSeed = false,
  }) async {
    final data = {
      'lat': point.lat,
      'lng': point.lng,
      'accuracy': point.accuracy,
      if (point.heading != null) 'heading': point.heading,
      'updatedAt': FieldValue.serverTimestamp(),
      'isMockData': true,
      'source': 'simulated',
    };

    await _firestore
        .collection('liveLocations')
        .doc(point.jobId)
        .collection('pros')
        .doc(point.proUid)
        .set(data, SetOptions(merge: true));

    DebugLogger.debug(
      isInitialSeed
          ? '📍 MOCK: Seeded live location for ${point.proUid} (${point.jobId}) at ${point.lat}, ${point.lng}'
          : '📍 MOCK: Updated live location for ${point.proUid} (${point.jobId}) → ${point.lat}, ${point.lng}',
      {'tick': _liveLocationTick},
    );
  }

  static Future<void> _clearLiveLocationDocuments() async {
    final futures = <Future<void>>[];
    for (final track in _liveSimulationTracks.values) {
      final docRef = _firestore
          .collection('liveLocations')
          .doc(track.jobId)
          .collection('pros')
          .doc(track.proUid);
      futures.add(docRef.delete());
    }
    await Future.wait(futures);
  }

  @visibleForTesting
  static Future<void> triggerLiveLocationSimulationStep() async {
    await _advanceLiveLocationSimulation();
  }

  @visibleForTesting
  static bool get isLiveLocationSimulationActive => _liveLocationTimer != null;

  static final Map<String, _LiveLocationTrack> _liveSimulationTracks = {
    'mock_job_002_mock_pro_001': _LiveLocationTrack(
      jobId: 'mock_job_002',
      proUid: 'mock_pro_001',
      points: const [
        _TrackCoordinate(
          lat: 52.521918,
          lng: 13.413215,
          accuracy: 7.5,
          heading: 85,
        ),
        _TrackCoordinate(
          lat: 52.522500,
          lng: 13.415200,
          accuracy: 7.5,
          heading: 95,
        ),
        _TrackCoordinate(
          lat: 52.523150,
          lng: 13.417450,
          accuracy: 7.5,
          heading: 102,
        ),
        _TrackCoordinate(
          lat: 52.522780,
          lng: 13.419610,
          accuracy: 8.0,
          heading: 130,
        ),
        _TrackCoordinate(
          lat: 52.521950,
          lng: 13.420980,
          accuracy: 8.0,
          heading: 170,
        ),
        _TrackCoordinate(
          lat: 52.520980,
          lng: 13.419420,
          accuracy: 6.0,
          heading: 220,
        ),
      ],
    ),
    'mock_job_003_mock_pro_003': _LiveLocationTrack(
      jobId: 'mock_job_003',
      proUid: 'mock_pro_003',
      points: const [
        _TrackCoordinate(
          lat: 52.525589,
          lng: 13.389234,
          accuracy: 6.5,
          heading: 45,
        ),
        _TrackCoordinate(
          lat: 52.526480,
          lng: 13.391050,
          accuracy: 6.5,
          heading: 80,
        ),
        _TrackCoordinate(
          lat: 52.527210,
          lng: 13.393330,
          accuracy: 6.5,
          heading: 118,
        ),
        _TrackCoordinate(
          lat: 52.526600,
          lng: 13.395520,
          accuracy: 7.0,
          heading: 165,
        ),
        _TrackCoordinate(
          lat: 52.525710,
          lng: 13.394100,
          accuracy: 7.0,
          heading: 220,
        ),
        _TrackCoordinate(
          lat: 52.524980,
          lng: 13.391900,
          accuracy: 7.0,
          heading: 265,
        ),
      ],
    ),
  };

  /// Creates mock pro profiles for testing
  static Future<void> createMockProProfiles() async {
    if (!Environment.allowMockData) return;

    // Firestore security rules require an authenticated user.
    if (_auth.currentUser == null) {
      DebugLogger.debug(
        '🔐 MOCK: No authenticated user, skipping pro profile creation',
      );
      return;
    }

    DebugLogger.debug('🎭 MOCK: Creating mock pro profiles...');

    final mockProfiles = [
      {
        'uid': 'mock_pro_001',
        'email': 'maria@reinigung-berlin.de',
        'displayName': 'Maria Reinigungsservice',
        'businessName': 'Marias Cleaning Service',
        'description':
            'Professionelle Reinigungskraft mit 8 Jahren Erfahrung. Zuverlässig, pünktlich und gründlich.',
        'location': {
          'address': 'Berlin Mitte',
          'lat': 52.520008,
          'lng': 13.404954,
        },
        'serviceRadius': 15.0, // km
        'hourlyRate': {'min': 15.0, 'max': 25.0, 'currency': 'EUR'},
        'services': ['house_cleaning', 'office_cleaning', 'deep_cleaning'],
        'availability': {
          'monday': ['09:00-17:00'],
          'tuesday': ['09:00-17:00'],
          'wednesday': ['09:00-17:00'],
          'thursday': ['09:00-17:00'],
          'friday': ['09:00-15:00'],
          'saturday': ['10:00-14:00'],
          'sunday': [],
        },
        'rating': 4.8,
        'reviewCount': 42,
        'completedJobs': 156,
        'responseRate': 95,
        'averageResponseTime': 12, // minutes
        'verified': true,
        'created_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 200)),
        ),
        'updated_at': Timestamp.now(),
        'isMockData': true,
        'languages': ['de', 'en'],
        'insuranceVerified': true,
        'backgroundCheckVerified': true,
      },
      {
        'uid': 'mock_pro_002',
        'email': 'info@cleanfresh.de',
        'displayName': 'Clean & Fresh GmbH',
        'businessName': 'Clean & Fresh Reinigungsservice',
        'description':
            'Professionelles Reinigungsunternehmen mit Team. Wir übernehmen Aufträge jeder Größe.',
        'location': {
          'address': 'Berlin Charlottenburg',
          'lat': 52.505189,
          'lng': 13.325133,
        },
        'serviceRadius': 25.0,
        'hourlyRate': {'min': 18.0, 'max': 30.0, 'currency': 'EUR'},
        'services': [
          'house_cleaning',
          'office_cleaning',
          'deep_cleaning',
          'construction_cleanup',
        ],
        'availability': {
          'monday': ['08:00-18:00'],
          'tuesday': ['08:00-18:00'],
          'wednesday': ['08:00-18:00'],
          'thursday': ['08:00-18:00'],
          'friday': ['08:00-18:00'],
          'saturday': ['09:00-15:00'],
          'sunday': [],
        },
        'rating': 4.6,
        'reviewCount': 78,
        'completedJobs': 234,
        'responseRate': 88,
        'averageResponseTime': 18,
        'verified': true,
        'created_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 365)),
        ),
        'updated_at': Timestamp.now(),
        'isMockData': true,
        'languages': ['de', 'en', 'pl'],
        'insuranceVerified': true,
        'backgroundCheckVerified': true,
      },
      {
        'uid': 'mock_pro_003',
        'email': 'kontakt@fenster-profis.de',
        'displayName': 'Fenster-Profis Berlin',
        'businessName': 'Fenster-Profis Berlin GmbH',
        'description':
            'Spezialisiert auf Fensterreinigung. Professionelle Ausrüstung und jahrelange Erfahrung.',
        'location': {
          'address': 'Berlin Prenzlauer Berg',
          'lat': 52.530644,
          'lng': 13.413215,
        },
        'serviceRadius': 20.0,
        'hourlyRate': {'min': 20.0, 'max': 35.0, 'currency': 'EUR'},
        'services': ['window_cleaning', 'facade_cleaning'],
        'availability': {
          'monday': ['07:00-16:00'],
          'tuesday': ['07:00-16:00'],
          'wednesday': ['07:00-16:00'],
          'thursday': ['07:00-16:00'],
          'friday': ['07:00-16:00'],
          'saturday': ['08:00-12:00'],
          'sunday': [],
        },
        'rating': 4.9,
        'reviewCount': 31,
        'completedJobs': 89,
        'responseRate': 92,
        'averageResponseTime': 25,
        'verified': true,
        'created_at': Timestamp.fromDate(
          DateTime.now().subtract(const Duration(days: 120)),
        ),
        'updated_at': Timestamp.now(),
        'isMockData': true,
        'languages': ['de'],
        'insuranceVerified': true,
        'backgroundCheckVerified': true,
      },
    ];

    for (final profile in mockProfiles) {
      await _firestore
          .collection('proProfiles')
          .doc(profile['uid'] as String)
          .set(profile);
      DebugLogger.debug(
        '🎭 MOCK: Created pro profile: ${profile['displayName']}',
      );
    }
  }

  /// Removes all mock data from Firestore
  static Future<void> clearMockData() async {
    if (!Environment.isDevelopment) {
      DebugLogger.debug(
        '🚫 MOCK: Cannot clear mock data - not in development mode',
      );
      return;
    }

    DebugLogger.debug('🗑️ MOCK: Clearing all mock data...');

    try {
      final collections = ['jobs', 'leads', 'calendarEvents', 'proProfiles'];

      for (final collection in collections) {
        final query = await _firestore
            .collection(collection)
            .where('isMockData', isEqualTo: true)
            .get();

        for (final doc in query.docs) {
          await doc.reference.delete();
          DebugLogger.debug('🗑️ MOCK: Deleted $collection/${doc.id}');
        }
      }

      await _clearLiveLocationDocuments();
      _stopLiveLocationSimulation();

      DebugLogger.debug('✅ MOCK: Mock data cleared successfully');
    } catch (e) {
      DebugLogger.error('❌ MOCK: Failed to clear mock data: $e');
    }
  }
}

class _LiveLocationTrack {
  _LiveLocationTrack({
    required this.jobId,
    required this.proUid,
    required this.points,
  });

  final String jobId;
  final String proUid;
  final List<_TrackCoordinate> points;

  static const Duration defaultInterval = Duration(seconds: 12);

  int _index = 0;

  _SimulatedLocationPoint nextPoint() {
    final coordinate = points[_index];
    _index = (_index + 1) % points.length;
    return _SimulatedLocationPoint(
      jobId: jobId,
      proUid: proUid,
      lat: coordinate.lat,
      lng: coordinate.lng,
      accuracy: coordinate.accuracy,
      heading: coordinate.heading,
    );
  }

  void reset() {
    _index = 0;
  }
}

class _TrackCoordinate {
  const _TrackCoordinate({
    required this.lat,
    required this.lng,
    this.accuracy = 6.0,
    this.heading,
  });

  final double lat;
  final double lng;
  final double accuracy;
  final double? heading;
}

class _SimulatedLocationPoint {
  const _SimulatedLocationPoint({
    required this.jobId,
    required this.proUid,
    required this.lat,
    required this.lng,
    this.accuracy = 6.0,
    this.heading,
  });

  final String jobId;
  final String proUid;
  final double lat;
  final double lng;
  final double accuracy;
  final double? heading;
}
