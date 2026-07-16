import 'package:isar/isar.dart';
import '../constants/payment_method.dart';
import '../../features/expenses/domain/entities/expense.dart';
import '../../features/expenses/domain/entities/category.dart';
import '../../features/expenses/data/models/expense_model.dart';
import '../../features/expenses/data/models/category_model.dart';
import '../../features/ledger/domain/entities/contact.dart';
import '../../features/ledger/domain/entities/ledger_entry.dart';
import '../../features/ledger/data/models/contact_model.dart';
import '../../features/ledger/data/models/ledger_entry_model.dart';

abstract class EntityMapper<E, M> {
  E toEntity(M model);
  M toModel(E entity);
}

class ExpenseMapper implements EntityMapper<Expense, ExpenseModel> {
  @override
  Expense toEntity(ExpenseModel model) {
    return Expense(
      localId: model.id,
      cloudId: model.cloudId,
      amount: model.amount,
      categoryId: model.categoryId,
      description: model.description,
      paymentMethod: _parsePaymentMethod(model.paymentMethod),
      expenseDate: model.expenseDate,
      merchantName: model.merchantName,
      notes: model.notes,
      tags: model.tags,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      deletedAt: model.deletedAt,
      syncStatus: model.syncStatus,
      version: model.version,
    );
  }

  @override
  ExpenseModel toModel(Expense entity) {
    final model = ExpenseModel()
      ..id = entity.localId ?? Isar.autoIncrement
      ..cloudId = entity.cloudId
      ..amount = entity.amount
      ..categoryId = entity.categoryId
      ..description = entity.description
      ..paymentMethod = entity.paymentMethod.name
      ..expenseDate = entity.expenseDate
      ..merchantName = entity.merchantName
      ..notes = entity.notes
      ..tags = entity.tags
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..deletedAt = entity.deletedAt
      ..syncStatus = entity.syncStatus
      ..version = entity.version;
    return model;
  }

  PaymentMethod _parsePaymentMethod(String value) {
    for (final m in PaymentMethod.values) {
      if (m.name == value) return m;
    }
    return PaymentMethod.cash;
  }
}

class ContactMapper implements EntityMapper<Contact, ContactModel> {
  @override
  Contact toEntity(ContactModel model) {
    return Contact(
      localId: model.id,
      cloudId: model.cloudId,
      name: model.name,
      phone: model.phone,
      notes: model.notes,
      avatarColor: model.avatarColor,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      deletedAt: model.deletedAt,
      syncStatus: model.syncStatus,
      version: model.version,
    );
  }

  @override
  ContactModel toModel(Contact entity) {
    final model = ContactModel()
      ..id = entity.localId ?? Isar.autoIncrement
      ..cloudId = entity.cloudId
      ..name = entity.name
      ..phone = entity.phone
      ..notes = entity.notes
      ..avatarColor = entity.avatarColor
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..deletedAt = entity.deletedAt
      ..syncStatus = entity.syncStatus
      ..version = entity.version;
    return model;
  }
}

class LedgerEntryMapper implements EntityMapper<LedgerEntry, LedgerEntryModel> {
  @override
  LedgerEntry toEntity(LedgerEntryModel model) {
    return LedgerEntry(
      localId: model.id,
      cloudId: model.cloudId,
      contactId: model.contactId,
      type: model.type == 'paid' ? LedgerEntryType.paid : LedgerEntryType.received,
      amount: model.amount,
      description: model.description,
      notes: model.notes,
      transactionDate: model.transactionDate,
      dueDate: model.dueDate,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      deletedAt: model.deletedAt,
      syncStatus: model.syncStatus,
      version: model.version,
    );
  }

  @override
  LedgerEntryModel toModel(LedgerEntry entity) {
    final model = LedgerEntryModel()
      ..id = entity.localId ?? Isar.autoIncrement
      ..cloudId = entity.cloudId
      ..contactId = entity.contactId
      ..type = entity.type.name
      ..amount = entity.amount
      ..description = entity.description
      ..notes = entity.notes
      ..transactionDate = entity.transactionDate
      ..dueDate = entity.dueDate
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..deletedAt = entity.deletedAt
      ..syncStatus = entity.syncStatus
      ..version = entity.version;
    return model;
  }
}

class CategoryMapper implements EntityMapper<Category, CategoryModel> {
  @override
  Category toEntity(CategoryModel model) {
    return Category(
      localId: model.id,
      cloudId: model.cloudId,
      name: model.name,
      icon: model.icon,
      color: model.color,
      isDefault: model.isDefault,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      deletedAt: model.deletedAt,
      syncStatus: model.syncStatus,
      version: model.version,
    );
  }

  @override
  CategoryModel toModel(Category entity) {
    final model = CategoryModel()
      ..id = entity.localId ?? Isar.autoIncrement
      ..cloudId = entity.cloudId
      ..name = entity.name
      ..icon = entity.icon
      ..color = entity.color
      ..isDefault = entity.isDefault
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..deletedAt = entity.deletedAt
      ..syncStatus = entity.syncStatus
      ..version = entity.version;
    return model;
  }
}
