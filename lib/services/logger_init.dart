import 'package:logger/logger.dart';

PrefixPrinter _prefixPrinter = PrefixPrinter(
  PrettyPrinter(
    methodCount: 1, // number of method calls to be displayed
    errorMethodCount: 8, // number of method calls if stacktrace is provided
    lineLength: 80, // width of the output
    printTime: false, // Should each log print contain a timestamp
    excludeBox: {
      Level.debug: true,
    },
  ),
  debug: '[CCCC][D]',
  info: '[CCCC][I]',
  error: '[CCCC][E]',
  warning: '[CCCC][W]',
  verbose: '[CCCC][V]',
  wtf: '[CCCC][WTF]',
);

Logger logger = Logger(
  level: Level.nothing,
  printer: _prefixPrinter,
);

void initLogger(Level level) {
  logger = Logger(
    level: level,
    printer: _prefixPrinter,
  );
}
