// To parse this JSON data, do
//
//     final getPostById = getPostByIdFromJson(jsonString);

import 'dart:convert';

GetPostById getPostByIdFromJson(String str) => GetPostById.fromJson(json.decode(str));

String getPostByIdToJson(GetPostById data) => json.encode(data.toJson());

class GetPostById {
    bool? error;
    String? message;
    Payload? payload;

    GetPostById({
        this.error,
        this.message,
        this.payload,
    });

    GetPostById copyWith({
        bool? error,
        String? message,
        Payload? payload,
    }) => 
        GetPostById(
            error: error ?? this.error,
            message: message ?? this.message,
            payload: payload ?? this.payload,
        );

    factory GetPostById.fromJson(Map<String, dynamic> json) => GetPostById(
        error: json["error"],
        message: json["message"],
        payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "payload": payload?.toJson(),
    };
}

class Payload {
    Comments? comments;
    int? commentsCount;
    String? content;
    DateTime? createdAt;
    int? dislikesCount;
    String? doctorId;
    String? doctorImage;
    String? doctorName;
    String? fileContent;
    String? id;
    int? likesCount;
    String? postCategoryId;
    String? postCategoryName;
    String? postStatus;
    List<String>? postTags;
    String? postVisibility;
    DateTime? updatedAt;
    String? userId;
    String? userProfileUrl;

    Payload({
        this.comments,
        this.commentsCount,
        this.content,
        this.createdAt,
        this.dislikesCount,
        this.doctorId,
        this.doctorImage,
        this.doctorName,
        this.fileContent,
        this.id,
        this.likesCount,
        this.postCategoryId,
        this.postCategoryName,
        this.postStatus,
        this.postTags,
        this.postVisibility,
        this.updatedAt,
        this.userId,
        this.userProfileUrl,
    });

    Payload copyWith({
        Comments? comments,
        int? commentsCount,
        String? content,
        DateTime? createdAt,
        int? dislikesCount,
        String? doctorId,
        String? doctorImage,
        String? doctorName,
        String? fileContent,
        String? id,
        int? likesCount,
        String? postCategoryId,
        String? postCategoryName,
        String? postStatus,
        List<String>? postTags,
        String? postVisibility,
        DateTime? updatedAt,
        String? userId,
        String? userProfileUrl,
    }) => 
        Payload(
            comments: comments ?? this.comments,
            commentsCount: commentsCount ?? this.commentsCount,
            content: content ?? this.content,
            createdAt: createdAt ?? this.createdAt,
            dislikesCount: dislikesCount ?? this.dislikesCount,
            doctorId: doctorId ?? this.doctorId,
            doctorImage: doctorImage ?? this.doctorImage,
            doctorName: doctorName ?? this.doctorName,
            fileContent: fileContent ?? this.fileContent,
            id: id ?? this.id,
            likesCount: likesCount ?? this.likesCount,
            postCategoryId: postCategoryId ?? this.postCategoryId,
            postCategoryName: postCategoryName ?? this.postCategoryName,
            postStatus: postStatus ?? this.postStatus,
            postTags: postTags ?? this.postTags,
            postVisibility: postVisibility ?? this.postVisibility,
            updatedAt: updatedAt ?? this.updatedAt,
            userId: userId ?? this.userId,
            userProfileUrl: userProfileUrl ?? this.userProfileUrl,
        );

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        comments: json["comments"] == null ? null : Comments.fromJson(json["comments"]),
        commentsCount: json["comments_count"],
        content: json["content"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        dislikesCount: json["dislikes_count"],
        doctorId: json["doctor_id"],
        doctorImage: json["doctor_image"],
        doctorName: json["doctor_name"],
        fileContent: json["file_content"],
        id: json["id"],
        likesCount: json["likes_count"],
        postCategoryId: json["post_category_id"],
        postCategoryName: json["post_category_name"],
        postStatus: json["post_status"],
        postTags: json["post_tags"] == null ? [] : List<String>.from(json["post_tags"]!.map((x) => x)),
        postVisibility: json["post_visibility"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        userId: json["user_id"],
        userProfileUrl: json["user_profile_url"],
    );

    Map<String, dynamic> toJson() => {
        "comments": comments?.toJson(),
        "comments_count": commentsCount,
        "content": content,
        "created_at": createdAt?.toIso8601String(),
        "dislikes_count": dislikesCount,
        "doctor_id": doctorId,
        "doctor_image": doctorImage,
        "doctor_name": doctorName,
        "file_content": fileContent,
        "id": id,
        "likes_count": likesCount,
        "post_category_id": postCategoryId,
        "post_category_name": postCategoryName,
        "post_status": postStatus,
        "post_tags": postTags == null ? [] : List<dynamic>.from(postTags!.map((x) => x)),
        "post_visibility": postVisibility,
        "updated_at": updatedAt?.toIso8601String(),
        "user_id": userId,
        "user_profile_url": userProfileUrl,
    };
}

class Comments {
    List<Comment>? comments;
    int? commentsCount;
    int? totalCount;

    Comments({
        this.comments,
        this.commentsCount,
        this.totalCount,
    });

    Comments copyWith({
        List<Comment>? comments,
        int? commentsCount,
        int? totalCount,
    }) => 
        Comments(
            comments: comments ?? this.comments,
            commentsCount: commentsCount ?? this.commentsCount,
            totalCount: totalCount ?? this.totalCount,
        );

    factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
        commentsCount: json["comments_count"],
        totalCount: json["total_count"],
    );

    Map<String, dynamic> toJson() => {
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "comments_count": commentsCount,
        "total_count": totalCount,
    };
}

class Comment {
    String? comment;
    DateTime? createdAt;
    String? id;
    String? postId;
    Repliesreplies? replies;
    DateTime? updatedAt;
    String? userId;
    String? userImage;
    String? userName;

    Comment({
        this.comment,
        this.createdAt,
        this.id,
        this.postId,
        this.replies,
        this.updatedAt,
        this.userId,
        this.userImage,
        this.userName,
    });

    Comment copyWith({
        String? comment,
        DateTime? createdAt,
        String? id,
        String? postId,
        Repliesreplies? replies,
        DateTime? updatedAt,
        String? userId,
        String? userImage,
        String? userName,
    }) => 
        Comment(
            comment: comment ?? this.comment,
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
            postId: postId ?? this.postId,
            replies: replies ?? this.replies,
            updatedAt: updatedAt ?? this.updatedAt,
            userId: userId ?? this.userId,
            userImage: userImage ?? this.userImage,
            userName: userName ?? this.userName,
        );

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        comment: json["comment"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
        postId: json["post_id"],
        replies: json["replies"] == null ? null : Repliesreplies.fromJson(json["replies"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        userId: json["user_id"],
        userImage: json["user_image"],
        userName: json["user_name"],
    );

    Map<String, dynamic> toJson() => {
        "comment": comment,
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "post_id": postId,
        "replies": replies?.toJson(),
        "updated_at": updatedAt?.toIso8601String(),
        "user_id": userId,
        "user_image": userImage,
        "user_name": userName,
    };
}

class Reply {
    String? commentId;
    DateTime? createdAt;
    String? id;
    Repliesreplies? repliesToReplies;
    String? reply;
    DateTime? updatedAt;
    String? userId;
    dynamic userImage;
    String? userName;

    Reply({
        this.commentId,
        this.createdAt,
        this.id,
        this.repliesToReplies,
        this.reply,
        this.updatedAt,
        this.userId,
        this.userImage,
        this.userName,
    });

    Reply copyWith({
        String? commentId,
        DateTime? createdAt,
        String? id,
        Repliesreplies? repliesToReplies,
        String? reply,
        DateTime? updatedAt,
        String? userId,
        dynamic userImage,
        String? userName,
    }) => 
        Reply(
            commentId: commentId ?? this.commentId,
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
            repliesToReplies: repliesToReplies ?? this.repliesToReplies,
            reply: reply ?? this.reply,
            updatedAt: updatedAt ?? this.updatedAt,
            userId: userId ?? this.userId,
            userImage: userImage ?? this.userImage,
            userName: userName ?? this.userName,
        );

    factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        commentId: json["comment_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
        repliesToReplies: json["replies_to_replies"] == null ? null : Repliesreplies.fromJson(json["replies_to_replies"]),
        reply: json["reply"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        userId: json["user_id"],
        userImage: json["user_image"],
        userName: json["user_name"],
    );

    Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "replies_to_replies": repliesToReplies?.toJson(),
        "reply": reply,
        "updated_at": updatedAt?.toIso8601String(),
        "user_id": userId,
        "user_image": userImage,
        "user_name": userName,
    };
}

class Repliesreplies {
    List<Reply>? replies;
    int? repliesCount;
    int? totalCount;

    Repliesreplies({
        this.replies,
        this.repliesCount,
        this.totalCount,
    });

    Repliesreplies copyWith({
        List<Reply>? replies,
        int? repliesCount,
        int? totalCount,
    }) => 
        Repliesreplies(
            replies: replies ?? this.replies,
            repliesCount: repliesCount ?? this.repliesCount,
            totalCount: totalCount ?? this.totalCount,
        );

    factory Repliesreplies.fromJson(Map<String, dynamic> json) => Repliesreplies(
        replies: json["replies"] == null ? [] : List<Reply>.from(json["replies"]!.map((x) => Reply.fromJson(x))),
        repliesCount: json["replies_count"],
        totalCount: json["total_count"],
    );

    Map<String, dynamic> toJson() => {
        "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x.toJson())),
        "replies_count": repliesCount,
        "total_count": totalCount,
    };
}
