import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '/core/app_export.dart';
import 'package:bank_management_system/widgets/custom_bottom_app_bar.dart';
import 'package:bank_management_system/presentation/mine_page_container_screen/models/mine_page_container_model.dart';
part 'mine_page_container_event.dart';
part 'mine_page_container_state.dart';

class MinePageContainerBloc
    extends Bloc<MinePageContainerEvent, MinePageContainerState> {
  MinePageContainerBloc(MinePageContainerState initialState)
      : super(initialState) {
    on<MinePageContainerInitialEvent>(_onInitialize);
  }

  _onInitialize(
    MinePageContainerInitialEvent event,
    Emitter<MinePageContainerState> emit,
  ) async {}
}
