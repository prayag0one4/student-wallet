import 'package:flutter/material.dart';

class IconMapper {
  static IconData fromString(String hexCodePoint) {
    try {
      final codePoint = int.parse(hexCodePoint, radix: 16);
      switch (codePoint) {
        case 0xe57a: return Icons.restaurant;
        case 0xe530: return Icons.directions_bus;
        case 0xe54c: return Icons.shopping_bag;
        case 0xe8a0: return Icons.hotel;
        case 0xe8b1: return Icons.home;
        case 0xe80c: return Icons.school;
        case 0xe638: return Icons.movie;
        case 0xe63a: return Icons.card_membership;
        case 0xe004: return Icons.local_hospital;
        case 0xe23f: return Icons.flash_on;
        case 0xe52e: return Icons.more_horiz;
        default: return Icons.category;
      }
    } catch (_) {
      return Icons.category;
    }
  }
}
