import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      levelColors: {
        Level.trace: AnsiColor.fg(AnsiColor.grey(0.5)),
        Level.debug: const AnsiColor.fg(35),
        Level.info: const AnsiColor.fg(32),
        Level.warning: const AnsiColor.fg(220),
        Level.error: const AnsiColor.fg(196),
        Level.fatal: const AnsiColor.fg(199),
      },
      levelEmojis: {
        Level.trace: '',
        Level.debug: '🟢',
        Level.info: '🔵',
        Level.warning: '🟡',
        Level.error: '🔴',
        Level.fatal: '🟣',
      }),
);
