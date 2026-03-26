import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/genealogy.dart';

final genealogyListProvider = FutureProvider<List<Genealogy>>((ref) async {
  final raw = await rootBundle.loadString('firestore_seed/genealogies.json');
  final decoded = jsonDecode(raw) as List<dynamic>;
  return decoded
      .map((item) => Genealogy.fromMap(Map<String, dynamic>.from(item as Map)))
      .toList();
});

final genealogyProvider = FutureProvider.family<Genealogy?, String>((ref, id) async {
  final genealogies = await ref.watch(genealogyListProvider.future);
  for (final genealogy in genealogies) {
    if (genealogy.id == id) {
      return genealogy;
    }
  }
  return null;
});
