const bool isProduction = bool.fromEnvironment('dart.vm.product');

class DebugPrinter {
  static void printDebug(content) {
    if(!isProduction)
    print(content);
  }
}
