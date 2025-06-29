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
    List<Comment>? comments;
    int? commentsCount;
    String? content;
    DateTime? createdAt;
    int? dislikesCount;
    String? doctorId;
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

    Payload({
        this.comments,
        this.commentsCount,
        this.content,
        this.createdAt,
        this.dislikesCount,
        this.doctorId,
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
    });

    Payload copyWith({
        List<Comment>? comments,
        int? commentsCount,
        String? content,
        DateTime? createdAt,
        int? dislikesCount,
        String? doctorId,
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
    }) => 
        Payload(
            comments: comments ?? this.comments,
            commentsCount: commentsCount ?? this.commentsCount,
            content: content ?? this.content,
            createdAt: createdAt ?? this.createdAt,
            dislikesCount: dislikesCount ?? this.dislikesCount,
            doctorId: doctorId ?? this.doctorId,
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
        );

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
        commentsCount: json["comments_count"],
        content: json["content"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        dislikesCount: json["dislikes_count"],
        doctorId: json["doctor_id"],
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
    );

    Map<String, dynamic> toJson() => {
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "comments_count": commentsCount,
        "content": content,
        "created_at": createdAt?.toIso8601String(),
        "dislikes_count": dislikesCount,
        "doctor_id": doctorId,
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
    };
}

class Comment {
    String? comment;
    DateTime? createdAt;
    String? id;
    String? postId;
    List<dynamic>? replies;
    DateTime? updatedAt;
    String? userId;
    dynamic userImage;
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
        List<dynamic>? replies,
        DateTime? updatedAt,
        String? userId,
        dynamic userImage,
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
        replies: json["replies"] == null ? [] : List<dynamic>.from(json["replies"]!.map((x) => x)),
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
        "replies": replies == null ? [] : List<dynamic>.from(replies!.map((x) => x)),
        "updated_at": updatedAt?.toIso8601String(),
        "user_id": userId,
        "user_image": userImage,
        "user_name": userName,
    };
}
