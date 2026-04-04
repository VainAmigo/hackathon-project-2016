import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({
    required this.username,
    required this.role,
  });

  final String username;
  final String role;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get displayName => username;

  @override
  List<Object?> get props => [username, role];
}
