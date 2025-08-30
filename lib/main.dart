import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MeasuresConverterApp());

/// Root widget of the application
class MeasuresConverterApp extends StatelessWidget {
  const MeasuresConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const ConversionPage(),
    );
  }
}

/// Stateful widget for the conversion page.
class ConversionPage extends StatefulWidget {
  const ConversionPage({super.key});

  @override
  State<ConversionPage> createState() => _ConversionPageState();
}

/// State class for Conversion Page.
class _ConversionPageState extends State<ConversionPage> {
   // Controller for the input value TextField.
  final TextEditingController value = TextEditingController();

  String fromUnit = '';
  String toUnit = '';
  double? result;

  late List<String> units;

  @override
  void initState() {
    super.initState();

    // Initialize units (length, weight, temperature).
    units = [
      'meters', 'centimeters', 'kilometers', 'inches', 'feet', 'miles',
      'grams', 'kilograms', 'pounds', 'ounces',
      'celsius', 'fahrenheit', 'kelvin',
    ];
    // Set default units.
    fromUnit = units.first;
    toUnit = units[1];
  }

  /// Function to perform conversion when button is pressed.
  void convert() {
    final input = double.tryParse(value.text);
    if (input == null) return;
    
    // Update the result.
    setState(() {
      result = UnitConverter.convert(input, fromUnit, toUnit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Measures Converter',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            // Label for input.
            const Text(
              'Value',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 137, 135, 135),
              ),
            ),
            const SizedBox(height: 8),
            // Input TextField where the user can enter a value.
            TextField(
              controller: value,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Color.fromARGB(255, 19, 97, 160),
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                hintText: 'Enter a number',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // "From" label.
            const Text(
              'From',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 137, 135, 135),
              ),
            ),
            // Dropdown for selecting "from" unit.
            DropdownButton<String>(
              value: fromUnit,
              isExpanded: true,
              onChanged: (newValue) => setState(() => fromUnit = newValue!),
              style: const TextStyle(
                color: Color.fromARGB(255, 19, 97, 160),
                fontSize: 16,
              ),
              items: units
                  .map((unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            // To label.
            const Text(
              'To',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 137, 135, 135),
              ),
            ),
            // Dropdown for selecting "to" unit.
            DropdownButton<String>(
              value: toUnit,
              isExpanded: true,
              onChanged: (newValue) => setState(() => toUnit = newValue!),
              style: const TextStyle(
                color: Color.fromARGB(255, 19, 97, 160),
                fontSize: 16,
              ),
              items: units
                  .map((unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            // Convert button.
            ElevatedButton(
              onPressed: convert,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 211, 215, 219),
                foregroundColor: const Color.fromARGB(255, 26, 118, 193),
                elevation: 3,
                shadowColor: Colors.black.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
              ),
              child: Text(
                'Convert',
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Display conversion result.
            if (result != null)
              Text(
                '${value.text} $fromUnit are ${result!.toStringAsFixed(3)} $toUnit',
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 142, 146, 154),
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

/// Class that handles unit conversion logic
class UnitConverter {
  static double convert(double value, String fromUnit, String toUnit) {
    if (_isTemperature(fromUnit, toUnit)) {
      return _convertTemperature(value, fromUnit, toUnit);
    }
    double valueInBase = value * _toBaseFactor(fromUnit);
    return valueInBase / _toBaseFactor(toUnit);
  }

  static bool _isTemperature(String from, String to) {
    return ['celsius', 'fahrenheit', 'kelvin'].contains(from) &&
        ['celsius', 'fahrenheit', 'kelvin'].contains(to);
  }

  /// Convert temperature between Celsius, Fahrenheit, and Kelvin.
  static double _convertTemperature(double value, String from, String to) {
    double celsius;
    switch (from) {
      case 'celsius':
        celsius = value;
        break;
      case 'fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'kelvin':
        celsius = value - 273.15;
        break;
      default:
        throw Exception('Unknown temp unit: $from');
    }

    switch (to) {
      case 'celsius':
        return celsius;
      case 'fahrenheit':
        return (celsius * 9 / 5) + 32;
      case 'kelvin':
        return celsius + 273.15;
      default:
        throw Exception('Unknown temp unit: $to');
    }
  }
  
 /// Returns factor to convert unit to base unit (meters for length, grams for weight).
  static double _toBaseFactor(String unit) {
    switch (unit) {
      // Length
      case 'meters':
        return 1.0;
      case 'centimeters':
        return 0.01;
      case 'kilometers':
        return 1000.0;
      case 'inches':
        return 0.0254;
      case 'feet':
        return 0.3048;
      case 'miles':
        return 1609.34;

      // Weight
      case 'grams':
        return 1.0;
      case 'kilograms':
        return 1000.0;
      case 'pounds':
        return 453.592;
      case 'ounces':
        return 28.3495;

      default:
        throw Exception('Unknown unit: $unit');
    }
  }
}
