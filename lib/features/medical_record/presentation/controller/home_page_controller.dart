import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageController extends ChangeNotifier {
  int countdown = 5;
  int reloadAttempts = 0;
  static const int maxReloadAttempts = 5;
  bool exceededMaxAttempts = false;
  Timer? _countdownTimer;
  Timer? _prescriptionAutoScrollTimer;
  ScrollController? prescriptionController;
     bool isHomePageInitialized = false;
  void setPrescriptionController(ScrollController controller) {
    prescriptionController = controller;
  }


 
  void startCountdown(VoidCallback onReload) {
    countdown = 5;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdown--;
      notifyListeners();
      if (countdown <= 0) {
        timer.cancel();
        if (reloadAttempts < maxReloadAttempts) {
          reloadAttempts++;
          onReload();
          if (reloadAttempts < maxReloadAttempts) {
            startCountdown(onReload);
          } else {
            exceededMaxAttempts = true;
            notifyListeners();
          }
        }
      }
    });
  }

  void manualReload(VoidCallback onReload) {
    onReload();
  }

  void startPrescriptionAutoScroll() {
    if (prescriptionController == null) return;
    _prescriptionAutoScrollTimer?.cancel();
    _prescriptionAutoScrollTimer =
        Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!(prescriptionController?.hasClients ?? false)) return;
      final maxScroll = prescriptionController!.position.maxScrollExtent;
      final current = prescriptionController!.offset;
      double next = current + 1;
      if (next >= maxScroll) {
        next = 0;
      }
      prescriptionController!.jumpTo(next);
    });
  }

  void stopPrescriptionAutoScroll() {
    _prescriptionAutoScrollTimer?.cancel();
  }

  void disposeController() {
    _countdownTimer?.cancel();
    _prescriptionAutoScrollTimer?.cancel();
  }
}
