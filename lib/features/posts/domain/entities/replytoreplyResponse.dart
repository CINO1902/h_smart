// To parse this JSON data, do
//
//     final replyToReplyModel = replyToReplyModelFromJson(jsonString);

import 'dart:convert';

ReplyToReplyModel replyToReplyModelFromJson(String str) => ReplyToReplyModel.fromJson(json.decode(str));

String replyToReplyModelToJson(ReplyToReplyModel data) => json.encode(data.toJson());

class ReplyToReplyModel {
    bool? error;
    String? message;
    Payload? payload;

    ReplyToReplyModel({
        this.error,
        this.message,
        this.payload,
    });

    ReplyToReplyModel copyWith({
        bool? error,
        String? message,
        Payload? payload,
    }) => 
        ReplyToReplyModel(
            error: error ?? this.error,
            message: message ?? this.message,
            payload: payload ?? this.payload,
        );

    factory ReplyToReplyModel.fromJson(Map<String, dynamic> json) => ReplyToReplyModel(
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
    String? commentId;
    String? id;
    String? reply;
    String? replyId;
    String? userId;
    dynamic userImage;
    String? userName;

    Payload({
        this.commentId,
        this.id,
        this.reply,
        this.replyId,
        this.userId,
        this.userImage,
        this.userName,
    });

    Payload copyWith({
        String? commentId,
        String? id,
        String? reply,
        String? replyId,
        String? userId,
        dynamic userImage,
        String? userName,
    }) => 
        Payload(
            commentId: commentId ?? this.commentId,
            id: id ?? this.id,
            reply: reply ?? this.reply,
            replyId: replyId ?? this.replyId,
            userId: userId ?? this.userId,
            userImage: userImage ?? this.userImage,
            userName: userName ?? this.userName,
        );

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        commentId: json["comment_id"],
        id: json["id"],
        reply: json["reply"],
        replyId: json["reply_id"],
        userId: json["user_id"],
        userImage: json["user_image"],
        userName: json["user_name"],
    );

    Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "id": id,
        "reply": reply,
        "reply_id": replyId,
        "user_id": userId,
        "user_image": userImage,
        "user_name": userName,
    };
}
