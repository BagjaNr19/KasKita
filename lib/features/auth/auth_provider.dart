import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/app_user.dart';
import '../../data/dummy/dummy_users.dart';

class AuthState {
  final AppUser? currentUser;
  final bool isLoading;

  const AuthState({
    this.currentUser,
    this.isLoading = false,
  });

  AuthState copyWith({AppUser? currentUser, bool? isLoading}) {
    return AuthState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> login(UserRole role) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 800));

    AppUser user;
    switch (role) {
      case UserRole.warga:
        user = DummyUsers.warga;
        break;
      case UserRole.bendahara:
        user = DummyUsers.bendahara;
        break;
      case UserRole.admin:
        user = DummyUsers.admin;
        break;
    }

    state = AuthState(currentUser: user, isLoading: false);
  }

  void logout() {
    state = const AuthState();
  }
}

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
