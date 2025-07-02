import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:h_smart/core/theme/theme_mode_provider.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';

class CommentInput extends ConsumerStatefulWidget {
  final VoidCallback? onSendPressed;
  final String hintText;
  final Function(String)? onMarkupChanged;
  final String? replyToUsername;
  final TextEditingController? controller;

  const CommentInput({
    super.key,
    this.onSendPressed,
    this.hintText = 'Add a comment...',
    this.onMarkupChanged,
    this.replyToUsername,
    this.controller,
  });

  @override
  ConsumerState<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends ConsumerState<CommentInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final String userImage =
        ref.watch(authProvider).userData?.patientMetadata?.profileUrl ?? '';
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
                        child: Image.network(
                          userImage,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                  cursorColor: theme.colorScheme.primary,
                  decoration: InputDecoration(
                    hintText: widget.replyToUsername != null
                        ? 'Reply to ${widget.replyToUsername}'
                        : widget.hintText,
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceVariant,
                  ),
                  onChanged: (val) {
                    if (widget.onMarkupChanged != null) {
                      widget.onMarkupChanged!(val);
                    }
                  },
                  minLines: 1,
                  maxLines: 4,
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: widget.onSendPressed,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
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
