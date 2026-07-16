import '../../domain/entities/contact.dart';

abstract class ContactLocalDataSource {
  Future<List<Contact>> getAll({int? offset, int? limit});
  Future<Contact?> getById(int id);
  Future<int> create(Contact contact);
  Future<void> update(Contact contact);
  Future<void> delete(int id);
  Future<List<Contact>> search(String query);
}
