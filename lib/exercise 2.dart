// 1. Logger abstract class (interface)
abstract class Logger {
  void log(String message);
}

// 2. Two implementations
class ConsoleLogger implements Logger {
  @override
  void log(String message) => print(message);
}

class FileLogger implements Logger {
  @override
  void log(String message) => print("File: $message");
}

// 3. Application delegates to Logger (manual delegation)
class Application implements Logger {
  final Logger _logger;
  Application(this._logger);

  @override
  void log(String message) => _logger.log(message);

  void run() {
    log("App started");
    log("Processing data...");
    log("App finished");
  }
}

void main() {
  print("=== Console Logger ===");
  Application(ConsoleLogger()).run();

  print("\n=== File Logger ===");
  Application(FileLogger()).run();
}
