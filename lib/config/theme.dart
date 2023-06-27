import 'package:flutter/material.dart';

// Color _tertiaryColor = Color(0xFF30475E);
Color _tertiaryColor = Color.fromARGB(255, 28, 10, 21);
Color _highlightColor = Colors.white;
Color _primaryColor = Color(0xFFDD118C);
Color _secondaryColor = Color(0xFFD4BFCF);
/// The color of the text, used in TextTheme
Color _textColor = _primaryColor;
// Color _textColor = Colors.black;
// Color _splashColor = Color(0xFF95b1db);
Color _splashColor = Colors.grey[300]!;
Color _canvasColor = Color(0xFFE8E8E8);

double? textScaleFactor = 1;

ThemeData theme(BuildContext context){ 
  textScaleFactor = MediaQuery.textScaleFactorOf(context);
  return ThemeData(
    colorScheme: _colorScheme,
    splashColor: _splashColor,
    primaryColor: _primaryColor,
    highlightColor: _highlightColor,
    canvasColor: _canvasColor,
    fontFamily: 'Raleway',
    iconTheme: _iconTheme,
    inputDecorationTheme: _inputDecorationTheme,
    textTheme: _textTheme,
    textSelectionTheme: _textSelectionTheme,
    textButtonTheme: _textButtonTheme,
    elevatedButtonTheme: _elevatedButtonThemeData,
    buttonTheme: _buttonTheme,
    appBarTheme: _appBarTheme,
    snackBarTheme: _snackBarTheme,
    bottomNavigationBarTheme: _bottomNavigationBarTheme,
    floatingActionButtonTheme: _floatingActionButtonTheme,
    timePickerTheme: _timePickerThemeData,
    radioTheme: _radioThemeData
  );
}

RadioThemeData _radioThemeData = RadioThemeData(
  fillColor: MaterialStateProperty.all<Color>(_primaryColor),

);

TimePickerThemeData _timePickerThemeData = TimePickerThemeData(
  backgroundColor: _canvasColor,
  
);

ColorScheme _colorScheme = ColorScheme(
  primary: _primaryColor,
  secondary: _secondaryColor,
  tertiary: _tertiaryColor, 
  background: _highlightColor, 
  brightness: Brightness.light, 
  error: Colors.red, 
  onBackground: Colors.black, 
  onError: _highlightColor, 
  onPrimary: Colors.black, 
  onSecondary: _highlightColor, 
  onTertiary: _highlightColor,
  onSurface: Colors.black, 
  surface: _primaryColor,
);

TextTheme _textTheme = TextTheme(
  /// Used inside "Detail" class
  /// Same size as overline but with FontWeight.bold
  labelMedium: TextStyle(
    color: _primaryColor,
    fontSize: 22*(1/textScaleFactor!),
    //fontWeight: FontWeight.bold
  ),
  labelLarge: TextStyle(
    color: _primaryColor,
    fontSize: 22*(1/textScaleFactor!),
    fontWeight: FontWeight.bold
  ),
  bodyMedium: TextStyle(
    color: _tertiaryColor,
    fontSize: 16*(1/textScaleFactor!),
    // fontWeight: FontWeight.bold
  ),
  bodyLarge: TextStyle(
    color: _tertiaryColor,
    fontSize: 20*(1/textScaleFactor!),
    // fontWeight: FontWeight.bold
  ),
  headlineSmall: TextStyle(
    color: _tertiaryColor,
    fontSize: 25*(1/textScaleFactor!),
    fontWeight: FontWeight.bold
  ),
);

ButtonThemeData _buttonTheme = ButtonThemeData(
  splashColor: Colors.white70,
  // colorScheme: ColorScheme(
  //   error: Colors.red.withOpacity(0.3),
  //   background: _primaryColor,
  //   primaryVariant: _primaryColor,
  //   secondaryVariant: _primaryColor,
  //   onBackground: _primaryColor,
  //   onError: _primaryColor,
  //   onPrimary: _primaryColor,
  //   onSecondary: _primaryColor,
  //   onSurface: _primaryColor,
  //   brightness: Brightness.light,
  //   surface: _primaryColor,
  //   primary: _primaryColor,
  //   secondary: _secondaryColor

  // )
);

ElevatedButtonThemeData _elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(
      _highlightColor
    ),
    backgroundColor: MaterialStateProperty.all<Color>(
      _primaryColor
    ),
    
    padding: MaterialStateProperty.all<EdgeInsets>(
      EdgeInsets.symmetric(vertical: 15, horizontal: 30)
    ),
    textStyle: MaterialStateProperty.all<TextStyle>(
      TextStyle(
        fontSize: 20*(1/textScaleFactor!),
      )
    ),
    /// Doesn't depend on whether it is focused or not
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      )
    ),
  )
);

TextButtonThemeData _textButtonTheme = TextButtonThemeData(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(
      _highlightColor
    ),
    backgroundColor: MaterialStateProperty.all<Color>(
      _secondaryColor
    ),
    overlayColor: MaterialStateProperty.all<Color>(
      _splashColor
    ),
    padding: MaterialStateProperty.all<EdgeInsets>(
      EdgeInsets.zero
    ),
    textStyle: MaterialStateProperty.all<TextStyle>(
      TextStyle(
        fontSize: 15*(1/textScaleFactor!),
        fontFamily: 'Raleway',
        color: _highlightColor 
      )
    ),
    /// Doesn't depend on whether it is focused or not
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      )
    ),
  )
);

IconThemeData _iconTheme = IconThemeData(
  color: Colors.black
);

TextSelectionThemeData _textSelectionTheme = TextSelectionThemeData(
  cursorColor: _secondaryColor,
  selectionHandleColor: _secondaryColor,
  selectionColor: _secondaryColor
  // cursorColor: _secondaryColor,
  // selectionHandleColor: _secondaryColor,
  // selectionColor: _secondaryColor
);

InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
  focusColor: _secondaryColor,
  fillColor: Colors.transparent,
  filled: true,
  floatingLabelBehavior: FloatingLabelBehavior.never,
  contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
  suffixStyle: TextStyle(color: _highlightColor,),
  labelStyle: TextStyle(
    color: _highlightColor
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: Colors.transparent)
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: Colors.transparent)
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: Colors.transparent)
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(color: Colors.transparent),
  ),
);

BottomNavigationBarThemeData _bottomNavigationBarTheme = BottomNavigationBarThemeData(
  // showSelectedLabels: false,
  // showUnselectedLabels: false,
  elevation: 0,
  selectedItemColor: _secondaryColor,
  // backgroundColor: Colors.grey[200],
  backgroundColor: _canvasColor,
  //selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  unselectedLabelStyle: TextStyle(color: Colors.black),
  unselectedItemColor: _primaryColor,
  selectedIconTheme: IconThemeData(
    size: 30
  ),
  unselectedIconTheme: IconThemeData(
    size: 30
  ),
);

AppBarTheme _appBarTheme = AppBarTheme(
  elevation: 0,
  backgroundColor: Colors.transparent,
  titleTextStyle: TextStyle(
    color: _primaryColor,
    fontSize: 20*(1/textScaleFactor!),
    fontWeight: FontWeight.bold,  
    //fontFamily: 'Raleway'
  )
);

SnackBarThemeData _snackBarTheme = SnackBarThemeData(
  backgroundColor: _primaryColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
  ),
  behavior: SnackBarBehavior.floating,
  contentTextStyle: TextStyle(
    fontFamily: "Raleway"
  )
);

FloatingActionButtonThemeData _floatingActionButtonTheme = FloatingActionButtonThemeData(
  splashColor: _splashColor,
  backgroundColor: _primaryColor,
  hoverColor: Colors.black,
  focusColor: Colors.black,
  disabledElevation: 0,
);
