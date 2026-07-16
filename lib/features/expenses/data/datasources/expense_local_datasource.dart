import '../../domain/entities/expense.dart';
import '../../../../core/constants/payment_method.dart';

abstract class ExpenseLocalDataSource {
  Future<List<Expense>> getAll({int? offset, int? limit});
  Future<Expense?> getById(int id);
  Future<int> create(Expense expense);
  Future<void> update(Expense expense);
  Future<void> delete(int id);
  Future<List<Expense>> search(String query);
  Future<List<Expense>> getByCategory(int categoryId);
  Future<List<Expense>> getByDateRange(DateTime start, DateTime end);
  Future<List<Expense>> getFiltered({
    int? categoryId,
    PaymentMethod? paymentMethod,
    DateTime? startDate,
    DateTime? endDate,
    String? sortBy,
    bool descending,
    int? offset,
    int? limit,
  });
  Future<int> getCount();
  Future<List<Expense>> getRecent({int count = 5});
}
