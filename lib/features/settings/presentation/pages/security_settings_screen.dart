import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/core/utils/appColor.dart';
import 'package:h_smart/features/settings/presentation/providers/security_provider.dart';

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityState = ref.watch(securityProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Security',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'Password',
            children: [
              _SecurityTile(
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () {
                  context.push('/change-password');
                },
              ),
            ],
            context: context,
          ),
          _buildSection(
            title: 'Biometric Authentication',
            children: [
              if (securityState.isFaceIdAvailable)
                _SecurityToggleTile(
                  icon: Icons.face_outlined,
                  title: 'Face ID',
                  subtitle: 'Use Face ID to sign in quickly',
                  value: securityState.faceIdEnabled,
                  onChanged: (value) async {
                    final success = await ref
                        .read(securityProvider.notifier)
                        .toggleFaceId(value);
                    if (!success && value) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              securityState.isFaceIdAvailable
                                  ? 'Face ID authentication failed'
                                  : 'Face ID is not available on this device',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              if (securityState.isTouchIdAvailable)
                _SecurityToggleTile(
                  icon: Icons.fingerprint_outlined,
                  title: 'Touch ID',
                  subtitle: 'Use Touch ID to sign in quickly',
                  value: securityState.touchIdEnabled,
                  onChanged: (value) async {
                    final success = await ref
                        .read(securityProvider.notifier)
                        .toggleTouchId(value);
                    if (!success && value) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              securityState.isTouchIdAvailable
                                  ? 'Touch ID authentication failed'
                                  : 'Touch ID is not available on this device',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              if (securityState.isPasskeySupported)
                _SecurityToggleTile(
                  icon: Icons.key_outlined,
                  title: 'Passkey',
                  subtitle: 'Use passkey for secure sign-in',
                  value: securityState.passkeyEnabled,
                  onChanged: (value) async {
                    final success = await ref
                        .read(securityProvider.notifier)
                        .togglePasskey(value);
                    if (!success && value) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Passkey is not supported on this device'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              if (!securityState.isFaceIdAvailable &&
                  !securityState.isTouchIdAvailable &&
                  !securityState.isPasskeySupported)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      const Gap(12),
                      Expanded(
                        child: Text(
                          'No biometric authentication methods are available on this device',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            context: context,
          ),
          _buildSection(
            title: 'Two-Factor Authentication',
            children: [
              _SecurityTile(
                icon: Icons.security_outlined,
                title: 'Google Authenticator',
                subtitle: securityState.googleAuthEnabled
                    ? 'Enabled - Tap to manage'
                    : 'Add an extra layer of security',
                trailing: securityState.googleAuthEnabled
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Active',
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : null,
                onTap: () {
                  context.push('/google-authenticator');
                },
              ),
              if (securityState.googleAuthEnabled) ...[
                _SecurityTile(
                  icon: Icons.backup_outlined,
                  title: 'Backup Codes',
                  subtitle: 'Generate backup codes for account recovery',
                  onTap: () {
                    context.push('/backup-codes');
                  },
                ),
              ],
            ],
            context: context,
          ),
          _buildSection(
            title: 'Session Management',
            children: [
              _SecurityTile(
                icon: Icons.devices_outlined,
                title: 'Active Sessions',
                subtitle: 'Manage your active login sessions',
                onTap: () {
                  context.push('/active-sessions');
                },
              ),
              _SecurityTile(
                icon: Icons.logout_outlined,
                title: 'Sign Out All Devices',
                subtitle: 'Sign out from all devices except this one',
                onTap: () {
                  _showSignOutAllDialog(context, ref);
                },
              ),
            ],
            context: context,
          ),
          const Gap(32),
        ],
      ),
    );
  }

  Future<void> _showSignOutAllDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          'Sign Out All Devices',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'This will sign you out from all devices except this one. You\'ll need to sign in again on other devices.',
          style: Theme.of(context).textTheme.bodyMedium,
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
              Navigator.pop(context);
              await ref.read(securityProvider.notifier).signOutAllDevices();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Signed out from all devices'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: Text(
              'Sign Out All',
              style: TextStyle(
                color: Colors.red.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    required BuildContext context,
  }) {
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

class _SecurityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SecurityTile({
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

class _SecurityToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SecurityToggleTile({
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
