import 'package:flutter/material.dart';

import 'dart:convert';

GetPost getPostFromJson(String str) => GetPost.fromJson(json.decode(str));

String getPostToJson(GetPost data) => json.encode(data.toJson());

class GetPost {
  bool? error;
  String? message;
  List<Post>? payload;
  int? postCount;

  GetPost({
    this.error,
    this.message,
    this.payload,
    this.postCount,
  });

  GetPost copyWith({
    bool? error,
    String? message,
    List<Post>? payload,
    int? postCount,
  }) =>
      GetPost(
        error: error ?? this.error,
        message: message ?? this.message,
        payload: payload ?? this.payload,
        postCount: postCount ?? this.postCount,
      );

  factory GetPost.fromJson(Map<String, dynamic> json) => GetPost(
        error: json["error"],
        message: json["message"],
        payload: json["payload"] == null
            ? []
            : List<Post>.from(json["payload"]!.map((x) => Post.fromJson(x))),
        postCount: json["post_count"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "payload": payload == null
            ? []
            : List<dynamic>.from(payload!.map((x) => x.toJson())),
        "post_count": postCount,
      };
}

class Post {
  final String id;
  final String content;
  final String doctorId;
  final String doctorName;
  final String? fileContent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final int dislikesCount;
  final int commentsCount;
  final List<String> postTags;
  final String postCategoryId;
  final String postCategoryName;
  final String postStatus;
  final String postVisibility;
  final String userId;
  final List<dynamic>
      comments; // You might want to create a Comment model later

  const Post({
    required this.id,
    required this.content,
    required this.doctorId,
    required this.doctorName,
    this.fileContent,
    required this.createdAt,
    required this.updatedAt,
    required this.likesCount,
    required this.dislikesCount,
    required this.commentsCount,
    required this.postTags,
    required this.postCategoryId,
    required this.postCategoryName,
    required this.postStatus,
    required this.postVisibility,
    required this.userId,
    this.comments = const [],
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      content: json['content'] as String,
      doctorId: json['doctor_id'] as String,
      doctorName: json['doctor_name'] as String,
      fileContent: json['file_content'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      likesCount: json['likes_count'] as int? ?? 0,
      dislikesCount: json['dislikes_count'] as int? ?? 0,
      commentsCount: json['comments_count'] as int? ?? 0,
      postTags: List<String>.from(json['post_tags'] ?? []),
      postCategoryId: json['post_category_id'] as String,
      postCategoryName: json['post_category_name'] as String,
      postStatus: json['post_status'] as String,
      postVisibility: json['post_visibility'] as String,
      userId: json['user_id'] as String,
      comments: List<dynamic>.from(json['comments'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'file_content': fileContent,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'likes_count': likesCount,
      'dislikes_count': dislikesCount,
      'comments_count': commentsCount,
      'post_tags': postTags,
      'post_category_id': postCategoryId,
      'post_category_name': postCategoryName,
      'post_status': postStatus,
      'post_visibility': postVisibility,
      'user_id': userId,
      'comments': comments,
    };
  }
}
