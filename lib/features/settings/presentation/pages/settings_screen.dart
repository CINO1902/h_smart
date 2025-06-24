import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/settings/presentation/providers/settings_provider.dart';
import 'package:h_smart/core/theme/theme_provider.dart';
import 'package:h_smart/features/settings/presentation/widgets/health_summary_card.dart';

import '../../../../constant/snackbar.dart';
import '../../../auth/domain/usecases/authStates.dart';
import '../../../auth/presentation/controller/auth_controller.dart';
import '../../../auth/presentation/provider/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final themeMode = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Settings',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: ListView(
        children: [
          // Health Summary Card
          Padding(
            padding: const EdgeInsets.all(16),
            child: HealthSummaryCard(
              patientMetadata: authState.userData?.patientMetadata,
              onTap: () => context.push('/health-profile'),
            ),
          ),

          _buildSection(
            title: 'Account',
            children: [
              _SettingsTile(
                icon: Icons.person_outline,
                title: 'Personal Information',
                onTap: () async {
                  print('object');
                  // If user info is loading, show snackbar
                  if (authState.getInfoResult.state ==
                      GetUserResultStates.isLoading) {
                    SnackBarService.notifyAction(
                      context,
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
                          'An error occurred while trying to gather your information. Let\'s try again.',
                      status: SnackbarStatus.fail,
                    );
                    await ref.read(authProvider).fetchUserInfo();
                    // Listen for changes in getInfoResult to navigate or show errors
                    ref.listen<AuthProvider>(authProvider, (previous, next) {
                      if (next.getInfoResult.state ==
                              GetUserResultStates.isData &&
                          context.mounted) {
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
              _SettingsTile(
                icon: Icons.health_and_safety_outlined,
                title: 'Health Profile',
                onTap: () {
                  context.push('/health-profile');
                },
              ),
              _SettingsTile(
                icon: Icons.security_outlined,
                title: 'Security',
                subtitle: 'Password, Face ID, 2FA',
                onTap: () {
                  context.push('/security-settings');
                },
              ),
            ],
            context: context,
          ),
          _buildSection(
            title: 'Notifications',
            children: [
              _SettingsToggleTile(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                subtitle: 'Receive alerts and reminders',
                value: settings.pushNotifications,
                onChanged: (value) async {
                  await ref
                      .read(settingsProvider.notifier)
                      .togglePushNotifications(value);
                },
              ),
              _SettingsToggleTile(
                icon: Icons.email_outlined,
                title: 'Email Notifications',
                subtitle: 'Receive updates via email',
                value: settings.emailNotifications,
                onChanged: (value) async {
                  await ref
                      .read(settingsProvider.notifier)
                      .toggleEmailNotifications(value);
                },
              ),
            ],
            context: context,
          ),
          _buildSection(
            title: 'Privacy',
            children: [
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Settings',
                subtitle: 'Manage your data and privacy preferences',
                onTap: () {
                  // TODO: Navigate to privacy settings
                },
              ),
              _SettingsToggleTile(
                icon: Icons.location_on_outlined,
                title: 'Location Services',
                subtitle: 'Allow access to your location',
                value: settings.locationServices,
                onChanged: (value) async {
                  await ref
                      .read(settingsProvider.notifier)
                      .toggleLocationServices(value);
                },
              ),
            ],
            context: context,
          ),
          _buildSection(
            title: 'Appearance',
            children: [
              _SettingsTile(
                icon: Icons.palette_outlined,
                title: 'Theme',
                subtitle: _getThemeSubtitle(themeMode),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getThemeIcon(themeMode),
                      color: AppColors.kprimaryColor500,
                      size: 20,
                    ),
                    const Gap(8),
                    Icon(
                      Icons.chevron_right,
                      color:
                          Theme.of(context).iconTheme.color?.withOpacity(0.4),
                    ),
                  ],
                ),
                onTap: () {
                  _showThemeDialog(context, ref, themeMode);
                },
              ),
              _SettingsTile(
                icon: Icons.font_download_outlined,
                title: 'Text Size',
                subtitle: 'Adjust app text size',
                trailing: Text(
                  '${(settings.textScale * 100).toInt()}%',
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  _showTextSizeDialog(context, ref, settings.textScale);
                },
              ),
            ],
            context: context,
          ),
          _buildSection(
            title: 'Support',
            children: [
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {
                  // TODO: Navigate to help center
                },
              ),
              _SettingsTile(
                icon: Icons.feedback_outlined,
                title: 'Send Feedback',
                onTap: () {
                  // TODO: Navigate to feedback form
                },
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'Version 1.0.0',
                onTap: () {
                  // TODO: Show about dialog
                },
              ),
            ],
            context: context,
          ),
          const Gap(32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: () {
                // TODO: Handle logout
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Delete Account',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const Gap(32),
        ],
      ),
    );
  }

  String _getThemeSubtitle(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 'Follow system setting';
      case ThemeMode.light:
        return 'Light theme';
      case ThemeMode.dark:
        return 'Dark theme';
    }
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return Icons.settings_system_daydream_outlined;
      case ThemeMode.light:
        return Icons.light_mode_outlined;
      case ThemeMode.dark:
        return Icons.dark_mode_outlined;
    }
  }

  Future<void> _showThemeDialog(
      BuildContext context, WidgetRef ref, ThemeMode currentTheme) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          'Choose Theme',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ThemeOptionTile(
              icon: Icons.settings_system_daydream_outlined,
              title: 'System',
              subtitle: 'Follow your device setting',
              isSelected: currentTheme == ThemeMode.system,
              onTap: () {
                ref.read(themeProvider.notifier).setTheme(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            const Gap(8),
            _ThemeOptionTile(
              icon: Icons.light_mode_outlined,
              title: 'Light',
              subtitle: 'Light theme',
              isSelected: currentTheme == ThemeMode.light,
              onTap: () {
                ref.read(themeProvider.notifier).setTheme(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            const Gap(8),
            _ThemeOptionTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark',
              subtitle: 'Dark theme',
              isSelected: currentTheme == ThemeMode.dark,
              onTap: () {
                ref.read(themeProvider.notifier).setTheme(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTextSizeDialog(
      BuildContext context, WidgetRef ref, double currentScale) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          'Adjust Text Size',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Move the slider to adjust text size',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Gap(16),
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Small',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${(currentScale * 100).toInt()}%',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          'Large',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Gap(8),
                    Slider(
                      value: currentScale,
                      min: 0.8,
                      max: 1.4,
                      divisions: 2,
                      activeColor: AppColors.kprimaryColor500,
                      onChanged: (value) {
                        setState(() {
                          currentScale = value;
                        });
                      },
                    ),
                    const Gap(16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerTheme.color ??
                              Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preview',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Gap(8),
                          Text(
                            'This is how your text will appear with the selected size.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 16 * currentScale,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(settingsProvider.notifier)
                  .updateTextScale(currentScale);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Text(
              'Apply',
              style: TextStyle(
                color: AppColors.kprimaryColor500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      {required String title,
      required List<Widget> children,
      required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.kprimaryColor500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.symmetric(
              horizontal: BorderSide(
                color: Theme.of(context).dividerTheme.color ??
                    Colors.grey.shade200,
                width: 1,
              ),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerTheme.color ?? Colors.grey.shade100,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.kprimaryColor500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.kprimaryColor500,
                size: 20,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const Gap(2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else
              Icon(
                Icons.chevron_right,
                color: theme.iconTheme.color?.withOpacity(0.4),
              ),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerTheme.color ?? Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.kprimaryColor500.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.kprimaryColor500,
              size: 20,
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                if (subtitle != null) ...[
                  const Gap(2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.kprimaryColor500,
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kprimaryColor500.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.kprimaryColor500
                : theme.dividerTheme.color ?? Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.kprimaryColor500
                    : AppColors.kprimaryColor500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.kprimaryColor500,
                size: 20,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.kprimaryColor500
                          : theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.kprimaryColor500,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
