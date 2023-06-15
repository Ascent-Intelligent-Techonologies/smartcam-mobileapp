import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smartcam_dashboard/data/models/update_alert_state.dart';
import 'package:smartcam_dashboard/data/repositories/alert_repository.dart';
import 'package:smartcam_dashboard/data/repositories/repository.dart';

part 'update_alert_state_state.dart';

class UpdateAlertStateCubit extends Cubit<UpdateAlertStateState> {
  final Repository repository;
  UpdateAlertStateCubit(this.repository) : super(UpdateAlertStateInitial());

  FutureOr<void> updateAlertState(
      UpdateAlertStateModel updateAlertState) async {
    emit(UpdateAlertStateLoading());
    try {
      await repository.updateAlertState(updateAlertState);
      emit(UpdateAlertStateSuccess());
    } catch (e) {
      emit(UpdateAlertStateError(message: e.toString()));
    }
  }
}
