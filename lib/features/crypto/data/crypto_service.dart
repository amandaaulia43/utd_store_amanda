import 'dart:convert';
import 'dart:isolate';
import 'package:web_socket_channel/web_socket_channel.dart';

class CryptoService {
  WebSocketChannel? _channel;

  // 1. WebSocket untuk mengambil harga BTC secara Real-Time dari CoinCap (Syarat ETS)
  Stream<String> getBtcPriceStream() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.coincap.io/prices?assets=bitcoin'),
    );
    
    return _channel!.stream.map((event) {
      final data = jsonDecode(event);
      // Mengambil harga dari key 'bitcoin' dan memformatnya jadi 2 angka di belakang koma
      final price = double.parse(data['bitcoin']).toStringAsFixed(2);
      return price;
    });
  }

  void closeConnection() {
    _channel?.sink.close();
  }

  // 2. Fungsi untuk menjalankan Isolate agar UI tidak freeze
  Future<int> runHeavyComputation() async {
    // Isolate.run akan mengeksekusi fungsi _heavyTask di thread terpisah
    return await Isolate.run(_heavyTask);
  }
}

// SYARAT ETS: Fungsi ini wajib di luar class (Top-level function) agar bisa masuk Isolate
int _heavyTask() {
  int result = 0;
  // LOGIKA PERSONAL: 2 Digit Terakhir NIM (43) x 10.000.000 = 430.000.000
  final int loopCount = 430000000; 
  
  for (int i = 0; i < loopCount; i++) {
    result++;
  }
  
  return result;
}