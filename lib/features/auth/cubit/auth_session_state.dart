import 'package:equatable/equatable.dart';
import 'package:project_temp/features/auth/cubit/auth_session_notice.dart';
import 'package:project_temp/source/source.dart';

class AuthSessionState extends Equatable {
  const AuthSessionState({
    this.bootstrapped = false,
    this.isAuthenticated = false,
    this.user,
    this.notice = AuthSessionNotice.none,
  });

  final bool bootstrapped;
  final bool isAuthenticated;
  final User? user;
  final AuthSessionNotice notice;

  AuthSessionState copyWith({
    bool? bootstrapped,
    bool? isAuthenticated,
    User? user,
    bool clearUser = false,
    AuthSessionNotice? notice,
    bool clearNotice = false,
  }) {
    return AuthSessionState(
      bootstrapped: bootstrapped ?? this.bootstrapped,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: clearUser ? null : (user ?? this.user),
      notice: clearNotice
          ? AuthSessionNotice.none
          : (notice ?? this.notice),
    );
  }

  @override
  List<Object?> get props => [bootstrapped, isAuthenticated, user, notice];
}
