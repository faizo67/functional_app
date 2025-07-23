abstract class HomeEvent {}

/// Event to fetch home data (replace dummy data with API call in the future)
class FetchHomeData extends HomeEvent {
  final String accessToken;
  FetchHomeData({required this.accessToken});
}

/// Event to trigger dialog
class ShowDialogEvent extends HomeEvent {}
