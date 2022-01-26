import 'package:logger/logger.dart';

PrefixPrinter prefixPrinter = PrefixPrinter(
  PrettyPrinter(
    methodCount: 2, // number of method calls to be displayed
    errorMethodCount: 8, // number of method calls if stacktrace is provided
    lineLength: 120, // width of the output
    printTime: true, // Should each log print contain a timestamp
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
  printer: prefixPrinter,
);

void initLogger(Level level) {
  logger = Logger(
    level: level,
    printer: prefixPrinter,
  );
}
