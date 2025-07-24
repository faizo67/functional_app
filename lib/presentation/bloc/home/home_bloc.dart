import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../../domain/usecases/home_usecase.dart';

/// HomeBloc handles loading data for the HomeUI.
/// Now uses HomeUseCase to fetch products from the API.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeUseCase homeUseCase;
  HomeBloc(this.homeUseCase) : super(HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
    on<ShowDialogEvent>((event, emit) {
      showDialog(
        context: event.context,
        builder: (context) => AlertDialog(
          title: Text('Dialog from Bloc Event'),
          content: Text(
            'This dialog was triggered directly from the event handler!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
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
