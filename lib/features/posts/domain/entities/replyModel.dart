// To parse this JSON data, do
//
//     final replyModel = replyModelFromJson(jsonString);

import 'dart:convert';

import 'package:h_smart/features/posts/domain/entities/getpostbyId.dart';

ReplyModel replyModelFromJson(String str) => ReplyModel.fromJson(json.decode(str));

String replyModelToJson(ReplyModel data) => json.encode(data.toJson());

class ReplyModel {
    bool? error;
    String? message;
    ReplyEntity? payload;
    int? repliesCount;
    int? totalCount;

    ReplyModel({
        this.error,
        this.message,
        this.payload,
        this.repliesCount,
        this.totalCount,
    });

    ReplyModel copyWith({
        bool? error,
        String? message,
        ReplyEntity? payload,
        int? repliesCount,
        int? totalCount,
    }) => 
        ReplyModel(
            error: error ?? this.error,
            message: message ?? this.message,
            payload: payload ?? this.payload,
            repliesCount: repliesCount ?? this.repliesCount,
            totalCount: totalCount ?? this.totalCount,
        );

    factory ReplyModel.fromJson(Map<String, dynamic> json) => ReplyModel(
        error: json["error"],
        message: json["message"],
        payload: json["payload"] == null ? null : ReplyEntity.fromJson(json["payload"]),
        repliesCount: json["replies_count"],
        totalCount: json["total_count"],
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "payload": payload?.toJson(),
        "replies_count": repliesCount,
        "total_count": totalCount,
    };
}


class ReplyEntity {
    List<Reply>? replies;
    int? repliesCount;
    int? totalCount;

    ReplyEntity({
        this.replies,
        this.repliesCount,
        this.totalCount,
    });

    ReplyEntity copyWith({
        List<Reply>? replies,
        int? repliesCount,
        int? totalCount,
    }) => 
        ReplyEntity(
            replies: replies ?? this.replies,
            repliesCount: repliesCount ?? this.repliesCount,
            totalCount: totalCount ?? this.totalCount,
        );

    factory ReplyEntity.fromJson(Map<String, dynamic> json) => ReplyEntity(
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
