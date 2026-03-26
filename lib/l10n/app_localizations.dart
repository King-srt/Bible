import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Bible Story App'**
  String get appTitle;

  /// No description provided for @homeFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured Story'**
  String get homeFeatured;

  /// No description provided for @homeOldTestament.
  ///
  /// In en, this message translates to:
  /// **'Old Testament'**
  String get homeOldTestament;

  /// No description provided for @homeNewTestament.
  ///
  /// In en, this message translates to:
  /// **'New Testament'**
  String get homeNewTestament;

  /// No description provided for @homeCharacterHighlight.
  ///
  /// In en, this message translates to:
  /// **'Character Highlight'**
  String get homeCharacterHighlight;

  /// No description provided for @homeWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover stories that stay with you.'**
  String get homeWelcomeTitle;

  /// No description provided for @homeWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read, explore characters, and switch seamlessly between English and Indonesian.'**
  String get homeWelcomeSubtitle;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Explore'**
  String get homeQuickActions;

  /// No description provided for @homeActionOld.
  ///
  /// In en, this message translates to:
  /// **'Old Testament'**
  String get homeActionOld;

  /// No description provided for @homeActionNew.
  ///
  /// In en, this message translates to:
  /// **'New Testament'**
  String get homeActionNew;

  /// No description provided for @homeHeroEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Story Mode'**
  String get homeHeroEyebrow;

  /// No description provided for @homeReadNow.
  ///
  /// In en, this message translates to:
  /// **'Read Now'**
  String get homeReadNow;

  /// No description provided for @homeExploreCharacter.
  ///
  /// In en, this message translates to:
  /// **'Explore Character'**
  String get homeExploreCharacter;

  /// No description provided for @storyListTitleOld.
  ///
  /// In en, this message translates to:
  /// **'Old Testament Stories'**
  String get storyListTitleOld;

  /// No description provided for @storyListTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New Testament Stories'**
  String get storyListTitleNew;

  /// No description provided for @characterListTitle.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get characterListTitle;

  /// No description provided for @bookmarksTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarksTitle;

  /// No description provided for @bookmarksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No bookmarked stories yet.'**
  String get bookmarksEmpty;

  /// No description provided for @bookmarksSavedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} saved stories'**
  String bookmarksSavedCount(int count);

  /// No description provided for @characterProfilesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} profiles ready to explore'**
  String characterProfilesCount(int count);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCharacters.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get navCharacters;

  /// No description provided for @navBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get navBookmarks;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search stories or characters'**
  String get searchHint;

  /// No description provided for @searchEmptyQuery.
  ///
  /// In en, this message translates to:
  /// **'Type a keyword to start searching.'**
  String get searchEmptyQuery;

  /// No description provided for @searchStories.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get searchStories;

  /// No description provided for @searchCharacters.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get searchCharacters;

  /// No description provided for @searchNoStories.
  ///
  /// In en, this message translates to:
  /// **'No matching stories found.'**
  String get searchNoStories;

  /// No description provided for @searchNoCharacters.
  ///
  /// In en, this message translates to:
  /// **'No matching characters found.'**
  String get searchNoCharacters;

  /// No description provided for @storyDetailRelatedCharacters.
  ///
  /// In en, this message translates to:
  /// **'Related Characters'**
  String get storyDetailRelatedCharacters;

  /// No description provided for @characterDetailStrengths.
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get characterDetailStrengths;

  /// No description provided for @characterDetailWeaknesses.
  ///
  /// In en, this message translates to:
  /// **'Weaknesses'**
  String get characterDetailWeaknesses;

  /// No description provided for @characterDetailRelatedStories.
  ///
  /// In en, this message translates to:
  /// **'Related Stories'**
  String get characterDetailRelatedStories;

  /// No description provided for @storyDetailBookmarkAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Bookmark'**
  String get storyDetailBookmarkAdd;

  /// No description provided for @storyDetailBookmarkRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove Bookmark'**
  String get storyDetailBookmarkRemove;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get languageIndonesian;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @storiesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No stories available yet.'**
  String get storiesEmpty;

  /// No description provided for @charactersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No characters available yet.'**
  String get charactersEmpty;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @genericErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get genericErrorTitle;

  /// No description provided for @genericErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'We could not load this content right now. Please try again.'**
  String get genericErrorMessage;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get retryLabel;

  /// No description provided for @authPreparingSession.
  ///
  /// In en, this message translates to:
  /// **'Preparing your session...'**
  String get authPreparingSession;

  /// No description provided for @authFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Authentication could not be prepared right now.'**
  String get authFailedMessage;

  /// No description provided for @contentPreparingLibrary.
  ///
  /// In en, this message translates to:
  /// **'Preparing your library...'**
  String get contentPreparingLibrary;

  /// No description provided for @contentFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'The app could not prepare local content right now.'**
  String get contentFailedMessage;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage language, content sync, and app information.'**
  String get settingsSubtitle;

  /// No description provided for @settingsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsPreferences;

  /// No description provided for @settingsContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get settingsContent;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsRefreshContent.
  ///
  /// In en, this message translates to:
  /// **'Refresh Content'**
  String get settingsRefreshContent;

  /// No description provided for @settingsRefreshContentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check Firestore for updated stories and characters.'**
  String get settingsRefreshContentSubtitle;

  /// No description provided for @settingsRefreshUpdated.
  ///
  /// In en, this message translates to:
  /// **'Content refreshed successfully.'**
  String get settingsRefreshUpdated;

  /// No description provided for @settingsRefreshUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Your content is already up to date.'**
  String get settingsRefreshUpToDate;

  /// No description provided for @settingsStoriesVersion.
  ///
  /// In en, this message translates to:
  /// **'Stories Version'**
  String get settingsStoriesVersion;

  /// No description provided for @settingsCharactersVersion.
  ///
  /// In en, this message translates to:
  /// **'Characters Version'**
  String get settingsCharactersVersion;

  /// No description provided for @storyDetailScriptureReferences.
  ///
  /// In en, this message translates to:
  /// **'Scripture References'**
  String get storyDetailScriptureReferences;

  /// No description provided for @characterDetailViewGenealogy.
  ///
  /// In en, this message translates to:
  /// **'View Genealogy'**
  String get characterDetailViewGenealogy;

  /// No description provided for @genealogyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No genealogy available yet.'**
  String get genealogyEmpty;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
