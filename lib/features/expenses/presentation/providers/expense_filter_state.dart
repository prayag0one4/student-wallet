import '../../../../core/constants/payment_method.dart';

class ExpenseFilterState {
  final String searchQuery;
  final int? categoryId;
  final PaymentMethod? paymentMethod;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? sortBy;
  final bool descending;

  const ExpenseFilterState({
    this.searchQuery = '',
    this.categoryId,
    this.paymentMethod,
    this.startDate,
    this.endDate,
    this.sortBy,
    this.descending = true,
  });

  ExpenseFilterState copyWith({
    String? searchQuery,
    int? categoryId,
    PaymentMethod? paymentMethod,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
    bool? descending,
    bool clearCategory = false,
    bool clearPaymentMethod = false,
    bool clearDateRange = false,
    bool clearSearch = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return ExpenseFilterState(
      searchQuery: clearSearch ? '' : (searchQuery ?? this.searchQuery),
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      paymentMethod: clearPaymentMethod ? null : (paymentMethod ?? this.paymentMethod),
      startDate: clearDateRange || clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearDateRange || clearEndDate ? null : (endDate ?? this.endDate),
      sortBy: sortBy ?? this.sortBy,
      descending: descending ?? this.descending,
    );
  }

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      categoryId != null ||
      paymentMethod != null ||
      startDate != null ||
      endDate != null;
}
