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
import '../../features/split/domain/entities/group_entity.dart';
import '../../features/split/domain/entities/group_member_entity.dart';
import '../../features/split/domain/entities/group_expense_entity.dart';
import '../../features/split/domain/entities/expense_share_entity.dart';
import '../../features/split/domain/entities/settlement_entity.dart';
import '../../features/split/domain/entities/split_type.dart';
import '../../features/split/data/models/group_model.dart';
import '../../features/split/data/models/group_member_model.dart';
import '../../features/split/data/models/group_expense_model.dart';
import '../../features/split/data/models/expense_share_model.dart';
import '../../features/split/data/models/settlement_model.dart';

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

class GroupMapper implements EntityMapper<Group, GroupModel> {
  @override
  Group toEntity(GroupModel model) {
    return Group(
      localId: model.id,
      cloudId: model.cloudId,
      name: model.name,
      icon: model.icon,
      color: model.color,
      description: model.description,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      deletedAt: model.deletedAt,
      syncStatus: model.syncStatus,
      version: model.version,
    );
  }

  @override
  GroupModel toModel(Group entity) {
    final model = GroupModel()
      ..id = entity.localId ?? Isar.autoIncrement
      ..cloudId = entity.cloudId
      ..name = entity.name
      ..icon = entity.icon
      ..color = entity.color
      ..description = entity.description
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..deletedAt = entity.deletedAt
      ..syncStatus = entity.syncStatus
      ..version = entity.version;
    return model;
  }
}

class GroupMemberMapper implements EntityMapper<GroupMember, GroupMemberModel> {
  @override
  GroupMember toEntity(GroupMemberModel model) {
    return GroupMember(
      localId: model.id,
      cloudId: model.cloudId,
      groupId: model.groupId,
      name: model.name,
      phone: model.phone,
      avatarColor: model.avatarColor,
      notes: model.notes,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      syncStatus: model.syncStatus,
      version: model.version,
    );
  }

  @override
  GroupMemberModel toModel(GroupMember entity) {
    final model = GroupMemberModel()
      ..id = entity.localId ?? Isar.autoIncrement
      ..cloudId = entity.cloudId
      ..groupId = entity.groupId
      ..name = entity.name
      ..phone = entity.phone
      ..avatarColor = entity.avatarColor
      ..notes = entity.notes
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..syncStatus = entity.syncStatus
      ..version = entity.version;
    return model;
  }
}

class GroupExpenseMapper implements EntityMapper<GroupExpense, GroupExpenseModel> {
  @override
  GroupExpense toEntity(GroupExpenseModel model) {
    return GroupExpense(
      localId: model.id,
      cloudId: model.cloudId,
      groupId: model.groupId,
      title: model.title,
      amount: model.amount,
      paidByMemberId: model.paidByMemberId,
      splitType: _parseSplitType(model.splitType),
      notes: model.notes,
      expenseDate: model.expenseDate,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      syncStatus: model.syncStatus,
      version: model.version,
    );
  }

  @override
  GroupExpenseModel toModel(GroupExpense entity) {
    final model = GroupExpenseModel()
      ..id = entity.localId ?? Isar.autoIncrement
      ..cloudId = entity.cloudId
      ..groupId = entity.groupId
      ..title = entity.title
      ..amount = entity.amount
      ..paidByMemberId = entity.paidByMemberId
      ..splitType = entity.splitType.name
      ..notes = entity.notes
      ..expenseDate = entity.expenseDate
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt
      ..deletedAt = entity.deletedAt
      ..syncStatus = entity.syncStatus
      ..version = entity.version;
    return model;
  }

  SplitType _parseSplitType(String value) {
    for (final t in SplitType.values) {
      if (t.name == value) return t;
    }
    return SplitType.equal;
  }
}

class ExpenseShareMapper implements EntityMapper<ExpenseShare, ExpenseShareModel> {
  @override
  ExpenseShare toEntity(ExpenseShareModel model) {
    return ExpenseShare(
      localId: model.id,
      expenseId: model.expenseId,
      memberId: model.memberId,
      amount: model.amount,
      percentage: model.percentage,
      settledAmount: model.settledAmount,
      syncStatus: model.syncStatus,
    );
  }

  @override
  ExpenseShareModel toModel(ExpenseShare entity) {
    final model = ExpenseShareModel()
      ..id = entity.localId ?? Isar.autoIncrement
      ..expenseId = entity.expenseId
      ..memberId = entity.memberId
      ..amount = entity.amount
      ..percentage = entity.percentage
      ..settledAmount = entity.settledAmount
      ..syncStatus = entity.syncStatus;
    return model;
  }
}

class SettlementMapper implements EntityMapper<Settlement, SettlementModel> {
  @override
  Settlement toEntity(SettlementModel model) {
    return Settlement(
      localId: model.id,
      groupId: model.groupId,
      payerId: model.payerId,
      receiverId: model.receiverId,
      amount: model.amount,
      settlementDate: model.settlementDate,
      notes: model.notes,
      createdAt: model.createdAt,
    );
  }

  @override
  SettlementModel toModel(Settlement entity) {
    final model = SettlementModel()
      ..id = entity.localId ?? Isar.autoIncrement
      ..groupId = entity.groupId
      ..payerId = entity.payerId
      ..receiverId = entity.receiverId
      ..amount = entity.amount
      ..settlementDate = entity.settlementDate
      ..notes = entity.notes
      ..createdAt = entity.createdAt;
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
