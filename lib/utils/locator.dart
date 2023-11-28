import 'package:get_it/get_it.dart';
import 'package:klitchyapp/viewmodels/kitchen_interactor.dart';
import 'package:klitchyapp/viewmodels/kitchen_vm.dart';
import 'package:klitchyapp/viewmodels/pin_screen_interactor.dart';
import 'package:klitchyapp/viewmodels/pin_screen_vm.dart';
import 'package:klitchyapp/viewmodels/right_drawer_interractor.dart';
import 'package:klitchyapp/viewmodels/room_interactor.dart';
import 'package:klitchyapp/viewmodels/start_page_interractor.dart';
import '../viewmodels/right_drawer_vm.dart';
import '../viewmodels/room_vm.dart';
import '../viewmodels/start_page_vm.dart';
import '../viewmodels/table_order_interactor.dart';
import '../viewmodels/table_order_vm.dart';

final getIt = GetIt.I;

void setupLocator() {
  getIt.registerSingleton<TableOrderInteractor>(TablOrderPageState());
  getIt.registerSingleton<RoomInteractor>(RoomVMState());
  getIt.registerSingleton<StartPageInterractor>(StartPageVMState());
  getIt.registerSingleton<RightDrawerInterractor>(RightDrawerVMState());
  getIt.registerSingleton<PinScreenInteractor>(PinScreenVMState());
  getIt.registerSingleton<KitchenInteractor>(KitchenVMState());
}