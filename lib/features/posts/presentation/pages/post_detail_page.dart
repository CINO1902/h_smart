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
import 'package:h_smart/features/posts/presentation/widgets/comment_widgets/loading_comment_box.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  final Post post;
  final WidgetRef? parentRef;
  const PostDetailPage({super.key, required this.post, this.parentRef});

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  final ScrollController _scrollController = ScrollController();
  String? _pendingComment;
  String _commentText = '';
  String? _replyToUsername;
  String? _replyingCommentId;
  String? _pendingReply;
  String? _replyToReplyUsername;
  String? _replyingReplyId;
  String? _pendingReplyToReply;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _commentsScrollController = ScrollController();
  late final ProviderSubscription<CreateCommentResult>
      _removeCreateCommentListener;
  late final ProviderSubscription<CreateReplyResult> _removeCreateReplyListener;
  late final ProviderSubscription<CreateReplytoReplyResult>
      _removeCreateReplyToReplyListener;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _commentsScrollController.addListener(_onCommentsScroll);
    // Call getComments when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      (widget.parentRef ?? ref)
          .read(postsProvider.notifier)
          .getComments(widget.post.id ?? '');
    });
    _removeCreateCommentListener =
        (widget.parentRef ?? ref).listenManual<CreateCommentResult>(
      postsProvider.select((p) => p.createCommentResult),
      (previous, next) {
        if (next.state == CreateCommentResultState.isData) {
          setState(() {
            _pendingComment = null;
          });
          _commentController.clear();
          SnackBarService.notifyAction(context,
              message: 'Comment posted successfully',
              status: SnackbarStatus.success);
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
    _removeCreateReplyListener =
        (widget.parentRef ?? ref).listenManual<CreateReplyResult>(
      postsProvider.select((p) => p.createReplyResult),
      (previous, next) {
        if (next.state == CreateReplyResultState.isData) {
          setState(() {
            _pendingReply = null;
            _replyToUsername = null;
            _replyingCommentId = null;
          });
          _commentController.clear();
          SnackBarService.notifyAction(context,
              message: 'Reply posted successfully',
              status: SnackbarStatus.success);
        } else if (next.state == CreateReplyResultState.isError) {
          setState(() {
            _pendingReply = null;
          });
          SnackBarService.notifyAction(context,
              message: next.response.message ??
                  'Failed to post reply. Please try again.',
              status: SnackbarStatus.fail);
        }
      },
    );
    _removeCreateReplyToReplyListener =
        (widget.parentRef ?? ref).listenManual<CreateReplytoReplyResult>(
      postsProvider.select((p) => p.createReplyToReplyResult),
      (previous, next) {
        if (next.state == CreateReplytoReplyState.isData) {
          setState(() {
            _pendingReplyToReply = null;
            _replyToReplyUsername = null;
            _replyingReplyId = null;
          });
          _commentController.clear();
          SnackBarService.notifyAction(context,
              message: 'Reply to reply posted successfully',
              status: SnackbarStatus.success);
        } else if (next.state == CreateReplytoReplyState.isError) {
          setState(() {
            _pendingReplyToReply = null;
          });
          SnackBarService.notifyAction(context,
              message: next.response.message ??
                  'Failed to post reply to reply. Please try again.',
              status: SnackbarStatus.fail);
        }
      },
    );
  }

  void _onCommentsScroll() {
    final controller = _commentsScrollController;
    if (!controller.hasClients) return;
    final postsController =
        (widget.parentRef ?? ref).read(postsProvider.notifier);
    final state = (widget.parentRef ?? ref).read(postsProvider);
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 100) {
      if (state.hasMoreComments && !state.isLoadingMoreComments) {
        postsController.loadMoreComments(widget.post.id ?? '');
      }
    }
  }

  void _onScroll() {
    // Dismiss keyboard when scrolling
    FocusScope.of(context).unfocus();

    final controller = _scrollController;
    if (!controller.hasClients) return;
    final postsController =
        (widget.parentRef ?? ref).read(postsProvider.notifier);
    final state = (widget.parentRef ?? ref).read(postsProvider);
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 200) {
      if (state.hasMoreComments && !state.isLoadingMoreComments) {
        postsController.loadMoreComments(widget.post.id ?? '');
      }
    }
  }

  void _handleReply(String userName, String commentId) {
    setState(() {
      _replyToUsername = userName;
      _replyingCommentId = commentId;
      _replyToReplyUsername = null;
      _replyingReplyId = null;
    });
  }

  void _handleReplyToReply(String userName, String replyId, String commentId) {
    setState(() {
      _replyToReplyUsername = userName;
      _replyingReplyId = replyId;
      _replyingCommentId = commentId;
      _replyToUsername = null;
    });
  }

  void _onSendComment() {
    if (_commentText.trim().isEmpty) {
      SnackBarService.notifyAction(context,
          message: 'Comment is empty', status: SnackbarStatus.fail);
      return;
    }

    // Enforce max length for each type
    if (_replyToReplyUsername != null && _replyingReplyId != null) {
      if (_commentText.length > 150) {
        SnackBarService.notifyAction(context,
            message: 'Reply to reply cannot exceed 50 characters',
            status: SnackbarStatus.fail);
        return;
      }
      setState(() {
        _pendingReplyToReply = _commentText;
      });
      (widget.parentRef ?? ref).read(postsProvider.notifier).createReplyToReply(
          _replyingReplyId!, _commentText, _replyingCommentId!);
    } else if (_replyToUsername != null && _replyingCommentId != null) {
      if (_commentText.length > 250) {
        SnackBarService.notifyAction(context,
            message: 'Reply cannot exceed 80 characters',
            status: SnackbarStatus.fail);
        return;
      }
      setState(() {
        _pendingReply = _commentText;
      });
      (widget.parentRef ?? ref)
          .read(postsProvider.notifier)
          .createReply(_replyingCommentId!, _commentText);
    } else {
      if (_commentText.length > 400) {
        SnackBarService.notifyAction(context,
            message: 'Comment cannot exceed 100 characters',
            status: SnackbarStatus.fail);
        return;
      }
      setState(() {
        _pendingComment = _commentText;
      });
      (widget.parentRef ?? ref)
          .read(postsProvider.notifier)
          .createComment(widget.post.id ?? '', _commentText);
    }
  }

  @override
  void dispose() {
    _removeCreateCommentListener.close();
    _removeCreateReplyListener.close();
    _removeCreateReplyToReplyListener.close();
    _scrollController.dispose();
    _commentsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final postsController = (widget.parentRef ?? ref).watch(postsProvider);
    final commentResult = postsController.commentResult;
    final createCommentResult = postsController.createCommentResult;
    final createReplyResult = postsController.createReplyResult;
    final createReplyToReplyResult = postsController.createReplyToReplyResult;

    return Portal(
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, popResult) {
          if (didPop) {
            (widget.parentRef ?? ref)
                .read(postsProvider.notifier)
                .clearRepliesState();
          }
        },
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
                          commentResult,
                          createCommentResult.state,
                          createReplyResult.state,
                          createReplyToReplyResult.state),
                    ),
                    const SliverToBoxAdapter(child: Gap(140)),
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
                            const Icon(Icons.reply,
                                color: Colors.blue, size: 18),
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
                                  _replyingCommentId = null;
                                });
                              },
                              child: const Icon(Icons.close,
                                  color: Colors.blue, size: 18),
                            ),
                          ],
                        ),
                      ),
                    if (_replyToReplyUsername != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          border: Border.all(color: Colors.green.shade100),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.reply_all,
                                color: Colors.green, size: 18),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _replyToReplyUsername!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _replyToReplyUsername = null;
                                  _replyingReplyId = null;
                                });
                              },
                              child: const Icon(Icons.close,
                                  color: Colors.green, size: 18),
                            ),
                          ],
                        ),
                      ),
                    if (_replyToUsername != null)
                      Divider(
                          height: 1, color: Colors.blue.shade100, thickness: 1),
                    if (_replyToReplyUsername != null)
                      Divider(
                          height: 1,
                          color: Colors.green.shade100,
                          thickness: 1),
                    CommentInput(
                      onSendPressed: _onSendComment,
                      onMarkupChanged: (markup) {
                        _commentText = markup;
                      },
                      replyToUsername:
                          _replyToReplyUsername ?? _replyToUsername,
                      controller: _commentController,
                      isLoading: createCommentResult.state ==
                              CreateCommentResultState.isLoading ||
                          createReplyResult.state ==
                              CreateReplyResultState.isLoading ||
                          createReplyToReplyResult.state ==
                              CreateReplytoReplyState.isLoading,
                      maxLength: _replyToReplyUsername != null &&
                              _replyingReplyId != null
                          ? 150
                          : _replyToUsername != null &&
                                  _replyingCommentId != null
                              ? 250
                              : 400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsSection(
      CommentResult commentResult,
      CreateCommentResultState createCommentState,
      CreateReplyResultState createReplyState,
      CreateReplytoReplyState createReplyToReplyState) {
    final user = (widget.parentRef ?? ref).watch(authProvider).userData;
    final userName = user?.firstName ?? 'You';
    final userImage = user?.patientMetadata?.profileUrl ?? '';
    final postsController = (widget.parentRef ?? ref).watch(postsProvider);

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
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromARGB(255, 61, 61, 61)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar shimmer
                    ShimmerWidget(height: 36, width: 36),
                    Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerWidget(
                                height: 16,
                                width: 120,
                              ),
                              Gap(8),
                              ShimmerWidget(
                                height: 12,
                                width: 60,
                              ),
                            ],
                          ),
                          Gap(8),
                          ShimmerWidget(
                            height: 14,
                            width: double.infinity,
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
                    (widget.parentRef ?? ref)
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
        final commentsObj = commentResult.response.payload?.comments;
        final comments = commentsObj?.comments ?? [];
        if ((comments.isEmpty) &&
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
            ...comments.map((comment) => RealCommentBox(
                  comment: comment,
                  ref: ref,
                  onReplyPressed: (userName) =>
                      _handleReply(userName, comment.id ?? ''),
                  onReplyToReplyPressed: (userName, replyId, commentId) =>
                      _handleReplyToReply(userName, replyId, commentId),
                  replies: comment.replies?.replies?.map((reply) {
                    return reply;
                  }).toList(),
                  showLoadingReplyBox:
                      createReplyState == CreateReplyResultState.isLoading &&
                          _pendingReply != null &&
                          _replyingCommentId == comment.id,
                  loadingReplyText: _pendingReply,
                  loadingReplyUserName: userName,
                  loadingReplyUserImage: userImage,
                  showShowMoreRepliesButton: (widget.parentRef ?? ref)
                      .watch(postsProvider)
                      .hasMoreRepliesForComment(comment.id ?? ''),
                  isLoadingMoreReplies: postsController
                      .isLoadingMoreRepliesForComment(comment.id ?? ''),
                  onShowMoreReplies: () {
                    (widget.parentRef ?? ref)
                        .read(postsProvider.notifier)
                        .loadMoreReplies(comment.id ?? '');
                  },
                  showNestedReplies: true,
                  showShowMoreNestedRepliesButton: (widget.parentRef ?? ref)
                      .watch(postsProvider)
                      .hasMoreNestedRepliesForReply(comment.id ?? ''),
                  isLoadingMoreNestedReplies: postsController
                      .isLoadingMoreNestedRepliesForReply(comment.id ?? ''),
                  onShowMoreNestedReplies: null,
                  loadingReplyToReplyText: _pendingReplyToReply,
                  loadingReplyToReplyUserName: userName,
                  loadingReplyToReplyUserImage: userImage,
                  replyingReplyId: _replyingReplyId,
                  createReplyToReplyState: createReplyToReplyState,
                )),
            if (postsController.isLoadingMoreComments)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
            if (!postsController.hasMoreComments && comments.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    'No more comments',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              ),
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
