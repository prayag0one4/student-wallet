import 'package:flutter/material.dart';

class IconPickerSheet extends StatelessWidget {
  final String? selectedIcon;
  final Function(String) onSelected;

  const IconPickerSheet({
    super.key,
    this.selectedIcon,
    required this.onSelected,
  });

  static const _icons = [
    Icons.flight_takeoff,
    Icons.beach_access,
    Icons.home,
    Icons.school,
    Icons.sports_cricket,
    Icons.restaurant,
    Icons.local_pizza,
    Icons.movie,
    Icons.code,
    Icons.camera_alt,
    Icons.music_note,
    Icons.shopping_cart,
    Icons.directions_car,
    Icons.local_gas_station,
    Icons.hotel,
    Icons.apartment,
    Icons.celebration,
    Icons.card_giftcard,
    Icons.group,
    Icons.coffee,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Choose an Icon',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: _icons.length,
              itemBuilder: (context, index) {
                final icon = _icons[index];
                final iconHex = '0x${icon.codePoint.toRadixString(16)}';
                final isSelected = iconHex == selectedIcon;
                return GestureDetector(
                  onTap: () {
                    onSelected(iconHex);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary.withAlpha(30)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2)
                          : null,
                    ),
                    child: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[700]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
