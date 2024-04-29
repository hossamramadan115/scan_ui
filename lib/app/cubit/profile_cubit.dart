import "package:bloc/bloc.dart";
import 'package:equatable/equatable.dart';

// Correct use of 'part' to include the 'profile_state.dart' file.
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  void getExchangeCoins({required String amount}) {
    try {
      // Simulate a network call
      Future.delayed(Duration(seconds: 2), () {
        emit(SuccessExchangeCoinsState());
      });
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
