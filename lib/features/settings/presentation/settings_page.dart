import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/settings_repository.dart';
import 'settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) {
          final cubit = context.read<SettingsCubit>();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                initialValue: settings.storeName,
                decoration: const InputDecoration(labelText: 'Nome do estabelecimento'),
                onChanged: cubit.setStoreName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: settings.defaultDiscount.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Desconto padrão (%)'),
                onChanged: (v) => cubit.setDefaultDiscount(int.tryParse(v) ?? 0),
              ),
              const SizedBox(height: 24),
              const Text('Tema', style: TextStyle(fontWeight: FontWeight.bold)),
              RadioGroup<ThemeMode>(
                groupValue: settings.themeMode,
                onChanged: (m) {
                  if (m != null) cubit.setThemeMode(m);
                },
                child: const Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: Text('Sistema'),
                      value: ThemeMode.system,
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text('Claro'),
                      value: ThemeMode.light,
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text('Escuro'),
                      value: ThemeMode.dark,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
