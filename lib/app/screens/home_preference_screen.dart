import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/home_module.dart';
import '../providers/user_preferences_service.dart';

class HomePreferenceScreen extends StatelessWidget {
  const HomePreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = GetIt.instance<UserPreferencesService>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen Preferences')),
      body: ListenableBuilder(
        listenable: prefs,
        builder: (context, _) {
          final current = prefs.homeModule;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Default Home Feature',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: HomeModuleConfig.all.map((config) {
                    final isSelected = config.module == current;
                    return RadioListTile<HomeModule>(
                      value: config.module,
                      groupValue: current,
                      title: Row(
                        children: [
                          Icon(config.icon, size: 22, color: config.color),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              config.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 34),
                        child: Text(
                          config.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          prefs.setHomeModule(value);
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
