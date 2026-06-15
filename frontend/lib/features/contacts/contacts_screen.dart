import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/personal_contact.dart';
import '../../state/contacts_state.dart';
import '../../utils/launcher.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/neumorphic_container.dart';
import '../../widgets/neumorphic_button.dart';
import '../../widgets/app_button.dart';
import '../../utils/translations.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactsState = context.watch<ContactsState>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Contacts'.tr(context)),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 8),
        child: SizedBox(
          width: 58,
          height: 58,
          child: NeumorphicButton(
            borderRadius: 29,
            color: theme.colorScheme.primary,
            onTap: () => _openContactForm(context),
            child: const Center(
              child: Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ),
      ),
      body: contactsState.contacts.isEmpty
          ? EmptyState(
              title: 'No emergency contacts'.tr(context),
              message: 'Add family or friends for quick access.'.tr(context),
              icon: Icons.people_outline,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: contactsState.contacts.length,
              itemBuilder: (context, index) {
                final contact = contactsState.contacts[index];
                return Dismissible(
                  key: ValueKey(contact.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => contactsState.removeContact(contact.id),
                  child: NeumorphicContainer(
                    borderRadius: 20,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                            child: Icon(Icons.person, color: theme.colorScheme.primary),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contact.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${contact.relationship.tr(context)} • ${contact.phone}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          NeumorphicButton(
                            borderRadius: 12,
                            onTap: () => _openContactForm(context, contact: contact),
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.edit_outlined, size: 20),
                            ),
                          ),
                          const SizedBox(width: 8),
                          NeumorphicButton(
                            borderRadius: 12,
                            onTap: () => launchPhone(context, contact.phone),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.call,
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
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
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, bottomPadding + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              (widget.contact == null ? 'Add Contact' : 'Edit Contact').tr(context),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          NeumorphicContainer(
            borderRadius: 16,
            isPressed: true,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name'.tr(context),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Colors.transparent,
                filled: false,
              ),
            ),
          ),
          const SizedBox(height: 16),
          NeumorphicContainer(
            borderRadius: 16,
            isPressed: true,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextField(
              controller: _relationshipController,
              decoration: InputDecoration(
                labelText: 'Relationship (e.g. Family, Doctor)'.tr(context),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Colors.transparent,
                filled: false,
              ),
            ),
          ),
          const SizedBox(height: 16),
          NeumorphicContainer(
            borderRadius: 16,
            isPressed: true,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number'.tr(context),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: Colors.transparent,
                filled: false,
              ),
            ),
          ),
          const SizedBox(height: 24),
          AppButton.primary(
            label: (widget.contact == null ? 'SAVE CONTACT' : 'UPDATE CONTACT').tr(context),
            isFullWidth: true,
            onPressed: () async {
              final name = _nameController.text.trim();
              final relationship = _relationshipController.text.trim();
              final phone = _phoneController.text.trim();
              if (name.isEmpty || phone.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Name and phone are required.'.tr(context))),
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
          ),
        ],
      ),
    );
  }
}
