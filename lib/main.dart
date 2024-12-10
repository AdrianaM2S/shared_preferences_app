import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/intl_es.dart';
import 'l10n/intl_en.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  String userName = "";
  String language = "español"; // Default language
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadPreferences();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      userName = prefs.getString('userName') ?? "";
      language =
          prefs.getString('language') ?? "español"; // Load language preference
      _controller.text = userName;
    });
  }

  Future<void> _saveThemePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }

  Future<void> _saveUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', name);
  }

  Future<void> _saveLanguagePreference(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language', lang);
  }

  Future<void> _resetPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isDarkMode');
    await prefs.remove('userName');
    await prefs.remove('language');
    setState(() {
      isDarkMode = false;
      userName = "";
      language = "español";
      _controller.text = userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set the appropriate localization based on selected language
    String getString(String key) {
      if (language == "español") {
        switch (key) {
          case "title":
            return AppLocalizationsEs.title;
          case "userNameLabel":
            return AppLocalizationsEs.userNameLabel;
          case "lightMode":
            return AppLocalizationsEs.lightMode;
          case "darkMode":
            return AppLocalizationsEs.darkMode;
          case "savePreferences":
            return AppLocalizationsEs.savePreferences;
          case "resetPreferences":
            return AppLocalizationsEs.resetPreferences;
          case "preferencesSaved":
            return AppLocalizationsEs.preferencesSaved;
          case "preferencesReset":
            return AppLocalizationsEs.preferencesReset;
          default:
            return '';
        }
      } else {
        switch (key) {
          case "title":
            return AppLocalizationsEn.title;
          case "userNameLabel":
            return AppLocalizationsEn.userNameLabel;
          case "lightMode":
            return AppLocalizationsEn.lightMode;
          case "darkMode":
            return AppLocalizationsEn.darkMode;
          case "savePreferences":
            return AppLocalizationsEn.savePreferences;
          case "resetPreferences":
            return AppLocalizationsEn.resetPreferences;
          case "preferencesSaved":
            return AppLocalizationsEn.preferencesSaved;
          case "preferencesReset":
            return AppLocalizationsEn.preferencesReset;
          default:
            return '';
        }
      }
    }

    return MaterialApp(
      locale: language == "español" ? Locale('es', 'ES') : Locale('en', 'US'),
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(getString("title")),
        ),
        body: Builder(
          builder: (BuildContext context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: getString("userNameLabel"),
                  ),
                  onChanged: (value) {
                    userName = value;
                  },
                  controller: _controller,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isDarkMode = false;
                          _saveThemePreference(isDarkMode);
                        });
                      },
                      child: Text(getString("lightMode")),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isDarkMode = true;
                          _saveThemePreference(isDarkMode);
                        });
                      },
                      child: Text(getString("darkMode")),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  value: language,
                  items: <String>['español', 'inglés']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value == "español" ? "Español" : "Inglés"),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      language = newValue!;
                      _saveLanguagePreference(language);
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _saveUserName(userName);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(getString("preferencesSaved")),
                      ),
                    );
                  },
                  child: Text(getString("savePreferences")),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _resetPreferences();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(getString("preferencesReset")),
                      ),
                    );
                  },
                  child: Text(getString("resetPreferences")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
