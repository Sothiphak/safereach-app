import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/settings_state.dart';
import '../../widgets/neumorphic_container.dart';
import '../../utils/translations.dart';

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

  Future<void> _saveMedicalInfo() async {
    final settings = context.read<SettingsState>();
    final savedBloodGroup = await settings.setBloodGroup(
      _bloodGroupController.text,
    );

    if (!mounted) {
      return;
    }

    if (!savedBloodGroup) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Use a valid blood group like A+, O-, or AB+'.tr(context))),
      );
      return;
    }

    await settings.setAllergies(_allergiesController.text);

    if (!mounted) {
      return;
    }

    _bloodGroupController.text = settings.bloodGroup;
    _allergiesController.text = settings.allergies;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Medical info saved'.tr(context))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.tr(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NeumorphicContainer(
            borderRadius: 20,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text('Dark mode'.tr(context)),
                    value: settings.darkMode,
                    onChanged: settings.setDarkMode,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    title: Text('Language'.tr(context)),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: settings.language,
                        items: [
                          DropdownMenuItem(
                            value: SettingsState.englishLanguage,
                            child: Text('English'.tr(context)),
                          ),
                          DropdownMenuItem(
                            value: SettingsState.khmerLanguage,
                            child: Text('Khmer'.tr(context)),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            settings.setLanguage(value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          NeumorphicContainer(
            borderRadius: 20,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Medical info'.tr(context), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                NeumorphicContainer(
                  borderRadius: 16,
                  isPressed: true,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextField(
                    controller: _bloodGroupController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Blood group'.tr(context),
                      hintText: 'e.g. A+, O-'.tr(context),
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
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TextField(
                    controller: _allergiesController,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Allergies'.tr(context),
                      hintText: 'List any allergies'.tr(context),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                      filled: false,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _saveMedicalInfo,
                    icon: const Icon(Icons.save_outlined),
                    label: Text('Save medical info'.tr(context)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          NeumorphicContainer(
            borderRadius: 20,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text('About SafeReach'.tr(context)),
                subtitle: Text(
                  'Emergency response, locations, and tips.'.tr(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
