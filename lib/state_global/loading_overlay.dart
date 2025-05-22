// lib/component/widget/loading_overlay.dart
import 'package:flutter/material.dart';
import '../core/components/styles.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isLoading)
          const Stack(
            children: [
              ModalBarrier(
                dismissible: false,
                color: const Color.fromARGB(118, 0, 0, 0),
              ),
              Center(
                child: loadingSpinWhiteSizeBig,
              ),
            ],
          ),
        child,
      ],
    );
  }
}
