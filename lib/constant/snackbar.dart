import 'package:flutter/material.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SnackBarService {
  static void notifyAction(BuildContext context,
      {required String message,
      SnackbarStatus status = SnackbarStatus.success,
      int timeInSec = 1}) {
    showTopSnackBar(
      Overlay.of(context),
      Center(
        child: AnimatedContainer(
          // margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
          // width: 94,
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: status == SnackbarStatus.success
                ? AppColors.ksuccessColor500
                : status == SnackbarStatus.info
                    ? AppColors.kwarningColor200
                    : AppColors.kErrorColor300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          duration: Durations.long3,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
      displayDuration: Duration(seconds: timeInSec),
      dismissType: DismissType.onTap,
    );
  }

  /// show a snackbar
  static void showSnackBar(BuildContext context,
      {required String title,
      required String body,
      SnackbarStatus status = SnackbarStatus.success,
      int timeInSec = 4}) {
    showTopSnackBar(
      Overlay.of(context),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: 4,
                  color: AppColors.kBlack.withOpacity(0.2),
                  spreadRadius: 2,
                  offset: const Offset(0, 1))
            ],
            border: Border.all(
                color: status == SnackbarStatus.success
                    ? AppColors.ksuccessColor300
                    : status == SnackbarStatus.info
                        ? AppColors.kwarningColor300
                        : AppColors.kErrorColor300),
            borderRadius: BorderRadius.circular(8),
            color: status == SnackbarStatus.success
                ? AppColors.kSuccessColor50
                : status == SnackbarStatus.info
                    ? AppColors.kwarningColor50
                    : AppColors.kErrorColor50),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: status == SnackbarStatus.success
                            ? AppColors.ksuccessColor500
                            : status == SnackbarStatus.info
                                ? AppColors.kwarningColor500
                                : AppColors.kErrorColor500,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: status == SnackbarStatus.success
                              ? AppColors.ksuccessColor500
                              : status == SnackbarStatus.info
                                  ? AppColors.kwarningColor500
                                  : AppColors.kErrorColor500,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Icon(
              status == SnackbarStatus.success
                  ? Icons.check_circle
                  : status == SnackbarStatus.info
                      ? Icons.info
                      : Icons.error,
              color: status == SnackbarStatus.success
                  ? AppColors.ksuccessColor500
                  : status == SnackbarStatus.info
                      ? AppColors.kwarningColor500
                      : AppColors.kErrorColor500,
            ),
          ],
        ),
      ),
      // persistent: true,
      displayDuration: const Duration(seconds: 2),
      dismissType: DismissType.onTap,
    );
  }
}

enum SnackbarStatus { success, fail, info }

void showCustomSnackBar(
  BuildContext context,
  String message,
  SnackbarStatus status,
) {
  final theme = Theme.of(context);

  showTopSnackBar(
    Overlay.of(context),
    Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: theme.colorScheme.shadow.withOpacity(0.2),
            spreadRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: status == SnackbarStatus.success
              ? theme.colorScheme.tertiary
              : status == SnackbarStatus.info
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
        ),
        borderRadius: BorderRadius.circular(8),
        color: status == SnackbarStatus.success
            ? theme.colorScheme.tertiary.withOpacity(0.2)
            : status == SnackbarStatus.info
                ? theme.colorScheme.primary.withOpacity(0.2)
                : theme.colorScheme.error.withOpacity(0.2),
      ),
      child: Row(
        children: [
          Icon(
            status == SnackbarStatus.success
                ? Icons.check_circle
                : status == SnackbarStatus.info
                    ? Icons.info
                    : Icons.error,
            color: status == SnackbarStatus.success
                ? theme.colorScheme.tertiary
                : status == SnackbarStatus.info
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
    displayDuration: const Duration(seconds: 3),
  );
}
