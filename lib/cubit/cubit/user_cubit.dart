import 'dart:core';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/user_state.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/services/database.dart';

// part 'user_state.dart';

class UserCubit extends Cubit<UserListState> {
  final data = GetIt.I.get<DataBaseService>();
  // final authCubit = GetIt.I.get<AuthCubit>();
  // dynamic auth = FirebaseAuth.instance.currentUser!();

  UserCubit()
      : super(UserListState(
          version: 0,
          selectedUsers: [],
        ));

  Future<void> getUsersList() async {
    List<MyUser>? _usersList = await data.getUsers();

    emit(state.copyWith(version: state.version! + 1, listUsers: _usersList));
  }

  // MyUser? getCurrentUser() {
  //   state.listUsers?.firstWhere((e) {
  //     return e.uid == FirebaseAuth.instance.currentUser?.uid;
  //   });
  // }

  void selectUser(MyUser user, int index) {
    user.isSelected = !user.isSelected!;
    if (user.isSelected == true) {
      state.selectedUsers?.add(
          user.copyWith(canWrite: true, isApporved: true, isSelected: false));
    } else {
      state.selectedUsers?.remove(user);
    }
    List<MyUser>? clear = state.selectedUsers?.toSet().toList();
    emit(state.copyWith(
        // selectedUsers: clear,
        version: state.version! + 1));
    // state.selectedUsers?.clear();
  }

  void dismissSelected() {
    state.selectedUsers?.clear();
    emit(state.copyWith(
        selectedUsers: state.selectedUsers, version: state.version! - 1));
  }
}
