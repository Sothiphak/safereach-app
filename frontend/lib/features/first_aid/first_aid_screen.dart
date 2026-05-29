import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../data/mock_repository.dart';
import '../../models/first_aid_tip.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/neumorphic_container.dart';
import '../../utils/translations.dart';

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
        title: Text('First-aid tips'.tr(context)),
      ),
      body: FutureBuilder<List<FirstAidTip>>(
        future: repository.getTips(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorState(
              title: 'Unable to load tips'.tr(context),
              message: 'Please try again later.'.tr(context),
              onRetry: () => setState(() {}),
            );
          }
          final tips = snapshot.data ?? [];
          if (tips.isEmpty) {
            return EmptyState(
              title: 'No tips available'.tr(context),
              message: 'Please check back later for first-aid guidance.'.tr(context),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tips.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final tip = tips[index];
              return NeumorphicContainer(
                borderRadius: 20,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    leading: SvgPicture.asset(
                      tip.imageAsset,
                      width: 36,
                      height: 36,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.medical_services,
                        color: Theme.of(context).colorScheme.primary,
                        size: 32,
                      ),
                    ),
                    title: Text(
                      tip.title.tr(context),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      tip.summary.tr(context),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(height: 20),
                            for (var i = 0; i < tip.steps.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.1),
                                      child: Text(
                                        '${i + 1}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        tip.steps[i].tr(context),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
