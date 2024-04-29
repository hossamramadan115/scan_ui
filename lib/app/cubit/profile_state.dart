// Correct use of 'part of' to link back to 'profile_cubit.dart'
part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class SuccessExchangeCoinsState extends ProfileState {}

class ErrorState extends ProfileState {
  final String message;
  ErrorState(this.message);

  @override
  List<Object> get props => [message];
}
