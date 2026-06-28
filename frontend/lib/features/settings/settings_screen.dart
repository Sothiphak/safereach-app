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
  late TextEditingController _allergiesController;
  String _selectedBloodGroup = '';
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    final settings = context.read<SettingsState>();
    _selectedBloodGroup = settings.bloodGroup;
    _allergiesController = TextEditingController(text: settings.allergies);
    _initialized = true;
  }

  @override
  void dispose() {
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _saveMedicalInfo() async {
    final settings = context.read<SettingsState>();
    final savedBloodGroup = await settings.setBloodGroup(_selectedBloodGroup);

    if (!mounted) {
      return;
    }

    if (!savedBloodGroup) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Use a valid blood group like A+, O-, or AB+'.tr(context),
          ),
        ),
      );
      return;
    }

    await settings.setAllergies(_allergiesController.text);

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedBloodGroup = settings.bloodGroup;
    });
    _allergiesController.text = settings.allergies;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Medical info saved'.tr(context))));
  }

  Future<void> _clearMedicalInfo() async {
    final settings = context.read<SettingsState>();
    await settings.clearMedicalInfo();

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedBloodGroup = '';
    });
    _allergiesController.clear();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Medical info cleared'.tr(context))));
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return Scaffold(
      appBar: AppBar(title: Text('Settings'.tr(context))),
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
          _CurrentSetupCard(settings: settings),
          const SizedBox(height: 24),
          NeumorphicContainer(
            borderRadius: 20,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical info'.tr(context),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                NeumorphicContainer(
                  borderRadius: 16,
                  isPressed: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedBloodGroup,
                    decoration: InputDecoration(
                      labelText: 'Blood group'.tr(context),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: '',
                        child: Text('Not set'.tr(context)),
                      ),
                      ...SettingsState.validBloodGroups.map(
                        (bloodGroup) => DropdownMenuItem(
                          value: bloodGroup,
                          child: Text(bloodGroup),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedBloodGroup = value);
                      }
                    },
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isExpanded: true,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
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
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _clearMedicalInfo,
                    icon: const Icon(Icons.delete_outline),
                    label: Text('Clear medical info'.tr(context)),
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

class _CurrentSetupCard extends StatelessWidget {
  const _CurrentSetupCard({required this.settings});

  final SettingsState settings;

  @override
  Widget build(BuildContext context) {
    final language = settings.language == SettingsState.khmerLanguage
        ? 'Khmer'.tr(context)
        : 'English'.tr(context);
    final bloodGroup = settings.bloodGroup.isEmpty
        ? 'Not set'.tr(context)
        : settings.bloodGroup;
    final allergies = settings.allergies.isEmpty
        ? 'Not set'.tr(context)
        : settings.allergies;

    return NeumorphicContainer(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current setup'.tr(context),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _SetupRow(
            icon: Icons.dark_mode_outlined,
            label: 'Dark mode'.tr(context),
            value: settings.darkMode ? 'On'.tr(context) : 'Off'.tr(context),
          ),
          _SetupRow(
            icon: Icons.language,
            label: 'Language'.tr(context),
            value: language,
          ),
          _SetupRow(
            icon: Icons.bloodtype_outlined,
            label: 'Blood group'.tr(context),
            value: bloodGroup,
          ),
          _SetupRow(
            icon: Icons.warning_amber_outlined,
            label: 'Allergies'.tr(context),
            value: allergies,
          ),
        ],
      ),
    );
  }
}

class _SetupRow extends StatelessWidget {
  const _SetupRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
