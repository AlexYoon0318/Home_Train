import 'package:flutter/material.dart';
import 'package:home_t/root_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:theme_provider/theme_provider.dart';

void main(){
  initializeDateFormatting().then((_) => runApp(MyApp()));}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme.light(),
        AppTheme.dark(),
        customAppTheme(),
      ],
      child: MaterialApp(
        home: ThemeConsumer(
            child: RootPage()
        ),
      ),
    );
  }
}

AppTheme customAppTheme() {
  return AppTheme(
    id: "따뜻한테마",
    description: "Custom Color Scheme",
    data: ThemeData(
      accentColor: Colors.yellow,
      primaryColor: Colors.red,
      scaffoldBackgroundColor: Colors.yellow[200],
      cardColor: Colors.deepOrange,

      buttonColor: Colors.amber,
      dialogBackgroundColor: Colors.yellow,
    ),
  );
}


class MyThemeOptions implements AppThemeOptions{
  final Color specificButtonColor;
  MyThemeOptions(this.specificButtonColor);
}