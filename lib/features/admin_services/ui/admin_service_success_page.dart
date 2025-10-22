import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brivida_app/features/analytics/data/analytics_service.dart';

import '../../../core/utils/debug_logger.dart';

/// PG-17/18: Success page after Stripe checkout completion for admin services
class AdminServiceSuccessPage extends ConsumerStatefulWidget {
  final String? sessionId;
  final String? adminServiceId;

  const AdminServiceSuccessPage({
    super.key,
    this.sessionId,
    this.adminServiceId,
  });

  @override
  ConsumerState<AdminServiceSuccessPage> createState() =>
      _AdminServiceSuccessPageState();
}

class _AdminServiceSuccessPageState
    extends ConsumerState<AdminServiceSuccessPage> {
  @override
  void initState() {
    super.initState();
    // Track successful purchase
    Future.microtask(_trackPurchase);
  }

  Future<void> _trackPurchase() async {
    try {
      await ref
          .read(analyticsServiceProvider)
          .trackAdminServicePurchaseSuccess();
      DebugLogger.log('Admin service purchase completed: ${widget.sessionId}');
    } catch (error, stackTrace) {
      DebugLogger.error(
        'Failed to track admin service purchase completion',
        error,
        stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/dashboard'),
          icon: const Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Success Animation/Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(Icons.check, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 32),

            // Success Message
            const Text(
              '🎉 Pagamento Confirmado!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            const Text(
              'Obrigado por confiar nos nossos serviços administrativos.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Service Details
            _buildGenericSuccess(),

            const SizedBox(height: 40),

            // Next Steps Card
            _buildNextStepsCard(),

            const SizedBox(height: 32),

            // Contact Information
            _buildContactCard(),

            const SizedBox(height: 40),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.go('/dashboard'),
                    child: const Text('Voltar ao Dashboard'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.go('/pro/profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Ver Perfil'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildGenericSuccess() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.business_center, size: 48, color: Colors.blue.shade600),
            const SizedBox(height: 16),
            const Text(
              'Serviço Administrativo Adquirido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Receberá em breve contacto da nossa equipa especializada.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextStepsCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: Colors.blue.shade700, size: 24),
                const SizedBox(width: 12),
                const Text(
                  'Próximos Passos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTimelineStep(
              '1',
              'Confirmação',
              'Recebemos o seu pedido e pagamento.',
              true,
            ),
            _buildTimelineStep(
              '2',
              'Atribuição',
              'Em 24h será atribuído um especialista.',
              false,
            ),
            _buildTimelineStep(
              '3',
              'Contacto',
              'O especialista entrará em contacto consigo.',
              false,
            ),
            _buildTimelineStep(
              '4',
              'Acompanhamento',
              'Receberá toda a ajuda necessária.',
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(
    String number,
    String title,
    String description,
    bool completed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: completed ? Colors.green : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: completed
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : Text(
                      number,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.support_agent,
                  color: Colors.orange.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Precisa de Ajuda?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Se tiver alguma dúvida ou precisar de esclarecimentos, pode contactar-nos:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.email, size: 16, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                const Text(
                  'admin@brivida.com',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.orange.shade700,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Resposta em 24h úteis',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
