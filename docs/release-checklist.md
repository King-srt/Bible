# Release Build Checklist

## 1. Build Setup

- Confirm `flutter pub get` succeeds
- Confirm `flutter analyze lib` shows no issues
- Generate a release build successfully:
  - `flutter build appbundle --release`

## 2. Startup and Stability

- App opens correctly in release mode
- No blank startup screen beyond expected splash/loading behavior
- App does not crash on first launch
- App reopens correctly after being closed

## 3. Content Loading

- Stories load correctly from local cache
- Characters load correctly from local cache
- App still opens when offline after content has been cached
- Firestore sync updates content when `content_meta` version changes

## 4. Core User Flows

- Home screen loads
- Story list opens for Old and New Testament
- Story detail opens correctly
- Character list opens correctly
- Character detail opens correctly
- Search works for stories and characters
- Language switching works

## 5. Auth and User Data

- Anonymous auth creates a user successfully
- Bookmarks can be added
- Bookmarks can be removed
- Bookmarks persist after app restart
- Bookmark sync works with Firestore

## 6. Offline and Refresh

- App can reopen offline after first successful online use
- Pull-to-refresh does not break UI
- No unexpected empty state when valid local data exists

## 7. Assets and UI

- Images load correctly or fall back safely
- No overflow warnings in release use
- Text is readable on small and medium devices
- Character and story cards crop acceptably

## 8. Firebase and Security

- Firestore rules are active and correct
- Anonymous users can access only their own bookmarks
- Story and character content remains readable
- `content_meta` documents exist and use semantic versioning like `v1.0.0`

## 9. Play Store Readiness

- App name finalized
- App icon finalized
- Privacy Policy hosted at a public URL
- Release signing configured
- Version name/code set correctly
- Screenshots prepared
- Short description and full description prepared

## 10. Recommended Manual Test Pass

Test on release build for:

- first launch online
- relaunch offline
- bookmark add/remove
- search
- language switch
- content update after version bump
