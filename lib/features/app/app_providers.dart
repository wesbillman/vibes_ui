import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(),
);

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>(
  (ref) => DarkModeNotifier(ref.watch(sharedPreferencesProvider)),
);

class DarkModeNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;

  DarkModeNotifier(this._prefs) : super(_prefs.getBool('dark_mode') ?? false);

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool('dark_mode', value);
    state = value;
  }
}

final projectPathProvider = StateNotifierProvider<ProjectPathNotifier, String>(
  (ref) => ProjectPathNotifier(ref.watch(sharedPreferencesProvider)),
);

class ProjectPathNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;

  ProjectPathNotifier(this._prefs)
    : super(_prefs.getString('project_path') ?? '');

  Future<void> setPath(String path) async {
    await _prefs.setString('project_path', path);
    state = path;
  }
}
