import '../../../../core/errors/result.dart';
import '../entities/contact.dart';

abstract class ContactRepository {
  Future<Result<List<Contact>>> getAllContacts({int? offset, int? limit});
  Future<Result<Contact>> createContact(Contact contact);
  Future<Result<Contact>> updateContact(Contact contact);
  Future<Result<void>> deleteContact(int id);
  Future<Result<Contact?>> getContactById(int id);
  Future<Result<List<Contact>>> searchContacts(String query);
}
