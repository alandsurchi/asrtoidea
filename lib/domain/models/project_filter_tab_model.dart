import '../../../core/app_export.dart';

/// This class is used for filter tab items in the project explore dashboard.

// ignore_for_file: must_be_immutable
class ProjectFilterTabModel extends Equatable {
  ProjectFilterTabModel({this.title, this.count}) {
    title = title ?? "";
    count = count ?? 0;
  }

  String? title;
  int? count;

  ProjectFilterTabModel copyWith({String? title, int? count}) {
    return ProjectFilterTabModel(
      title: title ?? this.title,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [title, count];
}
