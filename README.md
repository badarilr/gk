# Raagbook Flutter starter kit

## What's here
- `assets/data/raagbook.json` — the transcribed book (page-format, with raagIndex)
- `lib/models/raag_page.dart` — Dart models matching the JSON shape
- `lib/services/raagbook_repository.dart` — loads + caches the JSON from assets
- `lib/widgets/swara_text.dart` — renders swara notation with real octave marks (dot above for upper, underline for lower) instead of raw `S'` / `,N` text
- `lib/screens/raag_list_screen.dart` — home screen, raags grouped via raagIndex, expandable to pages
- `lib/screens/raag_page_view.dart` — single page view: renders header/grid/lyrics blocks with proper swara notation, plus a toggle button (top-right) to overlay the original page photo
- `lib/main.dart` — app entry point, already wired to open on `RaagListScreen`

## Steps to wire in

**If this is a brand-new Flutter project** (`flutter create raagbook`): just copy everything in this zip's `lib/` and `assets/` straight over the generated ones — `lib/main.dart` here already replaces the default counter-app one.

**If you're merging into an existing project**: copy `models/`, `services/`, `widgets/`, `screens/` into your `lib/`, but don't overwrite your own `main.dart` — instead add `import 'screens/raag_list_screen.dart';` and point your home route at `RaagListScreen()` wherever that's set up in your app.

Either way:

1. Copy `assets/data/raagbook.json` into your project's `assets/data/`, and the page photos from `raagbook_page_images.zip` into `assets/pages/`.

2. Register both asset folders in `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/data/
       - assets/pages/
   ```

3. Run `flutter pub get`, then `flutter run`.

## Notes
- Pages tagged `"status": "pending_verification"` in the JSON show a warning banner instead of content, with a nudge to check the photo toggle — matches the pages we haven't transcribed yet (drill grids, alankar pages).
- `RaagbookRepository.load()` caches after the first call, so navigating between screens won't re-parse the JSON.
- As more raags get transcribed, just replace `assets/data/raagbook.json` with the updated file — no code changes needed unless the JSON *shape* changes (new block types, etc).
