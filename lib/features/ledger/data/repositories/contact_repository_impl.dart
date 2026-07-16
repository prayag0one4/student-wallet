import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/contact.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/contact_local_datasource.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactLocalDataSource _localDataSource;
  final _logger = const AppLogger('ContactRepo');

  ContactRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<Contact>>> getAllContacts({int? offset, int? limit}) async {
    try {
      final contacts = await _localDataSource.getAll(offset: offset, limit: limit);
      return Result.success(contacts);
    } catch (e) {
      _logger.error('Failed to get all contacts', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load contacts'));
    }
  }

  @override
  Future<Result<Contact>> createContact(Contact contact) async {
    try {
      final id = await _localDataSource.create(contact);
      return Result.success(contact.copyWith(localId: id));
    } catch (e) {
      _logger.error('Failed to create contact', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to create contact'));
    }
  }

  @override
  Future<Result<Contact>> updateContact(Contact contact) async {
    try {
      await _localDataSource.update(contact);
      return Result.success(contact.copyWith(updatedAt: DateTime.now()));
    } catch (e) {
      _logger.error('Failed to update contact', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to update contact'));
    }
  }

  @override
  Future<Result<void>> deleteContact(int id) async {
    try {
      await _localDataSource.delete(id);
      return Result.success(null);
    } catch (e) {
      _logger.error('Failed to delete contact: $id', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to delete contact'));
    }
  }

  @override
  Future<Result<Contact?>> getContactById(int id) async {
    try {
      final contact = await _localDataSource.getById(id);
      return Result.success(contact);
    } catch (e) {
      _logger.error('Failed to get contact by id: $id', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to load contact'));
    }
  }

  @override
  Future<Result<List<Contact>>> searchContacts(String query) async {
    try {
      final contacts = await _localDataSource.search(query);
      return Result.success(contacts);
    } catch (e) {
      _logger.error('Failed to search contacts', e);
      return Result.failure(const DatabaseFailure(message: 'Failed to search contacts'));
    }
  }
}
