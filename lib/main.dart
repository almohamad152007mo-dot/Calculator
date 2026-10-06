import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الحاسبة',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B6BF5),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0E1A),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}
س تز
class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _firstNumber = '';
  String _operation = '';
  bool _shouldResetDisplay = false;

  void _onNumberPressed(String number) {
    setState(() {
      if (_shouldResetDisplay) {
        _display = number;
        _shouldResetDisplay = false;
      } else {
        if (_display == '0') {
          _display = number;
        } else {
          _display += number;
        }
      }
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (_shouldResetDisplay) {
        _display = '0.';
        _shouldResetDisplay = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _onOperationPressed(String operation) {
    setState(() {
      if (_operation.isNotEmpty && !_shouldResetDisplay) {
        _calculate();
      }
      _firstNumber = _display;
      _operation = operation;
      _shouldResetDisplay = true;
    });
  }

  void _calculate() {
    if (_firstNumber.isEmpty || _operation.isEmpty) return;

    final first = double.tryParse(_firstNumber) ?? 0;
    final second = double.tryParse(_display) ?? 0;
    double result = 0;

    switch (_operation) {
      case '+':
        result = first + second;
        break;
      case '−':
        result = first - second;
        break;
      case '×':
        result = first * second;
        break;
      case '÷':
        if (second == 0) {
          setState(() {
            _display = 'خطأ';
            _firstNumber = '';
            _operation = '';
            _shouldResetDisplay = true;
          });
          return;
        }
        result = first / second;
        break;
    }

    final resultStr = result == result.toInt()
        ? result.toInt().toString()
        : result.toString();

    setState(() {
      _display = resultStr;
      _firstNumber = '';
      _operation = '';
      _shouldResetDisplay = true;
    });
  }

  void _onEqualsPressed() {
    _calculate();
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _firstNumber = '';
      _operation = '';
      _shouldResetDisplay = false;
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  void _onPercentPressed() {
    setState(() {
      final value = double.tryParse(_display) ?? 0;
      final result = value / 100;
      _display = result == result.toInt()
          ? result.toInt().toString()
          : result.toString();
    });
  }

  void _onSignPressed() {
    setState(() {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else if (_display != '0') {
        _display = '-$_display';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Text(
                    _display,
                    style: TextStyle(
                      fontSize: _display.length > 10 ? 48 : 72,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _buildRow(['C', '±', '%', '÷']),
                    _buildRow(['7', '8', '9', '×']),
                    _buildRow(['4', '5', '6', '−']),
                    _buildRow(['1', '2', '3', '+']),
                    _buildRow(['0', '.', '⌫', '=']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons
            .map((label) => Expanded(child: _buildButton(label)))
            .toList(),
      ),
    );
  }

  Widget _buildButton(String label) {
    final isOperator = ['÷', '×', '−', '+', '='].contains(label);
    final isAction = ['C', '±', '%', '⌫'].contains(label);
    final isEquals = label == '=';

    Color bgColor;
    Color textColor;

    if (isEquals) {
      bgColor = const Color(0xFF5B6BF5);
      textColor = Colors.white;
    } else if (isOperator) {
      bgColor = const Color(0xFF1E2A4A);
      textColor = const Color(0xFF5B6BF5);
    } else if (isAction) {
      bgColor = const Color(0xFF1A1E2E);
      textColor = const Color(0xFFFF8A65);
    } else {
      bgColor = const Color(0xFF1A1E2E);
      textColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _handleTap(label),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(String label) {
    if (label == 'C') {
      _onClearPressed();
    } else if (label == '⌫') {
      _onDeletePressed();
    } else if (label == '=') {
      _onEqualsPressed();
    } else if (label == '±') {
      _onSignPressed();
    } else if (label == '%') {
      _onPercentPressed();
    } else if (label == '.') {
      _onDecimalPressed();
    } else if (['+', '−', '×', '÷'].contains(label)) {
      _onOperationPressed(label);
    } else {
      _onNumberPressed(label);
    }
  }
}