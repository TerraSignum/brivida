import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import '../services/cloud_function_names.dart';
import '../../core/config/environment.dart';
import '../../core/services/app_initialization_service.dart';
import '../../core/utils/debug_logger.dart';

/// Debug widget for managing mock data during development
/// Only visible in debug mode and development environment
class MockDataDebugWidget extends StatefulWidget {
  final Widget child;

  const MockDataDebugWidget({super.key, required this.child});

  @override
  State<MockDataDebugWidget> createState() => _MockDataDebugWidgetState();
}

class _MockDataDebugWidgetState extends State<MockDataDebugWidget> {
  bool _showDebugPanel = false;
  bool _isLoading = false;
  bool _isEtaLoading = false;
  bool _isPaymentLoading = false;
  String? _etaResultText;
  String? _etaCacheKey;
  String? _lastPiId;
  bool _isPushLoading = false;

  @override
  Widget build(BuildContext context) {
    // Only show in debug development builds where mock data is allowed
    if (!Environment.allowMockData) {
      return widget.child;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,

          // Debug toggle button (floating action button)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: FloatingActionButton.small(
              onPressed: () {
                setState(() {
                  _showDebugPanel = !_showDebugPanel;
                });
              },
              backgroundColor: Colors.red.withValues(alpha: 0.8),
              child: const Icon(
                Icons.bug_report,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          // Debug panel
          if (_showDebugPanel)
            Positioned(
              top: MediaQuery.of(context).padding.top + 70,
              right: 10,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.developer_mode,
                            color: Colors.red,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Mock Data Debug',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Environment info
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Environment',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Mode: ${Environment.current}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              'Debug: ${kDebugMode ? 'ON' : 'OFF'}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Mock data actions
                      const Text(
                        'Mock Data Actions',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Reinitialize button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _reinitializeMockData,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.refresh, size: 16),
                          label: const Text('Reinitialize'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Clear button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _clearMockData,
                          icon: const Icon(Icons.delete, size: 16),
                          label: const Text('Clear All'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Quick tests
                      const Text(
                        'Quick Tests',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ETA test
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isEtaLoading ? null : _testEta,
                          icon: _isEtaLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.directions_car, size: 16),
                          label: Text(
                            _isEtaLoading
                                ? 'Berechne ETA...'
                                : 'ETA Berlin Sample',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      if (_etaResultText != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                _etaResultText!,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                            if (_etaCacheKey != null)
                              IconButton(
                                tooltip: 'Copy cache key',
                                icon: const Icon(
                                  Icons.copy,
                                  size: 16,
                                  color: Colors.white70,
                                ),
                                onPressed: () =>
                                    _copyToClipboard(_etaCacheKey!),
                              ),
                          ],
                        ),
                        if (_etaCacheKey != null)
                          Text(
                            'cache: $_etaCacheKey',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],

                      const SizedBox(height: 8),

                      // Push test
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isPushLoading ? null : _testPush,
                          icon: _isPushLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.notifications_active,
                                  size: 16,
                                ),
                          label: Text(
                            _isPushLoading
                                ? 'Sende Push...'
                                : 'Push Test (Deeplink)',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // PaymentSheet test (mobile only)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isPaymentLoading || kIsWeb
                              ? null
                              : _testPaymentSheet,
                          icon: _isPaymentLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.payment, size: 16),
                          label: Text(
                            kIsWeb
                                ? 'PaymentSheet (nur Mobile)'
                                : (_isPaymentLoading
                                      ? 'Öffne PaymentSheet...'
                                      : 'PaymentSheet €0,50 Test'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Last PI info
                      if (_lastPiId != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.receipt_long,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'PI: $_lastPiId',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Copy PI id',
                              icon: const Icon(
                                Icons.copy,
                                size: 16,
                                color: Colors.white70,
                              ),
                              onPressed: () => _copyToClipboard(_lastPiId!),
                            ),
                          ],
                        ),

                      const SizedBox(height: 12),

                      // Warning
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.yellow.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.warning,
                                  color: Colors.yellow,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Development Only',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'This panel is only visible in debug mode. Mock data will not appear in production.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _reinitializeMockData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await AppInitializationService.reinitializeMockData();

      if (mounted) {
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('🎭 Mock data reinitialized successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          DebugLogger.debug('SNACK: Mock data reinitialized successfully');
        }
      }
    } catch (e) {
      DebugLogger.error('Failed to reinitialize mock data', e);
      if (mounted) {
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('❌ Failed to reinitialize mock data'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          DebugLogger.debug('SNACK: Failed to reinitialize mock data');
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _clearMockData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await AppInitializationService.clearMockData();

      if (mounted) {
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('🗑️ Mock data cleared successfully'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          DebugLogger.debug('SNACK: Mock data cleared successfully');
        }
      }
    } catch (e) {
      DebugLogger.error('Failed to clear mock data', e);
      if (mounted) {
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null) {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('❌ Failed to clear mock data'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          DebugLogger.debug('SNACK: Failed to clear mock data');
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _testEta() async {
    setState(() {
      _isEtaLoading = true;
      _etaResultText = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showSnack('Bitte zuerst anmelden');
        return;
      }

      final functions = FirebaseFunctions.instanceFor(region: 'europe-west1');
      final callable = functions.httpsCallable(CloudFunctionNames.eta);
      final origin = {'lat': 52.5200, 'lng': 13.4050};
      final destination = {'lat': 52.5000, 'lng': 13.3700};
      final result = await callable.call({
        'origin': origin,
        'destination': destination,
      });

      final data = result.data != null
          ? (result.data as Map).cast<String, dynamic>()
          : <String, dynamic>{};
      final minutes = data['minutes'];
      final fromCache = data['fromCache'] == true;
      setState(() {
        _etaResultText = 'ETA: $minutes min${fromCache ? ' (Cache)' : ''}';
        // Mirror backend key rounding (toFixed(3))
        final ok =
            '${(origin['lat'] as double).toStringAsFixed(3)},${(origin['lng'] as double).toStringAsFixed(3)}';
        final dk =
            '${(destination['lat'] as double).toStringAsFixed(3)},${(destination['lng'] as double).toStringAsFixed(3)}';
        _etaCacheKey = '$ok|$dk';
      });
    } catch (e, st) {
      DebugLogger.error('ETA test failed', e, st as StackTrace?);
      _showSnack('ETA fehlgeschlagen: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isEtaLoading = false;
        });
      }
    }
  }

  Future<void> _testPaymentSheet() async {
    setState(() {
      _isPaymentLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showSnack('Bitte zuerst anmelden');
        return;
      }
      if (kIsWeb) {
        _showSnack('PaymentSheet wird auf Web nicht unterstützt');
        return;
      }

      final functions = FirebaseFunctions.instanceFor(region: 'europe-west1');
      final createPi = functions.httpsCallable(
        CloudFunctionNames.createPaymentIntent,
      );
      const amount = 0.50; // EUR

      // Prefer existing mock job; if not allowed, create a user-owned test job on the fly
      String jobId = 'mock_job_001';
      Map<String, dynamic>? data;
      try {
        final res = await createPi.call({
          'jobId': jobId,
          'amount': amount,
          'currency': 'eur',
        });
        data = res.data != null
            ? (res.data as Map).cast<String, dynamic>()
            : <String, dynamic>{};
      } on FirebaseFunctionsException catch (fe) {
        DebugLogger.warning(
          'createPaymentIntent for mock_job_001 failed, trying fallback job',
          fe,
        );
        if (fe.code == 'permission-denied' ||
            fe.code == 'not-found' ||
            fe.code == 'invalid-argument') {
          // Ensure a minimal test job owned by the current user exists
          jobId = 'test_payment_${user.uid}';
          final jobs = FirebaseFirestore.instance.collection('jobs');
          final doc = await jobs.doc(jobId).get();
          if (!doc.exists) {
            await jobs.doc(jobId).set({
              'customerUid': user.uid,
              'title': 'Test Payment Job',
              'status': 'open',
              'created_at': FieldValue.serverTimestamp(),
              'updated_at': FieldValue.serverTimestamp(),
              'isMockData': true,
            });
          }
          // Retry with fallback job
          final res2 = await createPi.call({
            'jobId': jobId,
            'amount': amount,
            'currency': 'eur',
          });
          data = res2.data != null
              ? (res2.data as Map).cast<String, dynamic>()
              : <String, dynamic>{};
        } else {
          rethrow;
        }
      }

      final clientSecret = data['clientSecret'] as String?;
      if (clientSecret == null || clientSecret.isEmpty) {
        throw Exception('Kein clientSecret erhalten');
      }

      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          merchantDisplayName: 'Brivida Dev',
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.system,
        ),
      );
      await stripe.Stripe.instance.presentPaymentSheet();
      // Keep last PI id for quick reference
      setState(() {
        _lastPiId = data!['paymentIntentId'] as String?;
      });
      _showSnack('PaymentSheet abgeschlossen');
    } catch (e, st) {
      DebugLogger.error('PaymentSheet test failed', e, st as StackTrace?);
      _showSnack('Payment fehlgeschlagen/abgebrochen: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPaymentLoading = false;
        });
      }
    }
  }

  Future<void> _testPush() async {
    setState(() {
      _isPushLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showSnack('Bitte zuerst anmelden');
        return;
      }

      final functions = FirebaseFunctions.instanceFor(region: 'europe-west1');
      final callable = functions.httpsCallable('sendTestPush');
      await callable.call({'route': '/notifications', 'relatedId': 'debug'});
      _showSnack('Test-Push gesendet');
    } catch (e, st) {
      DebugLogger.error('Push test failed', e, st as StackTrace?);
      _showSnack('Push fehlgeschlagen: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPushLoading = false;
        });
      }
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null) {
      messenger.showSnackBar(SnackBar(content: Text(msg)));
    } else {
      DebugLogger.debug('SNACK: $msg');
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Copied to clipboard')),
      );
    } else {
      DebugLogger.debug('SNACK: Copied to clipboard');
    }
  }
}
