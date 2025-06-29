import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Fullview extends StatefulWidget {
  final String imageUrl;
  final String doctorName;
  final String postText;
  final int likesCount;
  final int commentsCount;

  const Fullview({
    super.key,
    required this.imageUrl,
    required this.doctorName,
    required this.postText,
    required this.likesCount,
    required this.commentsCount,
  });

  @override
  State<Fullview> createState() => _FullviewState();
}

class _FullviewState extends State<Fullview> {
  double _dragOffset = 0;
  bool _isDragging = false;
  final GlobalKey<PostInfoBarState> _postInfoBarKey = GlobalKey();

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
      _isDragging = true;
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (_dragOffset.abs() > 100) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _dragOffset = 0;
        _isDragging = false;
      });
    }
  }

  void _handleOverlayTapDown(TapDownDetails details) {
    final postInfoBarContext = _postInfoBarKey.currentContext;
    if (postInfoBarContext != null &&
        _postInfoBarKey.currentState?.isExpanded == true) {
      final box = postInfoBarContext.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero);
      final size = box.size;
      final tapPos = details.globalPosition;
      final rect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
      if (!rect.contains(tapPos)) {
        _postInfoBarKey.currentState?.collapseDescription();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: _handleOverlayTapDown,
        child: Stack(
          children: [
            GestureDetector(
              onVerticalDragUpdate: _handleVerticalDragUpdate,
              onVerticalDragEnd: _handleVerticalDragEnd,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                transform: Matrix4.translationValues(0, _dragOffset, 0),
                color: Colors.black,
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Stack(
                    children: [
                      // Image viewer
                      Center(
                        child: InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: CachedNetworkImage(
                            imageUrl: widget.imageUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Top bar overlay
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          bottom: false,
                          child: Container(
                            height: 56,
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Post info and controls (bottom)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: SafeArea(
                          top: false,
                          child: PostInfoBar(
                            key: _postInfoBarKey,
                            authorName: widget.doctorName,
                            postText: widget.postText,
                            likes: widget.likesCount,
                            comments: widget.commentsCount,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostInfoBar extends StatefulWidget {
  final String? authorName;
  final String? postText;
  final int? likes;
  final int? comments;

  const PostInfoBar({
    super.key,
    this.authorName,
    this.postText,
    this.likes,
    this.comments,
  });

  @override
  State<PostInfoBar> createState() => PostInfoBarState();
}

class PostInfoBarState extends State<PostInfoBar> {
  bool _expanded = false;
  bool _showSeeMore = false;
  final int _maxLines = 2;
  late String? _postText;
  final GlobalKey _descKey = GlobalKey();

  bool get isExpanded => _expanded;
  void collapseDescription() {
    if (_expanded) setState(() => _expanded = false);
  }

  @override
  void initState() {
    super.initState();
    _postText = widget.postText;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_postText != null) {
        final textSpan = TextSpan(text: _postText);
        final tp = TextPainter(
          text: textSpan,
          maxLines: _maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: MediaQuery.of(context).size.width - 90);
        if (tp.didExceedMaxLines) {
          setState(() {
            _showSeeMore = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxDescriptionHeight = MediaQuery.of(context).size.height * 0.5;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.authorName != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 18,
                  child: Text(
                    widget.authorName![0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.authorName!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: () {
                    if (_expanded) setState(() => _expanded = false);
                  },
                  tooltip: 'Collapse',
                ),
              ],
            ),
          if (_postText != null) ...[
            const SizedBox(height: 8),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: _expanded
                  ? ConstrainedBox(
                      key: _descKey,
                      constraints: BoxConstraints(
                        maxHeight: maxDescriptionHeight,
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          child: Text(
                            _postText!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _postText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          maxLines: _maxLines,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_showSeeMore && !_expanded)
                          GestureDetector(
                            onTap: () => setState(() => _expanded = true),
                            child: const Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Text(
                                'See more',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              if (widget.comments != null) ...[
                const Icon(Icons.mode_comment_outlined,
                    color: Colors.white54, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${widget.comments}',
                  style: const TextStyle(color: Colors.white54),
                ),
                const SizedBox(width: 16),
              ],
              if (widget.likes != null) ...[
                const Icon(Icons.favorite_border,
                    color: Colors.white54, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${widget.likes}',
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
