import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/settings_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _bloodGroupController;
  late TextEditingController _allergiesController;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    final settings = context.read<SettingsState>();
    _bloodGroupController = TextEditingController(text: settings.bloodGroup);
    _allergiesController = TextEditingController(text: settings.allergies);
    _initialized = true;
  }

  @override
  void dispose() {
    _bloodGroupController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark mode'),
                  value: settings.darkMode,
                  onChanged: settings.setDarkMode,
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Language'),
                  trailing: DropdownButton<String>(
                    value: settings.language,
                    items: const [
                      DropdownMenuItem(value: 'EN', child: Text('English')),
                      DropdownMenuItem(value: 'KH', child: Text('Khmer')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        settings.setLanguage(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Medical info', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _bloodGroupController,
                    onChanged: settings.setBloodGroup,
                    decoration: const InputDecoration(
                      labelText: 'Blood group',
                      hintText: 'e.g. A+, O-',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _allergiesController,
                    onChanged: settings.setAllergies,
                    decoration: const InputDecoration(
                      labelText: 'Allergies',
                      hintText: 'List any allergies',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About SafeReach'),
              subtitle: const Text('Emergency response, locations, and tips.'),
            ),
          ),
        ],
      ),
    );
  }
}
