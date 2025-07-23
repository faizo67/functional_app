import '../../../data/models/product_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  final String accessToken;
  final List<ProductModel> products;

  HomeLoaded({required this.accessToken, required this.products});
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}

class HomeLoading extends HomeState {
  HomeLoading();
  @override
  String toString() => 'HomeLoading';
}

class HomeShowDialog extends HomeState {}
