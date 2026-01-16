import 'package:SwishLab/models/custom_enums.dart';
import 'package:SwishLab/widgets/single_choice_chip.dart';
import 'package:flutter/material.dart';

class ChoiceChipsGroup<T> extends StatelessWidget {
  final List<String> labels;
  final List<IconData?>? icons;
  final int? selectedIndex;
  final void Function(int? index) onChanged;
  final ChipsDirection direction;

  const ChoiceChipsGroup({
    super.key,
    required this.labels,
    this.icons,
    required this.selectedIndex,
    required this.onChanged,
    this.direction = ChipsDirection.wrap,
  }) : assert(
          icons == null || icons.length == labels.length,
          'icons length must match labels length',
        );

  List<Widget> _withSpacing(List<Widget> children, Axis axis) {
    return children
        .expand((w) => [
              w,
              SizedBox(width: axis == Axis.horizontal ? 8 : 0, height: axis == Axis.vertical ? 8 : 0),
            ])
        .toList()
      ..removeLast();
  }

  @override
  Widget build(BuildContext context) {
    final children = List.generate(labels.length, (index) {
      final isSelected = index == selectedIndex;

      return SingleChoiceChip(
        label: labels[index],
        icon: icons?[index],
        selected: isSelected,
        onTap: () => onChanged(isSelected ? null : index),
      );
    });

    switch (direction) {
      case ChipsDirection.horizontal:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: _withSpacing(children, Axis.horizontal),
        );

      case ChipsDirection.vertical:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: _withSpacing(children, Axis.vertical),
        );

      case ChipsDirection.wrap:
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: children,
        );
    }
  }
}
