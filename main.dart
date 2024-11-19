import 'package:flutter/material.dart';

void main() => runApp(CurrencyConverterApp());

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyConverter(),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedCurrency = 'USD';
  String _result = '';

  final _rates = {'USD': 0.0036, 'GBP': 0.0028, 'EUR': 0.0033, 'SAR': 0.0135, 'TRY': 0.10};
  final _symbols = {'USD': '\$', 'GBP': '£', 'EUR': '€', 'SAR': '﷼', 'TRY': '₺'};
  final _icons = {
    'USD': Icons.attach_money,
    'GBP': Icons.currency_pound,
    'EUR': Icons.euro_symbol, // Updated to euro_symbol for compatibility
    'SAR': Icons.money,
    'TRY': Icons.currency_lira,
  };

  void _convert() {
    final pkr = double.tryParse(_amountController.text);
    if (pkr == null || pkr <= 0) {
      _showAlert('Invalid Input', 'Please enter a valid numeric amount in PKR.');
      return;
    }
    setState(() {
      _result = 'Converted: ${_symbols[_selectedCurrency]}${(pkr * _rates[_selectedCurrency]!).toStringAsFixed(2)}';
    });
  }

  void _clear() {
    setState(() {
      _amountController.clear();
      _result = '';
    });
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text('Currency Converter'), backgroundColor: Colors.grey[800]),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: screenWidth / 3, // Restrict the width of TextField to 1/3 of screen
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Enter PKR',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              SizedBox(height: 15),
              DropdownButton<String>(
                value: _selectedCurrency,
                isExpanded: true,
                items: _rates.keys.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Row(
                      children: [
                        Icon(_icons[currency], color: Colors.grey[800]),
                        SizedBox(width: 10),
                        Text(currency),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCurrency = value!),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _convert,
                    child: Text('Convert', style: TextStyle(color: Colors.white)), // White text color
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _clear,
                    child: Text('Clear', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[800],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                _result,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
