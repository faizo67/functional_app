import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:functional_app/core/utils/dialog_service.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../../domain/usecases/home_usecase.dart';

/// HomeBloc handles loading data for the HomeUI.
/// Now uses HomeUseCase to fetch products from the API.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeUseCase homeUseCase;
  HomeBloc(this.homeUseCase) : super(HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
    // Handles the ShowDialogEvent to show a dialog without needing context, callBack, Bloc Listener
    //
    on<ShowDialogEvent>((event, emit) {
      DialogService().showMyDialog(); 
    });
  }

  Future<void> _onFetchHomeData(
    FetchHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final products = await homeUseCase.fetchProducts();
      emit(HomeLoaded(accessToken: event.accessToken, products: products));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
