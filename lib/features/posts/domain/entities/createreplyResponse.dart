// To parse this JSON data, do
//
//     final createReplyResponse = createReplyResponseFromJson(jsonString);

import 'dart:convert';

CreateReplyResponse createReplyResponseFromJson(String str) => CreateReplyResponse.fromJson(json.decode(str));

String createReplyResponseToJson(CreateReplyResponse data) => json.encode(data.toJson());

class CreateReplyResponse {
    bool? error;
    String? message;
    ReplyResponse? payload;

    CreateReplyResponse({
        this.error,
        this.message,
        this.payload,
    });

    CreateReplyResponse copyWith({
        bool? error,
        String? message,
        ReplyResponse? payload,
    }) => 
        CreateReplyResponse(
            error: error ?? this.error,
            message: message ?? this.message,
            payload: payload ?? this.payload,
        );

    factory CreateReplyResponse.fromJson(Map<String, dynamic> json) => CreateReplyResponse(
        error: json["error"],
        message: json["message"],
        payload: json["payload"] == null ? null : ReplyResponse.fromJson(json["payload"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "payload": payload?.toJson(),
    };
}

class ReplyResponse {
    String? comment;
    DateTime? createdAt;
    String? id;
    String? postId;
    dynamic replies;
    DateTime? updatedAt;
    String? userId;
    String? userImage;
    String? userName;

    ReplyResponse({
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

    ReplyResponse copyWith({
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
        ReplyResponse(
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

    factory ReplyResponse.fromJson(Map<String, dynamic> json) => ReplyResponse(
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
