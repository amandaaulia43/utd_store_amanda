import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../../data/crypto_service.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  bool _isCalculating = false;
  int? _calculationResult;
  
  // MethodChannel untuk Native Android (Poin 5)
  static const platform = MethodChannel('com.utdstore.amanda/native');
  String _batteryLevel = 'Belum dicek';

  // Variabel untuk Logika Warna Harga Crypto
  StreamSubscription? _priceSubscription;
  String _currentPrice = "Loading...";
  Color _priceColor = Colors.white;
  double _prevPriceVal = 0.0;

  @override
  void initState() {
    super.initState();
    _listenToPriceStream();
  }

  // Mendengarkan perubahan harga dan mengubah warna
  void _listenToPriceStream() {
    _priceSubscription = sl.get<CryptoService>().getBtcPriceStream().listen((priceString) {
      final double newPrice = double.tryParse(priceString) ?? 0.0;
      if (mounted) {
        setState(() {
          if (_prevPriceVal > 0) {
            if (newPrice > _prevPriceVal) {
              _priceColor = Colors.greenAccent; // Naik = Hijau
            } else if (newPrice < _prevPriceVal) {
              _priceColor = Colors.redAccent;   // Turun = Merah
            } else {
              _priceColor = Colors.white;
            }
          }
          _currentPrice = '\$$priceString';
          _prevPriceVal = newPrice;
        });
      }
    }, onError: (error) {
      if (mounted) setState(() => _currentPrice = "Error");
    });
  }

  @override
  void dispose() {
    _priceSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startHeavyTask() async {
    setState(() {
      _isCalculating = true;
      _calculationResult = null;
    });
    final result = await sl.get<CryptoService>().runHeavyComputation();
    setState(() {
      _calculationResult = result;
      _isCalculating = false;
    });
  }

  Future<void> _checkBatteryAndToast() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      setState(() {
        _batteryLevel = '$result%';
      });
      await platform.invokeMethod('showToast', {'message': 'Sisa Baterai Amanda: $result%'});
    } on PlatformException catch (e) {
      setState(() {
        _batteryLevel = "Gagal: '${e.message}'.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Crypto & Native Hub', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // BATERAI (POIN 5)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.battery_charging_full, color: Colors.white, size: 30),
                      const SizedBox(width: 10),
                      Text('Status Baterai Native', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(_batteryLevel, style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _checkBatteryAndToast,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.teal),
                    child: const Text('Cek Baterai & Munculkan Toast'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // CRYPTO DENGAN WARNA (POIN 4)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.indigo, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.currency_bitcoin, color: Colors.orange, size: 30),
                      const SizedBox(width: 10),
                      Text('Bitcoin (Coincap)', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _currentPrice, 
                    style: GoogleFonts.poppins(color: _priceColor, fontSize: 32, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ISOLATE (POIN 4)
            Text('Isolate Heavy Computation', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('NIM 43: Looping 430 Juta kali', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 10),
            if (_isCalculating)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                onPressed: _startHeavyTask,
                icon: const Icon(Icons.bolt),
                label: const Text('Kalkulasi Pajak Kripto'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              ),
            const SizedBox(height: 10),
            if (_calculationResult != null)
              Text('Berhasil menghitung $_calculationResult data!', style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}