/// Unified API Response Model
/// Wraps all backend API responses to provide a consistent structure.
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  
  // Placeholders for Pagination (important for Explore page)
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.currentPage,
    this.totalPages,
    this.totalItems,
  });

  factory ApiResponse.success(T data, {String? message, int? currentPage, int? totalPages, int? totalItems}) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
    );
  }

  factory ApiResponse.error(String message) {
    return ApiResponse(
      success: false,
      message: message,
    );
  }

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? true, // Adjust based on your API
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      currentPage: json['current_page'] as int?,
      totalPages: json['total_pages'] as int?,
      totalItems: json['total_items'] as int?,
    );
  }
}
