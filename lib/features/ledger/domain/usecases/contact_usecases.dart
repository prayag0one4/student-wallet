import '../../../../core/errors/result.dart';
import '../entities/contact.dart';
import '../repositories/contact_repository.dart';

class CreateContact {
  final ContactRepository _repository;
  CreateContact(this._repository);
  Future<Result<Contact>> call(Contact contact) => _repository.createContact(contact);
}

class UpdateContact {
  final ContactRepository _repository;
  UpdateContact(this._repository);
  Future<Result<Contact>> call(Contact contact) => _repository.updateContact(contact);
}

class DeleteContact {
  final ContactRepository _repository;
  DeleteContact(this._repository);
  Future<Result<void>> call(int id) => _repository.deleteContact(id);
}

class GetContactById {
  final ContactRepository _repository;
  GetContactById(this._repository);
  Future<Result<Contact?>> call(int id) => _repository.getContactById(id);
}

class GetAllContacts {
  final ContactRepository _repository;
  GetAllContacts(this._repository);
  Future<Result<List<Contact>>> call({int? offset, int? limit}) =>
      _repository.getAllContacts(offset: offset, limit: limit);
}

class SearchContacts {
  final ContactRepository _repository;
  SearchContacts(this._repository);
  Future<Result<List<Contact>>> call(String query) => _repository.searchContacts(query);
}
