import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/testament.dart';
import '../ui/screens/bookmarks_screen.dart';
import '../ui/screens/character_detail_screen.dart';
import '../ui/screens/character_list_screen.dart';
import '../ui/screens/genealogy_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/search_screen.dart';
import '../ui/screens/settings_screen.dart';
import '../ui/screens/story_detail_screen.dart';
import '../ui/screens/story_list_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/stories/:testament',
        builder: (context, state) {
          final testamentValue = state.pathParameters['testament'] ?? 'old';
          final testament = TestamentX.fromString(testamentValue);
          return StoryListScreen(testament: testament);
        },
      ),
      GoRoute(
        path: '/story/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return StoryDetailScreen(storyId: id);
        },
      ),
      GoRoute(
        path: '/characters',
        builder: (context, state) => const CharacterListScreen(),
      ),
      GoRoute(
        path: '/character/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CharacterDetailScreen(characterId: id);
        },
      ),

      GoRoute(
        path: '/genealogy/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return GenealogyScreen(genealogyId: id);
        },
      ),
      GoRoute(
        path: '/bookmarks',
        builder: (context, state) => const BookmarksScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
