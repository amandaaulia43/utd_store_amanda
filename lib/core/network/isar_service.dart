import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/bookmark/data/bookmark_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [BookmarkModelSchema],
        directory: dir.path,
      );
    }
    return Isar.getInstance()!;
  }

  // Fungsi Simpan dengan Logika Personal Timestamp
  Future<void> saveBookmark(BookmarkModel bookmark) async {
    final isar = await db;
    bookmark.createdAt = DateTime.now(); // Syarat NIM: Timestamp
    await isar.writeTxn(() async {
      await isar.bookmarkModels.put(bookmark);
    });
  }

  // Fungsi Stream untuk Halaman Bookmark (Syarat PDF: Wajib pakai watch)
  Future<Stream<List<BookmarkModel>>> watchBookmarks() async {
    final isar = await db;
    return isar.bookmarkModels.where().watch(fireImmediately: true);
  }
}