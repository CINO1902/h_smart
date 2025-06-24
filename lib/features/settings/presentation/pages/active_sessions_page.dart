import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:h_smart/core/utils/appColor.dart';

class ActiveSessionsPage extends ConsumerStatefulWidget {
  const ActiveSessionsPage({super.key});

  @override
  ConsumerState<ActiveSessionsPage> createState() => _ActiveSessionsPageState();
}

class _ActiveSessionsPageState extends ConsumerState<ActiveSessionsPage> {
  final List<SessionInfo> _sessions = [
    SessionInfo(
      id: '1',
      deviceName: 'iPhone 15 Pro',
      location: 'San Francisco, CA',
      lastActive: DateTime.now().subtract(const Duration(minutes: 5)),
      isCurrent: true,
      deviceType: DeviceType.mobile,
    ),
    SessionInfo(
      id: '2',
      deviceName: 'MacBook Pro',
      location: 'San Francisco, CA',
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      isCurrent: false,
      deviceType: DeviceType.desktop,
    ),
    SessionInfo(
      id: '3',
      deviceName: 'iPad Air',
      location: 'New York, NY',
      lastActive: DateTime.now().subtract(const Duration(days: 1)),
      isCurrent: false,
      deviceType: DeviceType.tablet,
    ),
    SessionInfo(
      id: '4',
      deviceName: 'Chrome Browser',
      location: 'London, UK',
      lastActive: DateTime.now().subtract(const Duration(days: 3)),
      isCurrent: false,
      deviceType: DeviceType.browser,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Active Sessions',
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
      body: Column(
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.1),
                        Colors.purple.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.devices_outlined,
                          color: Colors.blue.shade600,
                          size: 24,
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active Sessions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.color,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              'Manage your active login sessions across devices',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(24),

                // Summary
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Total Sessions',
                        value: _sessions.length.toString(),
                        icon: Icons.devices,
                        color: Colors.blue,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Current Device',
                        value: '1',
                        icon: Icons.phone_android,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Sessions list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _sessions.length,
              itemBuilder: (context, index) {
                final session = _sessions[index];
                return _buildSessionCard(session);
              },
            ),
          ),

          // Bottom action
          Container(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _signOutAllOtherDevices,
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out All Other Devices'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade600,
                  side: BorderSide(color: Colors.red.shade600),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const Gap(8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const Gap(4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(SessionInfo session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: session.isCurrent
              ? Colors.green.withOpacity(0.3)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getDeviceColor(session.deviceType).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getDeviceIcon(session.deviceType),
                    color: _getDeviceColor(session.deviceType),
                    size: 20,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            session.deviceName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.color,
                            ),
                          ),
                          if (session.isCurrent) ...[
                            const Gap(8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Current',
                                style: TextStyle(
                                  color: Colors.green.shade600,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Gap(4),
                      Text(
                        session.location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!session.isCurrent)
                  IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color:
                          Theme.of(context).iconTheme.color?.withOpacity(0.6),
                    ),
                    onPressed: () => _showSessionOptions(session),
                  ),
              ],
            ),
            const Gap(12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                ),
                const Gap(4),
                Text(
                  'Last active: ${_formatLastActive(session.lastActive)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getDeviceColor(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return Colors.blue;
      case DeviceType.desktop:
        return Colors.purple;
      case DeviceType.tablet:
        return Colors.orange;
      case DeviceType.browser:
        return Colors.green;
    }
  }

  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return Icons.phone_android;
      case DeviceType.desktop:
        return Icons.computer;
      case DeviceType.tablet:
        return Icons.tablet_android;
      case DeviceType.browser:
        return Icons.web;
    }
  }

  String _formatLastActive(DateTime lastActive) {
    final now = DateTime.now();
    final difference = now.difference(lastActive);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  void _showSessionOptions(SessionInfo session) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Gap(24),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Session Details'),
              onTap: () {
                Navigator.pop(context);
                _showSessionDetails(session);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red.shade600),
              title: Text(
                'Sign Out This Device',
                style: TextStyle(color: Colors.red.shade600),
              ),
              onTap: () {
                Navigator.pop(context);
                _signOutDevice(session);
              },
            ),
            const Gap(16),
          ],
        ),
      ),
    );
  }

  void _showSessionDetails(SessionInfo session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          'Session Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Device', session.deviceName),
            _buildDetailRow('Location', session.location),
            _buildDetailRow(
                'Last Active', _formatLastActive(session.lastActive)),
            _buildDetailRow('IP Address', '192.168.1.100'),
            _buildDetailRow('User Agent', 'Mozilla/5.0...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const Gap(4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  void _signOutDevice(SessionInfo session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          'Sign Out Device',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to sign out from ${session.deviceName}?',
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
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement sign out API call
              setState(() {
                _sessions.removeWhere((s) => s.id == session.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Signed out from ${session.deviceName}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(
              'Sign Out',
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

  void _signOutAllOtherDevices() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Text(
          'Sign Out All Other Devices',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'This will sign you out from all devices except this one. Are you sure?',
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
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement sign out all API call
              setState(() {
                _sessions.removeWhere((s) => !s.isCurrent);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Signed out from all other devices'),
                  backgroundColor: Colors.green,
                ),
              );
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
}

class SessionInfo {
  final String id;
  final String deviceName;
  final String location;
  final DateTime lastActive;
  final bool isCurrent;
  final DeviceType deviceType;

  SessionInfo({
    required this.id,
    required this.deviceName,
    required this.location,
    required this.lastActive,
    required this.isCurrent,
    required this.deviceType,
  });
}

enum DeviceType {
  mobile,
  desktop,
  tablet,
  browser,
}
