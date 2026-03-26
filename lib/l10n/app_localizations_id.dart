// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Aplikasi Cerita Alkitab';

  @override
  String get homeFeatured => 'Cerita Unggulan';

  @override
  String get homeOldTestament => 'Perjanjian Lama';

  @override
  String get homeNewTestament => 'Perjanjian Baru';

  @override
  String get homeCharacterHighlight => 'Tokoh Unggulan';

  @override
  String get homeWelcomeTitle => 'Temukan kisah yang tinggal dalam hati.';

  @override
  String get homeWelcomeSubtitle =>
      'Baca cerita, jelajahi tokoh, dan beralih mulus antara Bahasa Inggris dan Indonesia.';

  @override
  String get homeQuickActions => 'Akses Cepat';

  @override
  String get homeActionOld => 'Perjanjian Lama';

  @override
  String get homeActionNew => 'Perjanjian Baru';

  @override
  String get homeHeroEyebrow => 'Mode Cerita';

  @override
  String get homeReadNow => 'Baca Sekarang';

  @override
  String get homeExploreCharacter => 'Jelajahi Tokoh';

  @override
  String get storyListTitleOld => 'Cerita Perjanjian Lama';

  @override
  String get storyListTitleNew => 'Cerita Perjanjian Baru';

  @override
  String get characterListTitle => 'Tokoh';

  @override
  String get bookmarksTitle => 'Penanda';

  @override
  String get bookmarksEmpty => 'Belum ada cerita yang disimpan.';

  @override
  String bookmarksSavedCount(int count) {
    return '$count cerita tersimpan';
  }

  @override
  String characterProfilesCount(int count) {
    return '$count profil siap dijelajahi';
  }

  @override
  String get navHome => 'Beranda';

  @override
  String get navCharacters => 'Tokoh';

  @override
  String get navBookmarks => 'Penanda';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get searchTitle => 'Pencarian';

  @override
  String get searchHint => 'Cari cerita atau tokoh';

  @override
  String get searchEmptyQuery => 'Ketik kata kunci untuk mulai mencari.';

  @override
  String get searchStories => 'Cerita';

  @override
  String get searchCharacters => 'Tokoh';

  @override
  String get searchNoStories => 'Tidak ada cerita yang cocok.';

  @override
  String get searchNoCharacters => 'Tidak ada tokoh yang cocok.';

  @override
  String get storyDetailRelatedCharacters => 'Tokoh Terkait';

  @override
  String get characterDetailStrengths => 'Kekuatan';

  @override
  String get characterDetailWeaknesses => 'Kelemahan';

  @override
  String get characterDetailRelatedStories => 'Cerita Terkait';

  @override
  String get storyDetailBookmarkAdd => 'Tambah Penanda';

  @override
  String get storyDetailBookmarkRemove => 'Hapus Penanda';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get languageLabel => 'Bahasa';

  @override
  String get languageEnglish => 'Inggris';

  @override
  String get languageIndonesian => 'Indonesia';

  @override
  String get loading => 'Memuat...';

  @override
  String get storiesEmpty => 'Belum ada cerita.';

  @override
  String get charactersEmpty => 'Belum ada tokoh.';

  @override
  String get viewAll => 'Lihat Semua';

  @override
  String get genericErrorTitle => 'Terjadi kendala';

  @override
  String get genericErrorMessage =>
      'Konten belum bisa dimuat saat ini. Silakan coba lagi.';

  @override
  String get retryLabel => 'Coba Lagi';

  @override
  String get authPreparingSession => 'Menyiapkan sesi Anda...';

  @override
  String get authFailedMessage => 'Autentikasi belum bisa disiapkan saat ini.';

  @override
  String get contentPreparingLibrary => 'Menyiapkan pustaka Anda...';

  @override
  String get contentFailedMessage =>
      'Aplikasi belum bisa menyiapkan konten lokal saat ini.';

  @override
  String get settingsSubtitle =>
      'Atur bahasa, sinkronisasi konten, dan informasi aplikasi.';

  @override
  String get settingsPreferences => 'Preferensi';

  @override
  String get settingsContent => 'Konten';

  @override
  String get settingsAbout => 'Tentang';

  @override
  String get settingsRefreshContent => 'Segarkan Konten';

  @override
  String get settingsRefreshContentSubtitle =>
      'Periksa Firestore untuk cerita dan tokoh terbaru.';

  @override
  String get settingsRefreshUpdated => 'Konten berhasil diperbarui.';

  @override
  String get settingsRefreshUpToDate => 'Konten Anda sudah versi terbaru.';

  @override
  String get settingsStoriesVersion => 'Versi Cerita';

  @override
  String get settingsCharactersVersion => 'Versi Tokoh';

  @override
  String get storyDetailScriptureReferences => 'Referensi Alkitab';

  @override
  String get characterDetailViewGenealogy => 'Lihat Silsilah';

  @override
  String get genealogyEmpty => 'Belum ada silsilah.';
}
