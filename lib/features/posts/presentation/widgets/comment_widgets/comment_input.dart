import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/core/theme/theme_mode_provider.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';

class CommentInput extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSendPressed;
  final String hintText;

  const CommentInput({
    super.key,
    required this.controller,
    this.onSendPressed,
    this.hintText = 'Add a comment...',
  });

  @override
  ConsumerState<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<CommentInput> {
  @override
  Widget build(BuildContext context) {
    final String userImage =
        ref.watch(authProvider).userData?.patientMetadata?.profileUrl ?? '';
    final String userName = ref.watch(authProvider).userData?.firstName ?? '';
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(themeModeCheckerProvider)(context);

    return Container(
      color: theme.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color.fromARGB(255, 45, 45, 45)
                : const Color.fromARGB(255, 222, 222, 222),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipOval(
                child: userImage.isEmpty
                    ? CircleAvatar(
                        radius: 22,
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.1),
                        child: Text(
                          ref
                                  .watch(authProvider)
                                  .userData
                                  ?.firstName?[0]
                                  .toUpperCase() ??
                              '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      )
                    : Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: userImage,
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
              const Gap(10),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  minLines: 1,
                  maxLines: 4,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceVariant,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(8),
              Material(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: widget.onSendPressed,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.send,
                      color: theme.colorScheme.onPrimary,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
