import 'dart:convert';
import 'dart:isolate';
import 'package:web_socket_channel/web_socket_channel.dart';

class CryptoService {
  WebSocketChannel? _channel;

  // Menggunakan Stream dengan async* agar lebih stabil saat koneksi naik-turun
  Stream<String> getBtcPriceStream() async* {
    while (true) {
      try {
        // Kita pakai Binance karena datanya jauh lebih cepat/real-time untuk video demo
        _channel = WebSocketChannel.connect(
          Uri.parse('wss://stream.binance.com:9443/ws/btcusdt@trade'),
        );

        await for (var event in _channel!.stream) {
          final data = jsonDecode(event);
          if (data != null && data['p'] != null) {
            // 'p' adalah key untuk price di Binance
            double price = double.parse(data['p']);
            yield price.toStringAsFixed(2);
          }
        }
      } catch (e) {
        // Jika error (misal internet putus), tunggu 3 detik lalu coba sambung lagi
        // Ini mencegah tulisan "Error" muncul di layar HP
        yield "Loading..."; 
        await Future.delayed(const Duration(seconds: 3));
      }
    }
  }

  void closeConnection() {
    _channel?.sink.close();
  }

  // LOGIKA ISOLATE (Syarat ETS)
  Future<int> runHeavyComputation() async {
    return await Isolate.run(_heavyTask);
  }
}

// Fungsi di luar class (Top-level) agar Isolate bisa jalan
int _heavyTask() {
  int result = 0;
  // LOGIKA NIM 43: 430.000.000 kali looping
  const int loopCount = 430000000; 
  
  for (int i = 0; i < loopCount; i++) {
    result++;
  }
  
  return result;
}