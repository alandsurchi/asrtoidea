import '../../../core/app_export.dart';

/// This class is used in the [IdeasDashboardScreen] screen.

// ignore_for_file: must_be_immutable
class IdeasDashboardModel extends Equatable {
  IdeasDashboardModel({
    this.ideaCardsList,
    this.additionalIdeasList,
    this.allIdeasList,
    this.id,
  }) {
    ideaCardsList = ideaCardsList ?? [];
    additionalIdeasList = additionalIdeasList ?? [];
    allIdeasList = allIdeasList ?? [];
    id = id ?? "";
  }

  List<IdeaCardModel>? ideaCardsList;
  List<IdeaCardModel>? additionalIdeasList;
  List<IdeaCardModel>? allIdeasList;
  String? id;

  IdeasDashboardModel copyWith({
    List<IdeaCardModel>? ideaCardsList,
    List<IdeaCardModel>? additionalIdeasList,
    List<IdeaCardModel>? allIdeasList,
    String? id,
  }) {
    return IdeasDashboardModel(
      ideaCardsList: ideaCardsList ?? this.ideaCardsList,
      additionalIdeasList: additionalIdeasList ?? this.additionalIdeasList,
      allIdeasList: allIdeasList ?? this.allIdeasList,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [ideaCardsList, additionalIdeasList, allIdeasList, id];

  Map<String, dynamic> toJson() {
    return {
      'ideaCardsList': ideaCardsList?.map((e) => e.toJson()).toList(),
      'additionalIdeasList': additionalIdeasList?.map((e) => e.toJson()).toList(),
      'allIdeasList': allIdeasList?.map((e) => e.toJson()).toList(),
      'id': id,
    };
  }

  factory IdeasDashboardModel.fromJson(Map<String, dynamic> json) {
    return IdeasDashboardModel(
      ideaCardsList: (json['ideaCardsList'] as List<dynamic>?)
          ?.map((e) => IdeaCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      additionalIdeasList: (json['additionalIdeasList'] as List<dynamic>?)
          ?.map((e) => IdeaCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      allIdeasList: (json['allIdeasList'] as List<dynamic>?)
          ?.map((e) => IdeaCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String?,
    );
  }
}

class IdeaCardModel extends Equatable {
  IdeaCardModel({
    this.title,
    this.description,
    this.category,
    this.priority,
    this.status,
    this.backgroundImage,
    this.teamMembers,
    this.additionalMembersCount,
    this.id,
    this.timestamp,
  }) {
    title = title ?? "";
    description = description ?? "";
    category = category ?? "";
    priority = priority ?? "";
    status = status ?? "";
    backgroundImage = backgroundImage ?? "";
    teamMembers = teamMembers ?? [];
    additionalMembersCount = additionalMembersCount ?? "";
    id = id ?? "";
    timestamp = timestamp ?? DateTime.now();
  }

  String? title;
  String? description;
  String? category;
  String? priority;
  String? status;
  String? backgroundImage;
  List<TeamMemberModel>? teamMembers;
  String? additionalMembersCount;
  String? id;
  DateTime? timestamp;

  IdeaCardModel copyWith({
    String? title,
    String? description,
    String? category,
    String? priority,
    String? status,
    String? backgroundImage,
    List<TeamMemberModel>? teamMembers,
    String? additionalMembersCount,
    String? id,
    DateTime? timestamp,
  }) {
    return IdeaCardModel(
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      teamMembers: teamMembers ?? this.teamMembers,
      additionalMembersCount:
          additionalMembersCount ?? this.additionalMembersCount,
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      'backgroundImage': backgroundImage,
      'teamMembers': teamMembers?.map((m) => m.toJson()).toList(),
      'additionalMembersCount': additionalMembersCount,
      'id': id,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory IdeaCardModel.fromJson(Map<String, dynamic> json) {
    return IdeaCardModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      priority: json['priority'] as String?,
      status: json['status'] as String?,
      backgroundImage: json['backgroundImage'] as String?,
      teamMembers: json['teamMembers'] != null 
          ? (json['teamMembers'] as List).map((m) => TeamMemberModel.fromJson(m)).toList()
          : null,
      additionalMembersCount: json['additionalMembersCount'] as String?,
      id: json['id'] as String?,
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp'] as String) : null,
    );
  }

  @override
  List<Object?> get props => [
    title,
    description,
    category,
    priority,
    status,
    backgroundImage,
    teamMembers,
    additionalMembersCount,
    id,
    timestamp,
  ];
}

class TeamMemberModel extends Equatable {
  TeamMemberModel({this.profileImage, this.id}) {
    profileImage = profileImage ?? "";
    id = id ?? "";
  }

  String? profileImage;
  String? id;

  TeamMemberModel copyWith({String? profileImage, String? id}) {
    return TeamMemberModel(
      profileImage: profileImage ?? this.profileImage,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileImage': profileImage,
      'id': id,
    };
  }

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      profileImage: json['profileImage'] as String?,
      id: json['id'] as String?,
    );
  }

  @override
  List<Object?> get props => [profileImage, id];
}
