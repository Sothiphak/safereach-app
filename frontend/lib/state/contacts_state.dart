import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/personal_contact.dart';

class ContactsState extends ChangeNotifier {
  static const _contactsKey = 'personal_contacts';

  final List<PersonalContact> _contacts = [];
  late SharedPreferences _prefs;

  List<PersonalContact> get contacts => List.unmodifiable(_contacts);

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final stored = _prefs.getString(_contactsKey);
    if (stored != null) {
      final decoded = jsonDecode(stored) as List<dynamic>;
      _contacts
        ..clear()
        ..addAll(
          decoded.map(
            (item) => PersonalContact.fromJson(item as Map<String, dynamic>),
          ),
        );
    } else {
      _contacts
        ..clear()
        ..addAll(_seedContacts());
      await _persist();
    }
    notifyListeners();
  }

  Future<void> addContact(PersonalContact contact) async {
    _contacts.add(contact);
    await _persist();
    notifyListeners();
  }

  Future<void> updateContact(PersonalContact contact) async {
    final index = _contacts.indexWhere((item) => item.id == contact.id);
    if (index != -1) {
      _contacts[index] = contact;
      await _persist();
      notifyListeners();
    }
  }

  Future<void> removeContact(String id) async {
    _contacts.removeWhere((item) => item.id == id);
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final encoded = jsonEncode(_contacts.map((c) => c.toJson()).toList());
    await _prefs.setString(_contactsKey, encoded);
  }

  List<PersonalContact> _seedContacts() {
    return const [
      PersonalContact(id: 'c1', name: 'Mom', relationship: 'Family', phone: '+85512345601'),
      PersonalContact(id: 'c2', name: 'Dad', relationship: 'Family', phone: '+85512345602'),
      PersonalContact(id: 'c3', name: 'Sokha', relationship: 'Neighbor', phone: '+85512345603'),
    ];
  }
}
