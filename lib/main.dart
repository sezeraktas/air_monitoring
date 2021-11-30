import 'package:air_monitoring/common.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Air Monitoring';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? timer;
  Common c = Common();
  Random random = Random();

  @override
  void initState() {
    super.initState();
    // 300 - 1600
    c.co2 = random.nextInt(1301) + 300;
    // 30 - 60
    c.humidity = random.nextInt(31) + 30;
    // 50 - 100
    c.temperature = random.nextInt(51) + 50;

    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        c.co2 = random.nextInt(1301) + 300;
        c.humidity = random.nextInt(31) + 30;
        c.temperature = random.nextInt(51) + 50;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  bool isAirQualityFine() {
    return (c.co2 <= 1200 &&
            c.humidity <= 50 &&
            (c.temperature >= 65 || c.temperature <= 85))
        ? true
        : false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                        margin: const EdgeInsets.all(10.0),
                        color: isAirQualityFine() ? Colors.green : Colors.red,
                        child: Center(
                            child: Text(
                                isAirQualityFine()
                                    ? "Excellent Quality"
                                    : "Poor Quality",
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 25)))),
                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: ListTile(
                          leading: const Icon(Icons.air),
                          title: Text(c.co2.toString()),
                          subtitle: const Text(
                              "Carbondioxide in PPM (healthy: 300-1200)")),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: ListTile(
                          leading: const Icon(Icons.water),
                          title: Text(c.humidity.toString()),
                          subtitle:
                              const Text("Humidity in % (healthy: 30-50)")),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                      child: ListTile(
                          leading: const Icon(Icons.thermostat_outlined),
                          title: Text((c.isFahrenheit
                                  ? c.temperature.toString()
                                  : (((c.temperature - 32) * 5) / 9).round())
                              .toString()),
                          subtitle: Text("Temperature in " +
                              (c.isFahrenheit ? "Fahrenheit" : "Celsius"))),
                    ),
                  ),
                ]))
          ],
        ));
  }
}

/// This is the stateful widget that the main application instantiates.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SettingsScreenState extends State<SettingsScreen> {
  Common c = Common();

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: c.isFahrenheit ? const Text("Fahrenheit") : const Text("Celsius"),
      value: c.isFahrenheit,
      onChanged: (bool value) {
        setState(() {
          c.isFahrenheit = value;
        });
      },
      secondary: const Icon(Icons.thermostat_outlined),
    );
  }
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sezer's Air Monitoring App"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Living Room',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
