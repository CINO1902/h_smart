import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/constant/snackbar.dart';
import 'package:h_smart/features/myAppointment/presentation/Widget/profileItem.dart';

import '../../../auth/domain/usecases/authStates.dart';
import '../../../auth/presentation/controller/auth_controller.dart';
import '../../../auth/presentation/provider/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final userData = authState.userData;
    final profileUrl = userData?.patientMetadata?.profileUrl;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Blurred background/banner
              Container(
                height: 195,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: profileUrl == null
                        ? Center(
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: theme.colorScheme.primary,
                              child: Icon(
                                Icons.camera_alt,
                                size: 32,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: profileUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.error,
                              color: theme.colorScheme.error,
                            ),
                          ),
                  ),
                ),
              ),
              // AppBar Title
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12),
                  child: Stack(
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 18,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 4
                            ..color = theme.colorScheme.surface,
                        ),
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.colorScheme.onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Profile picture (circle)
              Positioned(
                top: 140,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: profileUrl == null
                          ? CircleAvatar(
                              radius: 22,
                              backgroundColor:
                                  theme.colorScheme.primary.withOpacity(0.1),
                              child: Text(
                                userData?.firstName?[0].toUpperCase() ?? '',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: profileUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                color: theme.colorScheme.error,
                                size: 32,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(60),
          // User name
          if (userData != null)
            Text(
              '${userData.firstName} ${userData.lastName}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onBackground,
              ),
            ),
          const Gap(16),
          // Options list
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      ProfileItem(
                        title: 'Personal Info',
                        iconName: 'UserCircle',
                        onTap: () async {
                          // If user info is loading, show snackbar
                          if (authState.getInfoResult.state ==
                              GetUserResultStates.isLoading) {
                            SnackBarService.notifyAction(
                              context,
                              status: SnackbarStatus.fail,
                              message: 'System is busy',
                            );
                            return;
                          }
                          // If an error occurred fetching info, attempt to refetch
                          if (authState.getInfoResult.state ==
                              GetUserResultStates.isError) {
                            SnackBarService.notifyAction(
                              context,
                              message:
                                  'An error occurred while trying to gather your information c  ',
                              status: SnackbarStatus.fail,
                            );
                            await ref.read(authProvider).fetchUserInfo();
                            // Listen for changes in getInfoResult to navigate or show errors
                            ref.listen<AuthProvider>(authProvider,
                                (previous, next) {
                              if (next.getInfoResult.state ==
                                      GetUserResultStates.isData &&
                                  mounted) {
                                SnackBarService.notifyAction(
                                  context,
                                  message: 'Access token has expired',
                                  status: SnackbarStatus.fail,
                                );
                                context.push('/PersonalInfo');
                              } else if (next.getInfoResult.state ==
                                  GetUserResultStates.isError) {
                                SnackBarService.notifyAction(
                                  context,
                                  message:
                                      'An error occurred. Please check your internet and try again.',
                                  status: SnackbarStatus.fail,
                                );
                              }
                            });
                            return;
                          }
                          // If data is already available, navigate directly
                          if (authState.getInfoResult.state ==
                              GetUserResultStates.isData) {
                            context.push('/PersonalInfo');
                          }
                        },
                      ),
                      const Gap(12),
                      ProfileItem(
                        title: 'Medical Records',
                        iconName: 'Vector-3',
                        onTap: () => context.push('/MedicalRecord'),
                      ),
                      const Gap(12),
                      ProfileItem(
                        title: 'Payments',
                        iconName: 'CreditCard',
                        onTap: () {
                          // Add navigation or logic for Payments
                        },
                      ),
                      const Gap(12),
                      ProfileItem(
                        title: 'Settings',
                        iconName: 'Sliders',
                        onTap: () => context.push('/settings'),
                      ),
                      const Gap(12),
                      ProfileItem(
                        title: 'Support',
                        iconName: 'UsersThree',
                        onTap: () => context.push('/Support'),
                      ),
                      const Gap(12),
                      ProfileItem(
                        title: 'Legal',
                        iconName: 'Info',
                        onTap: () => context.push('/Legal'),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                // Log out button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () => _showLogoutDialog(context),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withOpacity(0.1),
                        border: Border.all(
                            color: theme.colorScheme.error.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Log out',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.error,
                            ),
                          ),
                          Image.asset(
                            'images/SignOut.png',
                            width: 24,
                            height: 24,
                            color: theme.colorScheme.error,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      title: 'Warning',
      desc: 'This will log you out of your account.',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        SmartDialog.showLoading();
        ref.read(authProvider).logout();
        context.pushReplacement('/login');
        SmartDialog.dismiss();
      },
    ).show();
  }
}
