abstract class HomeEvent {}

/// Event to fetch home data (replace dummy data with API call in the future)
class FetchHomeData extends HomeEvent {
  final String accessToken;
  FetchHomeData({required this.accessToken});
}

/// Event to trigger dialog, with a callback to show the dialog
class ShowDialogEvent extends HomeEvent {
  final void Function() showDialogCallback;
  ShowDialogEvent(this.showDialogCallback);
}
