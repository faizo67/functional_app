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

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  OverlayEntry? _loaderEntry;

  void showLoader() {
    if (_loaderEntry != null) return;
    _loaderEntry = OverlayEntry(
      builder: (_) => Container(
        color: Colors.black45,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
    navigatorKey.currentState?.overlay?.insert(_loaderEntry!);
  }

  void hideLoader() {
    _loaderEntry?.remove();
    _loaderEntry = null;
  }

  void showMyDialog() {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dialog from Bloc'),
        content: const Text(
          'This dialog was triggered from Bloc without context!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
