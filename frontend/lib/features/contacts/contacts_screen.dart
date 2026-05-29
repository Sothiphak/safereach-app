import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/personal_contact.dart';
import '../../state/contacts_state.dart';
import '../../utils/launcher.dart';
import '../../widgets/empty_state.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactsState = context.watch<ContactsState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal contacts'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openContactForm(context),
        child: const Icon(Icons.add),
      ),
      body: contactsState.contacts.isEmpty
          ? const EmptyState(
              title: 'No emergency contacts',
              message: 'Add family or friends for quick access.',
              icon: Icons.people_outline,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: contactsState.contacts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final contact = contactsState.contacts[index];
                return Dismissible(
                  key: ValueKey(contact.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => contactsState.removeContact(contact.id),
                  child: Card(
                    child: ListTile(
                      title: Text(contact.name),
                      subtitle: Text('${contact.relationship} • ${contact.phone}'),
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Edit',
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _openContactForm(context, contact: contact),
                          ),
                          IconButton(
                            tooltip: 'Call',
                            icon: const Icon(Icons.call),
                            onPressed: () => launchPhone(context, contact.phone),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _openContactForm(BuildContext context, {PersonalContact? contact}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _ContactForm(contact: contact),
    );
  }
}

class _ContactForm extends StatefulWidget {
  const _ContactForm({this.contact});

  final PersonalContact? contact;

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _relationshipController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _relationshipController =
        TextEditingController(text: widget.contact?.relationship ?? '');
    _phoneController = TextEditingController(text: widget.contact?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactsState = context.read<ContactsState>();
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.contact == null ? 'Add contact' : 'Edit contact',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _relationshipController,
            decoration: const InputDecoration(labelText: 'Relationship'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone number'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                final relationship = _relationshipController.text.trim();
                final phone = _phoneController.text.trim();
                if (name.isEmpty || phone.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name and phone are required.')),
                  );
                  return;
                }
                if (widget.contact == null) {
                  await contactsState.addContact(
                    PersonalContact(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      relationship: relationship.isEmpty ? 'Contact' : relationship,
                      phone: phone,
                    ),
                  );
                } else {
                  await contactsState.updateContact(
                    widget.contact!.copyWith(
                      name: name,
                      relationship: relationship.isEmpty ? 'Contact' : relationship,
                      phone: phone,
                    ),
                  );
                }
                if (!context.mounted) {
                  return;
                }
                Navigator.pop(context);
              },
              child: Text(widget.contact == null ? 'Save contact' : 'Update contact'),
            ),
          ),
        ],
      ),
    );
  }
}
