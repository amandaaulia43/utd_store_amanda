import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Path sudah diperbaiki karena file sekarang ada di dalam folder pages
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

  // Fungsi untuk menjalankan Isolate (Poin 4 ETS)
  Future<void> _startHeavyTask() async {
    setState(() {
      _isCalculating = true;
      _calculationResult = null;
    });

    final result = await sl<CryptoService>().runHeavyComputation();

    setState(() {
      _calculationResult = result;
      _isCalculating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Crypto Hub (NIM: 43)', 
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.currency_bitcoin, color: Colors.orange, size: 40),
                      const SizedBox(width: 10),
                      Text('Bitcoin (BTC)', 
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<String>(
                    stream: sl<CryptoService>().getBtcPriceStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text('\$${snapshot.data}', 
                          style: GoogleFonts.poppins(
                            color: Colors.white, 
                            fontSize: 32, 
                            fontWeight: FontWeight.bold // TYPO DIPERBAIKI DI SINI
                          ));
                      }
                      return const CircularProgressIndicator(color: Colors.white);
                    },
                  ),
                  Text('Live Price from Binance', 
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            Text('Isolate Heavy Computation', 
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Text('NIM 43: Looping 430.000.000 kali', 
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 20),
            
            if (_isCalculating)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                onPressed: _startHeavyTask,
                icon: const Icon(Icons.bolt),
                label: const Text('Mulai Hitung Pajak'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            
            const SizedBox(height: 20),
            if (_calculationResult != null)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green),
                ),
                child: Text('Berhasil menghitung $_calculationResult data tanpa membuat UI macet!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.w500)),
              ),
          ],
        ),
      ),
    );
  }
}