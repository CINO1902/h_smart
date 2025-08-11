import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constant/snackbar.dart';
import '../../domain/entities/GetHospital.dart';
import '../../domain/states/hospitalStates.dart';
import '../provider/getHospitalProvider.dart';

class AnimatedConnectionButton extends ConsumerStatefulWidget {
  final Hospital hospital;
  final AnimationController iconAnimationController;
  final Animation<double> iconRotationAnimation;

  const AnimatedConnectionButton({
    super.key,
    required this.hospital,
    required this.iconAnimationController,
    required this.iconRotationAnimation,
  });

  @override
  ConsumerState<AnimatedConnectionButton> createState() =>
      _AnimatedConnectionButtonState();
}

class _AnimatedConnectionButtonState
    extends ConsumerState<AnimatedConnectionButton> {
  bool buttonClicked = false;
  bool isDisconnecting = false;

  void handleConnect() {
    setState(() => buttonClicked = true);
    ref.read(hospitalprovider).connectToHospital(
          widget.hospital.id.toString(),
        );
  }

  void handleDisconnect() {
    setState(() {
      buttonClicked = true;
      isDisconnecting = true;
    });
    ref.read(hospitalprovider).disconnectFromHospital(
          widget.hospital.id.toString(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final connectState =
        ref.watch(hospitalprovider).connectToHospitalResult.state;
    final disconnectState =
        ref.watch(hospitalprovider).disconnectFromHospitalResult.state;
    final isConnected = widget.hospital.isConnected == true;
    final connectMessage =
        ref.watch(hospitalprovider).connectToHospitalResult.message;
    final disconnectMessage =
        ref.watch(hospitalprovider).disconnectFromHospitalResult.message;

    final isConnectLoading =
        connectState == ConnectToHospitalResultStates.isLoading;
    final isDisconnectLoading =
        disconnectState == DisconnectFromHospitalResultStates.isLoading;
    final isLoading = isConnectLoading || isDisconnectLoading;

    final isConnectSuccess =
        connectState == ConnectToHospitalResultStates.isData;
    final isDisconnectSuccess =
        disconnectState == DisconnectFromHospitalResultStates.isData;

    final hasConnectError =
        connectState == ConnectToHospitalResultStates.isError;
    final hasDisconnectError =
        disconnectState == DisconnectFromHospitalResultStates.isError;
    final hasError = hasConnectError || hasDisconnectError;

    if (isLoading) {
      widget.iconAnimationController.repeat();
    } else {
      widget.iconAnimationController.stop();
      widget.iconAnimationController.reset();
    }

    if (isConnectSuccess && !isConnected && buttonClicked && !isDisconnecting) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackBarService.notifyAction(context,
            message: connectMessage, status: SnackbarStatus.success);
        widget.hospital.isConnected = true;
        setState(() {
          buttonClicked = false;
          isDisconnecting = false;
        });
      });
    }

    if (isDisconnectSuccess &&
        isConnected &&
        buttonClicked &&
        isDisconnecting) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackBarService.notifyAction(context,
            message: disconnectMessage, status: SnackbarStatus.success);
        widget.hospital.isConnected = false;
        setState(() {
          buttonClicked = false;
          isDisconnecting = false;
        });
      });
    }

    if (hasError && buttonClicked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final errorMessage =
            hasConnectError ? connectMessage : disconnectMessage;
        SnackBarService.notifyAction(context,
            message: errorMessage, status: SnackbarStatus.fail);
        setState(() {
          buttonClicked = false;
          isDisconnecting = false;
        });
      });
    }

    Color backgroundColor;
    Color foregroundColor;
    IconData iconData;
    String buttonText;
    VoidCallback? onPressed;

    if (isConnected || isConnectSuccess) {
      backgroundColor = Colors.green;
      foregroundColor = Colors.white;
      iconData = Icons.check_circle_outline;
      buttonText = 'Connected to Hospital';
      onPressed = () {
        // Show disconnect confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Disconnect from Hospital'),
              content: Text(
                  'Are you sure you want to disconnect from ${widget.hospital.hospitalName}?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    handleDisconnect();
                  },
                  child: const Text('Disconnect',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      };
    } else if (isLoading) {
      backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.8);
      foregroundColor = Theme.of(context).colorScheme.onPrimary;
      iconData = Icons.sync;
      buttonText = isDisconnecting ? 'Disconnecting...' : 'Connecting...';
      onPressed = null;
    } else if (hasError) {
      backgroundColor = Colors.red.shade400;
      foregroundColor = Colors.white;
      iconData = Icons.refresh;
      buttonText = 'Retry Connection';
      onPressed = handleConnect;
    } else {
      backgroundColor = Theme.of(context).colorScheme.primary;
      foregroundColor = Theme.of(context).colorScheme.onPrimary;
      iconData = Icons.add_circle_outline;
      buttonText = 'Connect to Hospital';
      onPressed = handleConnect;
    }

    return TweenAnimationBuilder<Color?>(
      duration: const Duration(milliseconds: 400),
      tween: ColorTween(
        begin: backgroundColor,
        end: backgroundColor,
      ),
      builder: (context, color, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()..scale(isLoading ? 0.98 : 1.0),
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: AnimatedBuilder(
              animation: widget.iconRotationAnimation,
              builder: (context, child) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Transform.rotate(
                    key: ValueKey(iconData),
                    angle: isLoading
                        ? widget.iconRotationAnimation.value * 2 * 3.14159
                        : 0,
                    child: Icon(iconData),
                  ),
                );
              },
            ),
            label: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.5),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Text(
                buttonText,
                key: ValueKey(buttonText),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? backgroundColor,
              foregroundColor: foregroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: isLoading ? 2 : 0,
              shadowColor: backgroundColor.withOpacity(0.3),
              animationDuration: const Duration(milliseconds: 300),
            ),
          ),
        );
      },
    );
  }
}
