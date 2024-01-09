
import 'dart:convert';

SetUpHealthIssue setUpHealthIssueFromJson(String str) =>
    SetUpHealthIssue.fromJson(json.decode(str));

String setUpHealthIssueToJson(SetUpHealthIssue data) =>
    json.encode(data.toJson());

class SetUpHealthIssue {
  String sex;
  String bloodType;
  String allergies;
  String? chronicConditions;

  SetUpHealthIssue({
    required this.sex,
    required this.bloodType,
    required this.allergies,
    this.chronicConditions,
  });

  factory SetUpHealthIssue.fromJson(Map<String, dynamic> json) =>
      SetUpHealthIssue(
        sex: json["sex"],
        bloodType: json["blood_type"],
        allergies: json["allergies"],
        chronicConditions: json["chronic_conditions"],
      );

  Map<String, dynamic> toJson() => {
        "sex": sex,
        "blood_type": bloodType,
        "allergies": allergies,
        "chronic_conditions": chronicConditions,
      };
}
