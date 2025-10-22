import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/models/app_user.dart';
import '../../../core/providers/user_role_provider.dart';
import '../../../core/widgets/language_footer.dart';
import '../../finance/ui/finance_overview_page.dart';
import '../../settings/logic/settings_controller.dart';
import '../../tutorial/logic/tutorial_registry.dart';
import '../../tutorial/ui/tutorial_trigger.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = FirebaseAuth.instance.currentUser;
    final profileState = ref.watch(settingsControllerProvider);
    final appUser = profileState.when(
      data: (user) => user,
      loading: () => null,
      error: (error, _) => null,
    );
    final displayName = _resolveDisplayName(context, authUser, appUser);

    final scaffold = Scaffold(
      body: Column(
        children: [
          // Logo Banner/Header - Full Width (same as sign-in screen)
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/logo2.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: const Color(0xFF6366F1),
                        child: const Center(
                          child: Icon(
                            Icons.cleaning_services,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('home.welcome'),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.tr(
                              'home.loggedInAs',
                              namedArgs: {'user': displayName},
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Main Features Section
                  // Feature Cards Sections
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final roleAsync = ref.watch(userRoleProvider);

                        return roleAsync.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stack) => _FeatureSections(role: null),
                          data: (role) => _FeatureSections(role: role),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const LanguageFooter(),
    );

    return TutorialTrigger(screen: TutorialScreen.home, child: scaffold);
  }
}

class _FeatureSections extends StatelessWidget {
  const _FeatureSections({required this.role});

  final AppUserRole? role;

  bool get _isAdmin => role == AppUserRole.admin;
  bool get _isPro => role == AppUserRole.pro || _isAdmin;

  @override
  Widget build(BuildContext context) {
    final showCustomerSection = role != AppUserRole.pro;

    final customerFeatures = <_FeatureConfig>[
      _FeatureConfig(
        titleKey: 'home.features.createJob.title',
        subtitleKey: 'home.features.createJob.subtitle',
        icon: Icons.add_business,
        color: Colors.blue,
        route: '/jobs/new',
      ),
      _FeatureConfig(
        titleKey: 'home.features.myJobs.title',
        subtitleKey: 'home.features.myJobs.subtitle',
        icon: Icons.list_alt,
        color: Colors.green,
        route: '/jobs',
      ),
      _FeatureConfig(
        titleKey: 'home.features.offerSearch.title',
        subtitleKey: 'home.features.offerSearch.subtitle',
        icon: Icons.search,
        color: Colors.cyan,
        route: '/offers/search',
      ),
    ];

    final proFeatures = <_FeatureConfig>[];
    if (_isPro) {
      proFeatures
        ..add(
          _FeatureConfig(
            titleKey: 'home.features.jobFeed.title',
            subtitleKey: 'home.features.jobFeed.subtitle',
            icon: Icons.feed,
            color: Colors.orange,
            route: '/job-feed',
          ),
        )
        ..add(
          _FeatureConfig(
            titleKey: 'home.features.finance.title',
            subtitleKey: 'home.features.finance.subtitle',
            icon: Icons.account_balance_wallet_outlined,
            color: Colors.lightGreen,
            route: FinanceOverviewPage.routePath,
          ),
        )
        ..add(
          _FeatureConfig(
            titleKey: 'home.features.proOffers.title',
            subtitleKey: 'home.features.proOffers.subtitle',
            icon: Icons.store_mall_directory,
            color: Colors.deepPurple,
            route: '/pro/offers',
          ),
        )
        ..add(
          _FeatureConfig(
            titleKey: 'home.features.myLeads.title',
            subtitleKey: 'home.features.myLeads.subtitle',
            icon: Icons.inbox,
            color: Colors.purple,
            route: '/leads',
          ),
        );

      if (_isAdmin) {
        proFeatures.add(
          _FeatureConfig(
            titleKey: 'home.features.admin.dashboard.title',
            subtitleKey: 'home.features.admin.dashboard.subtitle',
            icon: Icons.admin_panel_settings,
            color: Colors.amber[700]!,
            route: '/admin',
          ),
        );
      }
    }

    final sharedFeatures = <_FeatureConfig>[
      _FeatureConfig(
        titleKey: 'home.features.chats.title',
        subtitleKey: 'home.features.chats.subtitle',
        icon: Icons.chat,
        color: Colors.teal,
        route: '/chats',
      ),
      _FeatureConfig(
        titleKey: 'home.features.calendar.title',
        subtitleKey: 'home.features.calendar.subtitle',
        icon: Icons.calendar_today,
        color: Colors.indigo,
        route: '/calendar',
      ),
      _FeatureConfig(
        titleKey: 'home.features.settings.title',
        subtitleKey: 'home.features.settings.subtitle',
        icon: Icons.settings,
        color: Colors.blueGrey,
        route: '/settings',
      ),
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showCustomerSection)
            _FeatureSection(
              title: 'home.features.sections.customers'.tr(),
              features: customerFeatures,
            ),
          if (proFeatures.isNotEmpty) ...[
            if (showCustomerSection) const SizedBox(height: 24),
            _FeatureSection(
              title: 'home.features.sections.pros'.tr(),
              features: proFeatures,
            ),
          ],
          const SizedBox(height: 24),
          _FeatureSection(
            title: 'home.features.sections.shared'.tr(),
            features: sharedFeatures,
          ),
        ],
      ),
    );
  }
}

String _resolveDisplayName(
  BuildContext context,
  User? authUser,
  AppUser? appUser,
) {
  final username = appUser?.username?.trim();
  if (username != null && username.isNotEmpty) {
    return '@$username';
  }

  final display = appUser?.displayName?.trim();
  if (display != null && display.isNotEmpty) {
    return display;
  }

  final email = authUser?.email?.trim();
  if (email != null && email.isNotEmpty) {
    return email;
  }

  return context.tr('common.unknownEmail');
}

class _FeatureConfig {
  const _FeatureConfig({
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
    required this.color,
    required this.route,
  });

  final String titleKey;
  final String subtitleKey;
  final IconData icon;
  final Color color;
  final String route;
}

// Feature Card Widget
class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureSection extends StatelessWidget {
  const _FeatureSection({required this.title, required this.features});

  final String title;
  final List<_FeatureConfig> features;

  @override
  Widget build(BuildContext context) {
    if (features.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;
            final crossAxisCount = isWide ? 3 : 2;
            final aspectRatio = isWide ? 4 / 3 : 0.9;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: aspectRatio,
              children: features
                  .map(
                    (config) => _FeatureCard(
                      title: config.titleKey.tr(),
                      subtitle: config.subtitleKey.tr(),
                      icon: config.icon,
                      color: config.color,
                      onTap: () => context.push(config.route),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
