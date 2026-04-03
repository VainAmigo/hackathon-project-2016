import 'package:equatable/equatable.dart';
import 'package:project_temp/source/source.dart';

class AuthSessionState extends Equatable {
  const AuthSessionState({
    this.bootstrapped = false,
    this.isAuthenticated = false,
    this.user,
  });

  final bool bootstrapped;
  final bool isAuthenticated;
  final User? user;

  AuthSessionState copyWith({
    bool? bootstrapped,
    bool? isAuthenticated,
    User? user,
    bool clearUser = false,
  }) {
    return AuthSessionState(
      bootstrapped: bootstrapped ?? this.bootstrapped,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: clearUser ? null : (user ?? this.user),
    );
  }

  @override
  List<Object?> get props => [bootstrapped, isAuthenticated, user];
}
