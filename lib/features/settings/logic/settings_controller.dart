import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brivida_app/core/models/app_user.dart';
import 'package:brivida_app/features/settings/data/settings_repo.dart';

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, AsyncValue<AppUser?>>((ref) {
      final repository = ref.watch(settingsRepositoryProvider);
      return SettingsController(repository);
    });

class SettingsController extends StateNotifier<AsyncValue<AppUser?>> {
  SettingsController(this._repository) : super(const AsyncValue.loading()) {
    _subscription = _repository.watchCurrentUser().listen(
      (user) {
        _emitState(AsyncValue.data(user));
      },
      onError: (error, stackTrace) {
        _emitState(AsyncValue.error(error, stackTrace));
      },
    );
  }

  final SettingsRepository _repository;
  StreamSubscription<AppUser?>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> refresh() async {
    if (!mounted) {
      return;
    }
    _emitState(const AsyncValue.loading());
    await _subscription?.cancel();
    _subscription = _repository.watchCurrentUser().listen(
      (user) {
        _emitState(AsyncValue.data(user));
      },
      onError: (error, stackTrace) {
        _emitState(AsyncValue.error(error, stackTrace));
      },
    );
  }

  Future<void> updateDisplayName(String name) async {
    await _repository.updateDisplayName(name);
  }

  Future<void> updateLocale(String? localeCode) async {
    await _repository.updateLocale(localeCode);
  }

  Future<void> updateMarketingOptIn(bool value) async {
    await _repository.updateMarketingOptIn(value);
  }

  Future<void> updatePhoneNumber(String? value) async {
    await _repository.updatePhoneNumber(value);
  }

  Future<void> updatePhoto(File file) async {
    await _repository.updatePhoto(file);
  }

  Future<void> reserveUsername(String desired) async {
    await _repository.reserveUsername(desired);
  }

  Future<void> deleteAccount() async {
    await _repository.deleteAccount();
  }

  void _emitState(AsyncValue<AppUser?> value) {
    if (!mounted) {
      return;
    }
    state = value;
  }
}
