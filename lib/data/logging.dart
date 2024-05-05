import 'package:logger/logger.dart';
import 'package:flutter/material.dart';

final log = Logger(
  printer: PrettyPrinter(
    noBoxingByDefault: true,
    methodCount: 0,
    levelColors: const {Level.info: AnsiColor.fg(32)},
  ),
);
