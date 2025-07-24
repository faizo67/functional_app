import 'package:flutter/material.dart';

abstract class HomeEvent {}

/// Event to fetch home data (replace dummy data with API call in the future)
class FetchHomeData extends HomeEvent {
  final String accessToken;
  FetchHomeData({required this.accessToken});
}

/// Event to trigger dialog, with BuildContext
class ShowDialogEvent extends HomeEvent {
  ShowDialogEvent();
}

