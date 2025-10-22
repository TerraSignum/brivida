import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/admin_service.dart';
import '../../../core/providers/firebase_providers.dart';
import '../logic/admin_services_controller.dart';

/// PG-17/18: Admin console for managing "Oficializa-te" services
class AdminServicesPage extends ConsumerStatefulWidget {
  const AdminServicesPage({super.key});

  @override
  ConsumerState<AdminServicesPage> createState() => _AdminServicesPageState();
}

class _AdminServicesPageState extends ConsumerState<AdminServicesPage> {
  AdminServiceStatus? _selectedStatusFilter;
  AdminServicePackage? _selectedPackageFilter;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminServicesAsync = ref.watch(
      allAdminServicesStreamProvider(_selectedStatusFilter),
    );
    final pendingCountAsync = ref.watch(pendingAdminServicesCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏛️ Admin Services'),
        actions: [
          IconButton(
            onPressed: () => _showSupportContact(),
            icon: const Icon(Icons.support_agent),
            tooltip: 'Support Contact',
          ),
          IconButton(
            onPressed: () => _showStatistics(),
            icon: const Icon(Icons.analytics),
          ),
          IconButton(
            onPressed: () => ref.refresh(
              allAdminServicesStreamProvider(_selectedStatusFilter),
            ),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          _buildStatsBar(pendingCountAsync),
          Expanded(
            child: adminServicesAsync.when(
              data: (services) => _buildServicesList(services),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Erro: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(
                        allAdminServicesStreamProvider(_selectedStatusFilter),
                      ),
                      child: const Text('Tentar novamente'),
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

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Procurar por pro...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    // Implement search functionality
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<AdminServiceStatus?>(
                value: _selectedStatusFilter,
                hint: const Text('Estado'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Todos')),
                  ...AdminServiceStatus.values.map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(_getStatusLabel(status)),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatusFilter = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              DropdownButton<AdminServicePackage?>(
                value: _selectedPackageFilter,
                hint: const Text('Pacote'),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Todos os pacotes'),
                  ),
                  ...AdminServicePackage.values.map(
                    (package) => DropdownMenuItem(
                      value: package,
                      child: Text(_getPackageLabel(package)),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPackageFilter = value;
                  });
                },
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear),
                label: const Text('Limpar filtros'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar(AsyncValue<int> pendingCountAsync) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Icon(Icons.pending_actions, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Text(
            'Pendentes: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          pendingCountAsync.when(
            data: (count) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: count > 0 ? Colors.orange : Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            loading: () => const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (error, stackTrace) => const Text('?'),
          ),
          const Spacer(),
          Text(
            'Atualizado: ${DateFormat('HH:mm').format(DateTime.now())}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(List<AdminService> services) {
    // Apply search filter
    List<AdminService> filteredServices = services;
    if (_searchQuery.isNotEmpty) {
      filteredServices = services.where((service) {
        final serviceId = service.id?.toLowerCase() ?? '';
        final proId = service.proId.toLowerCase();
        final adminId = service.assignedAdminId?.toLowerCase() ?? '';
        final notes = service.adminNotes?.toLowerCase() ?? '';

        return serviceId.contains(_searchQuery) ||
            proId.contains(_searchQuery) ||
            adminId.contains(_searchQuery) ||
            notes.contains(_searchQuery);
      }).toList();
    }

    if (filteredServices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Nenhum resultado para "$_searchQuery"'
                  : 'Nenhum serviço encontrado',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Tente um termo diferente'
                  : 'Os serviços admin aparecerão aqui quando forem comprados',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredServices.length,
      itemBuilder: (context, index) =>
          _buildServiceCard(filteredServices[index]),
    );
  }

  Widget _buildServiceCard(AdminService service) {
    final statusColor = _getStatusColor(service.status);
    final packageInfo = AdminServicePackageInfo.packages.firstWhere(
      (p) => p.package == service.package,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _getStatusLabel(service.status),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '€${service.price.toInt()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  service.package == AdminServicePackage.basic
                      ? Icons.help_outline
                      : Icons.security,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  packageInfo.titleKey.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Pro ID: ${service.proId}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontFamily: 'monospace',
              ),
            ),
            if (service.createdAt != null) ...[
              const SizedBox(height: 4),
              Text(
                'Criado: ${DateFormat('dd/MM/yyyy HH:mm').format(service.createdAt!)}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
            if (service.adminNotes?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notas do Admin:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.adminNotes!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                if (service.status == AdminServiceStatus.pending)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _assignService(service),
                      icon: const Icon(Icons.assignment_ind, size: 16),
                      label: const Text('Atribuir'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                if (service.status == AdminServiceStatus.assigned)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _completeService(service),
                      icon: const Icon(Icons.check_circle, size: 16),
                      label: const Text('Concluir'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editNotes(service),
                    icon: const Icon(Icons.edit_note, size: 16),
                    label: const Text('Notas'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showServiceDetails(service),
                  icon: const Icon(Icons.info_outline),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(AdminServiceStatus status) {
    switch (status) {
      case AdminServiceStatus.pendingPayment:
        return Colors.amber.shade700;
      case AdminServiceStatus.pending:
        return Colors.orange;
      case AdminServiceStatus.assigned:
        return Colors.blue;
      case AdminServiceStatus.completed:
        return Colors.green;
      case AdminServiceStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusLabel(AdminServiceStatus status) {
    switch (status) {
      case AdminServiceStatus.pendingPayment:
        return 'Pagamento pendente';
      case AdminServiceStatus.pending:
        return 'Pendente';
      case AdminServiceStatus.assigned:
        return 'Atribuído';
      case AdminServiceStatus.completed:
        return 'Concluído';
      case AdminServiceStatus.cancelled:
        return 'Cancelado';
    }
  }

  String _getPackageLabel(AdminServicePackage package) {
    switch (package) {
      case AdminServicePackage.basic:
        return 'Ajuda Básica';
      case AdminServicePackage.secure:
        return 'Arranque Seguro';
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedStatusFilter = null;
      _selectedPackageFilter = null;
      _searchController.clear();
    });
  }

  Future<void> _assignService(AdminService service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atribuir Serviço'),
        content: Text('Atribuir este serviço a ti? O pro será notificado.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Atribuir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final adminUser = ref.read(currentUserDataProvider);
      final adminUid = adminUser?.uid;

      if (adminUid == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível identificar o admin atual.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      try {
        await ref
            .read(adminServicesControllerProvider.notifier)
            .updateServiceStatus(
              service.id!,
              AdminServiceStatus.assigned,
              assignedAdminId: adminUid,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Serviço atribuído com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro: $e')));
        }
      }
    }
  }

  Future<void> _completeService(AdminService service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Concluir Serviço'),
        content: const Text(
          'Marcar este serviço como concluído? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Concluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(adminServicesControllerProvider.notifier)
            .updateServiceStatus(service.id!, AdminServiceStatus.completed);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Serviço marcado como concluído!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro: $e')));
        }
      }
    }
  }

  Future<void> _editNotes(AdminService service) async {
    final notesController = TextEditingController(
      text: service.adminNotes ?? '',
    );

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Notas'),
        content: SizedBox(
          width: double.maxFinite,
          child: TextField(
            controller: notesController,
            decoration: const InputDecoration(
              hintText: 'Adicionar notas sobre o acompanhamento...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, notesController.text),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result != null) {
      try {
        await ref
            .read(adminServicesControllerProvider.notifier)
            .addAdminNotes(service.id!, result);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notas guardadas!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro: $e')));
        }
      }
    }

    notesController.dispose();
  }

  void _showServiceDetails(AdminService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalhes do Serviço'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ID', service.id ?? 'N/A'),
              _buildDetailRow('Pro ID', service.proId),
              _buildDetailRow('Pacote', _getPackageLabel(service.package)),
              _buildDetailRow('Preço', '€${service.price.toInt()}'),
              _buildDetailRow('Estado', _getStatusLabel(service.status)),
              if (service.createdAt != null)
                _buildDetailRow(
                  'Criado',
                  DateFormat('dd/MM/yyyy HH:mm').format(service.createdAt!),
                ),
              if (service.assignedAt != null)
                _buildDetailRow(
                  'Atribuído',
                  DateFormat('dd/MM/yyyy HH:mm').format(service.assignedAt!),
                ),
              if (service.completedAt != null)
                _buildDetailRow(
                  'Concluído',
                  DateFormat('dd/MM/yyyy HH:mm').format(service.completedAt!),
                ),
              if (service.assignedAdminId != null)
                _buildDetailRow('Admin', service.assignedAdminId!),
              if (service.stripeSessionId != null)
                _buildDetailRow('Stripe Session', service.stripeSessionId!),
              if (service.followUpSent) const Text('✅ Follow-up enviado'),
              if (service.pdfGuideDelivered) const Text('✅ PDF guide entregue'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showStatistics() {
    // Implement comprehensive statistics dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📊 Estatísticas dos Serviços Admin'),
        content: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 400),
          child: Consumer(
            builder: (context, ref, child) {
              final servicesAsync = ref.watch(
                allAdminServicesStreamProvider(null),
              );

              return servicesAsync.when(
                data: (services) => _buildStatisticsContent(services),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Erro: $error'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showSupportContact() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📞 Support Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need help with admin services? Contact our support team:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              'Email Support',
              Icons.email,
              'admin-support@brivida.com',
              Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildContactOption(
              'Phone Support',
              Icons.phone,
              '+351 XXX XXX XXX',
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildContactOption(
              'Live Chat',
              Icons.chat,
              'Available 9-18h',
              Colors.purple,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption(
    String title,
    IconData icon,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: color.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsContent(List<AdminService> services) {
    final totalServices = services.length;
    final pendingPaymentServices = services
        .where((s) => s.status == AdminServiceStatus.pendingPayment)
        .length;
    final pendingServices = services
        .where((s) => s.status == AdminServiceStatus.pending)
        .length;
    final assignedServices = services
        .where((s) => s.status == AdminServiceStatus.assigned)
        .length;
    final completedServices = services
        .where((s) => s.status == AdminServiceStatus.completed)
        .length;
    final cancelledServices = services
        .where((s) => s.status == AdminServiceStatus.cancelled)
        .length;

    final basicPackages = services
        .where((s) => s.package == AdminServicePackage.basic)
        .length;
    final securePackages = services
        .where((s) => s.package == AdminServicePackage.secure)
        .length;

    final totalRevenue = services
        .where((s) => s.status == AdminServiceStatus.completed)
        .fold<double>(0, (sum, service) => sum + service.price);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Overview
          const Text(
            'Status dos Serviços:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          _buildStatItem('Total', totalServices, Colors.blue),
          _buildStatItem(
            'Pagamento pendente',
            pendingPaymentServices,
            Colors.amber.shade700,
          ),
          _buildStatItem('Pendente', pendingServices, Colors.orange),
          _buildStatItem('Atribuído', assignedServices, Colors.purple),
          _buildStatItem('Concluído', completedServices, Colors.green),
          _buildStatItem('Cancelado', cancelledServices, Colors.red),

          const SizedBox(height: 16),

          // Package Distribution
          const Text(
            'Distribuição de Pacotes:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          _buildStatItem('Ajuda Básica', basicPackages, Colors.indigo),
          _buildStatItem('Arranque Seguro', securePackages, Colors.teal),

          const SizedBox(height: 16),

          // Revenue
          const Text(
            'Receita:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.euro, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Total: €${totalRevenue.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(
            count.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
