import 'package:mediport/core/exception/request_exception.dart';
import 'package:mediport/domain/repository/visitors/visitors_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'visitors_providers.g.dart';

@riverpod
Future<void> visitors(VisitorsRef ref) async {
  try {
    await ref.read(visitorsRepositoryProvider).visitors();
  } catch (err, stack) {
    debugPrint(err.toString());
    debugPrint(stack.toString());

    throw RequestException(message: err.toString());
  }
}