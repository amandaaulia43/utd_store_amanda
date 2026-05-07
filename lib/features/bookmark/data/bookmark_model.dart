import 'package:isar/isar.dart';

// Penting: Nama file harus bookmark_model.dart agar generator bekerja
part 'bookmark_model.g.dart';

@collection
class BookmarkModel {
  Id id = Isar.autoIncrement;

  late int productId;
  late String title;
  late double price;
  late String image;
  
  // LOGIKA PERSONAL: Menyimpan timestamp waktu simpan
  late DateTime createdAt;

  // Helper untuk menampilkan format jam (Misal: 14:05) sesuai syarat PDF
  String get formattedTime => 
      "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}";
}