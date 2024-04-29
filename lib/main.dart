import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_app/app/cubit/profile_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scan Barcode',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => ProfileCubit(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController coinsValueController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    userIdController.dispose();
    coinsValueController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    try {
      String barcodeResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (barcodeResult != '-1' && barcodeResult.isNotEmpty) {
        var decodedData = jsonDecode(barcodeResult);
        setState(() {
          userIdController.text = decodedData['id'].toString();
          coinsValueController.text = decodedData['coins'].toString();
        });
      }
    } catch (e) {
      print('Error decoding barcode: $e');
      setState(() {
        userIdController.text = 'Failed to get the user ID';
        coinsValueController.text = 'Failed to get the coins value';
      });
    }
  }

  void exchangeCoins() {
    context.read<ProfileCubit>().getExchangeCoins(amount: amountController.text);
  }

  void clearInputs() {
    userIdController.clear();
    coinsValueController.clear();
    amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Barcode'),
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is SuccessExchangeCoinsState) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Success"),
                content: Text("Coins exchanged successfully."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      clearInputs();
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: userIdController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'User ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: coinsValueController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Coins Value',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _scanBarcode,
                  child: Text('Scan QR Code'),
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.blue,
                    // onPrimary: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount to Exchange',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: exchangeCoins,
                  child: Text('Exchange Coins'),
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.green,
                    // onPrimary: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
