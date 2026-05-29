import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../data/mock_repository.dart';
import '../../models/first_aid_tip.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';

class FirstAidScreen extends StatefulWidget {
  const FirstAidScreen({super.key});

  @override
  State<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> {
  @override
  Widget build(BuildContext context) {
    final repository = context.read<MockRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('First-aid tips'),
      ),
      body: FutureBuilder<List<FirstAidTip>>(
        future: repository.getTips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorState(
              title: 'Unable to load tips',
              message: 'Please try again later.',
              onRetry: () => setState(() {}),
            );
          }
          final tips = snapshot.data ?? [];
          if (tips.isEmpty) {
            return const EmptyState(
              title: 'No tips available',
              message: 'Please check back later for first-aid guidance.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tips.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final tip = tips[index];
              return Card(
                child: ExpansionTile(
                  leading: SvgPicture.asset(
                    tip.imageAsset,
                    width: 36,
                    height: 36,
                  ),
                  title: Text(tip.title),
                  subtitle: Text(tip.summary),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < tip.steps.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text('${i + 1}. ${tip.steps[i]}'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
