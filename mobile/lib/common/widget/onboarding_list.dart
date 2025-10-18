import 'package:flutter/material.dart';

import '../common.dart';

class OnboardingList<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final void Function(T) onItemSelected;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final String Function(T) displayName;

  const OnboardingList({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onItemSelected,
    this.controller,
    this.physics,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: controller,
        itemCount: items.length,
        physics: physics,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
        itemBuilder: (context, index) {
          final isSelected = items[index] == selectedItem;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OutlinedAppButton(
              title: displayName(items[index]),
              isSelected: isSelected,
              onTap: () => onItemSelected(items[index]),
            ),
          );
        },
      ),
    );
  }
}

class MultiSelectOnboardingList<T> extends StatelessWidget {
  final List<T> items;
  final List<T> selectedItems;
  final void Function(T) onItemChosen;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final String Function(T) displayName;

  const MultiSelectOnboardingList({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onItemChosen,
    this.controller,
    this.physics,
    required this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: controller,
        itemCount: items.length,
        physics: physics,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
        itemBuilder: (context, index) {
          final isSelected = selectedItems.contains(items[index]);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OutlinedAppButton(
              title: displayName(items[index]),
              isSelected: isSelected,
              onTap: () => onItemChosen(items[index]),
            ),
          );
        },
      ),
    );
  }
}
