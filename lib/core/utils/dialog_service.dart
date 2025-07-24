import 'package:flutter/material.dart';

class DialogService {
  /// Creates a single, static instance of the class (Singleton pattern).
  /// This ensures that only one instance of DialogService exists throughout the app.
  static final DialogService _instance = DialogService._internal();

  /// Returns the single instance created above.
  /// Instead of creating a new object, this factory constructor always returns the same instance.
  factory DialogService() => _instance;

  /// Private named constructor to prevent external instantiation.
  /// Ensures that only DialogService can create its own instance.
  DialogService._internal();

  late GlobalKey<NavigatorState> navigatorKey;

  void showMyDialog() {
    // Gets the current BuildContext from the navigator key.
    final context = navigatorKey.currentContext!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Dialog from Bloc"),
        content: Text("This dialog was triggered from Bloc without context!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
