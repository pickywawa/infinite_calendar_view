import 'package:flutter/material.dart';

class DefaultHeader extends StatelessWidget {
  const DefaultHeader({
    super.key,
    required this.dayText,
  });

  static const defaultHorizontalPadding = 20.0;
  static const defaultVerticalPadding = 6.0;
  static const defaultDividerHeight = 0.0;

  final String dayText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Column(
        children: [
          const Divider(height: defaultDividerHeight),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultHorizontalPadding,
                vertical: defaultVerticalPadding),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                dayText,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
          ),
          const Divider(height: defaultDividerHeight),
        ],
      ),
    );
  }
}