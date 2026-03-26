// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bible Story App';

  @override
  String get homeFeatured => 'Featured Story';

  @override
  String get homeOldTestament => 'Old Testament';

  @override
  String get homeNewTestament => 'New Testament';

  @override
  String get homeCharacterHighlight => 'Character Highlight';

  @override
  String get homeWelcomeTitle => 'Discover stories that stay with you.';

  @override
  String get homeWelcomeSubtitle =>
      'Read, explore characters, and switch seamlessly between English and Indonesian.';

  @override
  String get homeQuickActions => 'Quick Explore';

  @override
  String get homeActionOld => 'Old Testament';

  @override
  String get homeActionNew => 'New Testament';

  @override
  String get homeHeroEyebrow => 'Story Mode';

  @override
  String get homeReadNow => 'Read Now';

  @override
  String get homeExploreCharacter => 'Explore Character';

  @override
  String get storyListTitleOld => 'Old Testament Stories';

  @override
  String get storyListTitleNew => 'New Testament Stories';

  @override
  String get characterListTitle => 'Characters';

  @override
  String get bookmarksTitle => 'Bookmarks';

  @override
  String get bookmarksEmpty => 'No bookmarked stories yet.';

  @override
  String bookmarksSavedCount(int count) {
    return '$count saved stories';
  }

  @override
  String characterProfilesCount(int count) {
    return '$count profiles ready to explore';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navCharacters => 'Characters';

  @override
  String get navBookmarks => 'Bookmarks';

  @override
  String get navSettings => 'Settings';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Search stories or characters';

  @override
  String get searchEmptyQuery => 'Type a keyword to start searching.';

  @override
  String get searchStories => 'Stories';

  @override
  String get searchCharacters => 'Characters';

  @override
  String get searchNoStories => 'No matching stories found.';

  @override
  String get searchNoCharacters => 'No matching characters found.';

  @override
  String get storyDetailRelatedCharacters => 'Related Characters';

  @override
  String get characterDetailStrengths => 'Strengths';

  @override
  String get characterDetailWeaknesses => 'Weaknesses';

  @override
  String get characterDetailRelatedStories => 'Related Stories';

  @override
  String get storyDetailBookmarkAdd => 'Add Bookmark';

  @override
  String get storyDetailBookmarkRemove => 'Remove Bookmark';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageIndonesian => 'Indonesian';

  @override
  String get loading => 'Loading...';

  @override
  String get storiesEmpty => 'No stories available yet.';

  @override
  String get charactersEmpty => 'No characters available yet.';

  @override
  String get viewAll => 'View All';

  @override
  String get genericErrorTitle => 'Something went wrong';

  @override
  String get genericErrorMessage =>
      'We could not load this content right now. Please try again.';

  @override
  String get retryLabel => 'Try Again';

  @override
  String get authPreparingSession => 'Preparing your session...';

  @override
  String get authFailedMessage =>
      'Authentication could not be prepared right now.';

  @override
  String get contentPreparingLibrary => 'Preparing your library...';

  @override
  String get contentFailedMessage =>
      'The app could not prepare local content right now.';

  @override
  String get settingsSubtitle =>
      'Manage language, content sync, and app information.';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String get settingsContent => 'Content';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsRefreshContent => 'Refresh Content';

  @override
  String get settingsRefreshContentSubtitle =>
      'Check Firestore for updated stories and characters.';

  @override
  String get settingsRefreshUpdated => 'Content refreshed successfully.';

  @override
  String get settingsRefreshUpToDate => 'Your content is already up to date.';

  @override
  String get settingsStoriesVersion => 'Stories Version';

  @override
  String get settingsCharactersVersion => 'Characters Version';

  @override
  String get storyDetailScriptureReferences => 'Scripture References';

  @override
  String get characterDetailViewGenealogy => 'View Genealogy';

  @override
  String get genealogyEmpty => 'No genealogy available yet.';
}
