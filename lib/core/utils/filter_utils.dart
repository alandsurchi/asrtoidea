/// Shared filter mapping used by both IdeasDashboard and ProjectExplore notifiers.
/// Returns null when no tab is selected (show all), or the status string for the tab.
class FilterUtils {
  /// Maps a tab index to a status string.
  /// Index 0 = All (null means no filter), 1..N = specific statuses.
  static const List<String?> _statusByIndex = [
    null,           // 0: All
    'In Progress',  // 1
    'To-do',        // 2
    'Completed',    // 3
    'Generated',    // 4
  ];

  /// Returns the status filter string for a given tab [index].
  /// Returns null if the index maps to "All" or is out of range.
  static String? statusForTabIndex(int index) {
    if (index < 0 || index >= _statusByIndex.length) return null;
    return _statusByIndex[index];
  }
}
