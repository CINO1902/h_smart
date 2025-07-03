// To parse this JSON data, do
//
//     final moreReplyToReplyModel = moreReplyToReplyModelFromJson(jsonString);

import 'dart:convert';

MoreReplyToReplyModel moreReplyToReplyModelFromJson(String str) => MoreReplyToReplyModel.fromJson(json.decode(str));

String moreReplyToReplyModelToJson(MoreReplyToReplyModel data) => json.encode(data.toJson());

class MoreReplyToReplyModel {
    bool? error;
    String? message;
    List<Payload>? payload;
    int? repliesCount;
    int? totalCount;

    MoreReplyToReplyModel({
        this.error,
        this.message,
        this.payload,
        this.repliesCount,
        this.totalCount,
    });

    MoreReplyToReplyModel copyWith({
        bool? error,
        String? message,
        List<Payload>? payload,
        int? repliesCount,
        int? totalCount,
    }) => 
        MoreReplyToReplyModel(
            error: error ?? this.error,
            message: message ?? this.message,
            payload: payload ?? this.payload,
            repliesCount: repliesCount ?? this.repliesCount,
            totalCount: totalCount ?? this.totalCount,
        );

    factory MoreReplyToReplyModel.fromJson(Map<String, dynamic> json) => MoreReplyToReplyModel(
        error: json["error"],
        message: json["message"],
        payload: json["payload"] == null ? [] : List<Payload>.from(json["payload"]!.map((x) => Payload.fromJson(x))),
        repliesCount: json["replies_count"],
        totalCount: json["total_count"],
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "payload": payload == null ? [] : List<dynamic>.from(payload!.map((x) => x.toJson())),
        "replies_count": repliesCount,
        "total_count": totalCount,
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
