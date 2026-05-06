class SplashService {
  Future<void> executeDelay() async {
    // LOGIKA PERSONAL: Delay persis 3 detik sesuai digit terakhir NIM (20123043)
    // Syarat ETS: Dilakukan di level Service/Domain, BUKAN di UI.
    await Future.delayed(const Duration(seconds: 3));
  }
}