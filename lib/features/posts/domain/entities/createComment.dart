// To parse this JSON data, do
//
//     final createComment = createCommentFromJson(jsonString);

import 'dart:convert';

CreateComment createCommentFromJson(String str) => CreateComment.fromJson(json.decode(str));

String createCommentToJson(CreateComment data) => json.encode(data.toJson());

class CreateComment {
    bool? error;
    String? message;
    CommentResponse? payload;

    CreateComment({
        this.error,
        this.message,
        this.payload,
    });

    CreateComment copyWith({
        bool? error,
        String? message,
        CommentResponse? payload,
    }) => 
        CreateComment(
            error: error ?? this.error,
            message: message ?? this.message,
            payload: payload ?? this.payload,
        );

    factory CreateComment.fromJson(Map<String, dynamic> json) => CreateComment(
        error: json["error"],
        message: json["message"],
        payload: json["payload"] == null ? null : CommentResponse.fromJson(json["payload"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "payload": payload?.toJson(),
    };
}

class CommentResponse {
    String? comment;
    DateTime? createdAt;
    String? id;
    String? postId;
    dynamic replies;
    DateTime? updatedAt;
    String? userId;
    String? userImage;
    String? userName;

    CommentResponse({
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

    CommentResponse copyWith({
        String? comment,
        DateTime? createdAt,
        String? id,
        String? postId,
        dynamic replies,
        DateTime? updatedAt,
        String? userId,
        String? userImage,
        String? userName,
    }) => 
        CommentResponse(
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

    factory CommentResponse.fromJson(Map<String, dynamic> json) => CommentResponse(
        comment: json["comment"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
        postId: json["post_id"],
        replies: json["replies"],
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
        "replies": replies,
        "updated_at": updatedAt?.toIso8601String(),
        "user_id": userId,
        "user_image": userImage,
        "user_name": userName,
    };
}
