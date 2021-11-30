class Common {
  static final Common _instance = Common._internal();

  factory Common() => _instance;

  int co2 = 0;
  int humidity = 0;
  int temperature = 0;
  bool isFahrenheit = true;

  //initialize variables in here
  Common._internal() {
    co2 = 0;
    humidity = 0;
    temperature = 0;
    isFahrenheit = true;
  }
}
