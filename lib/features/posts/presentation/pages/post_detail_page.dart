import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:h_smart/constant/snackbar.dart';
import 'package:h_smart/features/posts/domain/entities/post.dart';
import 'package:h_smart/features/posts/presentation/widgets/index.dart';
import 'package:h_smart/features/posts/presentation/providers/posts_provider.dart';
import 'package:h_smart/features/posts/domain/utils/states/postStates.dart';
import 'package:h_smart/features/auth/presentation/provider/auth_provider.dart';
import 'package:h_smart/features/posts/domain/entities/getpostbyId.dart';
import 'package:h_smart/features/posts/presentation/widgets/comment_widgets/loading_comment_box.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailPage({super.key, required this.post});

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  final GlobalKey<FlutterMentionsState> _mentionsKey =
      GlobalKey<FlutterMentionsState>();
  final ScrollController _scrollController = ScrollController();
  String? _pendingComment;
  String _commentText = '';
  String? _replyToUsername;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Call getComments when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postsProvider.notifier).getComments(widget.post.id ?? '');
    });
  }

  void _onScroll() {
    // Dismiss keyboard when scrolling
    FocusScope.of(context).unfocus();
  }

  void _handleReply(String userName) {
    setState(() {
      _replyToUsername = userName;
    });
  }

  void _onSendComment() {
    if (_commentText.trim().isEmpty) {
      SnackBarService.notifyAction(context,
          message: 'Comment is empty', status: SnackbarStatus.fail);
      return;
    }

    setState(() {
      _pendingComment = _commentText;
      _replyToUsername = null;
    });

    ref
        .read(postsProvider.notifier)
        .createComment(widget.post.id ?? '', _commentText);
    setState(() {
      _commentText = '';
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final postsController = ref.watch(postsProvider);
    final commentResult = postsController.commentResult;
    final createCommentResult = postsController.createCommentResult;

    ref.listen<CreateCommentResult>(
      postsProvider.select((p) => p.createCommentResult),
      (previous, next) {
        if (next.state == CreateCommentResultState.isData) {
          setState(() {
            _pendingComment = null;
          });
        } else if (next.state == CreateCommentResultState.isError) {
          setState(() {
            _pendingComment = null;
          });
          SnackBarService.notifyAction(context,
              message: next.response.message ??
                  'Failed to post comment. Please try again.',
              status: SnackbarStatus.fail);
        }
      },
    );

    return Portal(
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                // Dismiss keyboard when tapping anywhere
                FocusScope.of(context).unfocus();
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    backgroundColor:
                        theme.colorScheme.surface.withOpacity(0.95),
                    elevation: 0,
                    floating: true,
                    snap: true,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: theme.colorScheme.onSurface),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    title: Text(
                      'Post',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.more_horiz,
                            color: theme.colorScheme.onSurface),
                        onPressed: () {},
                      ),
                    ],
                    centerTitle: false,
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PostCardDetail(
                          post: widget.post,
                          onMorePressed: () {},
                          onLikePressed: () {},
                          onCommentPressed: () {},
                          onSharePressed: () {},
                        ),
                        Divider(
                          height: 1,
                          color: theme.colorScheme.outline.withOpacity(0.2),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            'Comments',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildCommentsSection(
                        commentResult, createCommentResult.state),
                  ),
                  const SliverToBoxAdapter(child: Gap(80)),
                ],
              ),
            ),
            // Comment input
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_replyToUsername != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(color: Colors.blue.shade100),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.reply, color: Colors.blue, size: 18),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _replyToUsername!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _replyToUsername = null;
                              });
                            },
                            child: const Icon(Icons.close,
                                color: Colors.blue, size: 18),
                          ),
                        ],
                      ),
                    ),
                  if (_replyToUsername != null)
                    Divider(
                        height: 1, color: Colors.blue.shade100, thickness: 1),
                  CommentInput(
                    onSendPressed: _onSendComment,
                    onMarkupChanged: (markup) {
                      _commentText = markup;
                    },
                    replyToUsername: _replyToUsername,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection(CommentResult commentResult,
      CreateCommentResultState createCommentState) {
    final user = ref.watch(authProvider).userData;
    final userName = user?.firstName ?? 'You';
    final userImage = user?.patientMetadata?.profileUrl ?? '';

    switch (commentResult.state) {
      case CommentResultState.isLoading:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 16,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const Gap(8),
                          Container(
                            height: 14,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      case CommentResultState.isError:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 60,
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Failed to load comments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Please try again later',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(postsProvider.notifier)
                        .getComments(widget.post.id ?? '');
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );

      case CommentResultState.isData:
        final comments = commentResult.response.payload?.comments ?? [];
        if (comments.isEmpty &&
            createCommentState != CreateCommentResultState.isLoading) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No comments yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Be the first to comment!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Column(
          children: [
            if (createCommentState == CreateCommentResultState.isLoading &&
                _pendingComment != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: LoadingCommentBox(
                  userName: userName,
                  userImage: userImage,
                  commentText: _pendingComment!,
                ),
              ),
            ...comments
                .map((comment) => RealCommentBox(
                      comment: comment,
                      ref: ref,
                      onReplyPressed: _handleReply,
                      replies: comment.replies,
                    ))
                .toList(),
          ],
        );

      case CommentResultState.isEmpty:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.comment_outlined,
                  size: 60,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 24),
                Text(
                  'No comments available',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );

      case CommentResultState.isNull:
      default:
        return const Center(
          child: Text('Unknown state'),
        );
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
