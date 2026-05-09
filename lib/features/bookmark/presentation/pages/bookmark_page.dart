import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/isar_service.dart';
import '../../data/bookmark_model.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A24)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Favorites',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1A1A24),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // SYARAT ETS: Wajib menggunakan FutureBuilder + watch() agar reaktif (Poin 3)
      body: FutureBuilder<Stream<List<BookmarkModel>>>(
        future: sl<IsarService>().watchBookmarks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          return StreamBuilder<List<BookmarkModel>>(
            stream: snapshot.data,
            builder: (context, streamSnapshot) {
              if (!streamSnapshot.hasData || streamSnapshot.data!.isEmpty) {
                return Center(
                  child: Text('Belum ada favorit.', style: GoogleFonts.poppins()),
                );
              }

              final bookmarks = streamSnapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final item = bookmarks[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(item.image, width: 50, height: 50, fit: BoxFit.contain),
                      ),
                      title: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('\$${item.price}', style: GoogleFonts.poppins(color: Colors.indigo)),
                          // LOGIKA PERSONAL: Menampilkan jam simpan (Poin 3)
                          Text(
                            'Disimpan pada ${item.formattedTime}',
                            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () async {
                          // Memanggil fungsi hapus
                          await sl<IsarService>().deleteBookmark(item.id);
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Produk dihapus dari Favorit')),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}