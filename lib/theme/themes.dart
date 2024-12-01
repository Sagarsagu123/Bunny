import 'package:flutter/material.dart';

const String fontPoppins = 'Poppins';

class AppTheme {
  //BuildContext context;

  Color appBlue = const Color(0xFF4977AD);
  Color appBlueDisabled = const Color(0x994977AD);
  Color appDarkBlue = const Color(0xFF06254b);
  Color appDarkBlueDisabled = const Color(0x9906254b);
  Color appLightBlue = const Color(0xFF1F6ECB);
  Color appLightBlueDisabled = const Color(0x991F6ECB);
  Color appGreen = const Color(0xFFBADB44);
  Color appGrey = const Color(0xFFE5E5E5);
  Color appWhite = const Color(0xFFFFFFFF);
  Color appBlueColor = const Color(0xFF0E4086);

  //AppTheme(this.context);

  Color getLightCheckboxColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return appBlue;
    } else {
      return Colors.grey.shade600;
    }
  }

  Color getDarkCheckboxColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return appLightBlue;
    } else {
      return Colors.grey.shade300;
    }
  }

  Color getShadowColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.focused)) {
      return Colors.white;
    } else {
      return Colors.transparent;
    }
  }

  ThemeData get lightTheme => ThemeData.light().copyWith(
      scaffoldBackgroundColor: appGrey,
      primaryColor: appBlue,
      buttonTheme: ThemeData.light().buttonTheme.copyWith(
            buttonColor: appBlue,
            disabledColor: appBlueDisabled,
            textTheme: ButtonTextTheme.primary,
          ),
      appBarTheme: ThemeData.light().appBarTheme.copyWith(
          color: appWhite,
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          elevation: 0,
          titleTextStyle: TextStyle(color: appBlue, fontSize: 20)),
      colorScheme: ThemeData.light().colorScheme.copyWith(
            primary: appBlue,
            secondary: appGreen,
          ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            textStyle: ThemeData.light()
                .textTheme
                .titleSmall!
                .copyWith(fontFamily: fontPoppins),
            foregroundColor: appBlue,
            disabledForegroundColor: appBlueDisabled),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            foregroundColor: appBlue, disabledForegroundColor: appBlueDisabled),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appBlue,
          disabledBackgroundColor: appBlueDisabled,
          disabledForegroundColor: appWhite,
          elevation: 0.0,
          shadowColor: Colors.transparent,
        ).copyWith(backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return appBlue.withOpacity(0.6);
          } else if (states.contains(MaterialState.pressed)) {
            return appBlue.withOpacity(0.8);
          } else if (states.contains(MaterialState.hovered)) {
            return appBlue.withOpacity(0.85);
          } else {
            return appBlue;
          }
        }), overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.white.withOpacity(0.2);
          } else if (states.contains(MaterialState.pressed)) {
            return Colors.white.withOpacity(0.1);
          } else if (states.contains(MaterialState.hovered)) {
            return Colors.white.withOpacity(0.12);
          } else {
            return Colors.transparent;
          }
        }), shape: MaterialStateProperty.resolveWith((states) {
          return null;

          // if (states.contains(MaterialState.focused) &&
          //     !states.contains(MaterialState.disabled)) {
          //   return DecoratedOutlinedBorder(
          //     innerShadow: const [
          //       BoxShadow(
          //         color: Colors.white,
          //         blurRadius: 0,
          //         spreadRadius: 5,
          //       ),
          //     ],
          //     child: RoundedRectangleBorder(
          //       side: BorderSide(
          //         color: AppTheme().appBlue,
          //         width: 2,
          //       ),
          //       borderRadius: BorderRadius.circular(4),
          //     ),
          //   );
          // } else {
          //   return null;
          // }
        })),
      ),
      sliderTheme: ThemeData.light()
          .sliderTheme
          .copyWith(thumbColor: appBlue, activeTrackColor: appLightBlue),
      //toggleableActiveColor: appBlue,
      textTheme: ThemeData.light().textTheme.copyWith(
            displayLarge: ThemeData.light()
                .textTheme
                .displayLarge!
                .copyWith(fontFamily: fontPoppins),
            displayMedium: ThemeData.light()
                .textTheme
                .displayMedium!
                .copyWith(fontFamily: fontPoppins),
            displaySmall: ThemeData.light().textTheme.displaySmall!.copyWith(
                  color: appBlue,
                  fontFamily: fontPoppins,
                ),
            headlineMedium:
                ThemeData.light().textTheme.headlineMedium!.copyWith(
                      color: appBlue,
                      fontFamily: fontPoppins,
                    ),
            headlineSmall: ThemeData.light().textTheme.headlineSmall!.copyWith(
                  fontFamily: fontPoppins,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: appBlue,
                ),
            titleLarge: ThemeData.light().textTheme.titleLarge!.copyWith(
                fontFamily: fontPoppins,
                fontSize: 15,
                color: appBlue,
                fontWeight: FontWeight.bold),
            titleMedium: ThemeData.light()
                .textTheme
                .titleMedium!
                .copyWith(fontFamily: fontPoppins, color: Colors.black),
            titleSmall: ThemeData.light()
                .textTheme
                .titleSmall!
                .copyWith(fontFamily: fontPoppins, color: Colors.black),
            bodyLarge: ThemeData.light().textTheme.bodyLarge!.copyWith(
                fontFamily: fontPoppins,
                color: const Color(0xFF2F4682),
                fontSize: 10),
            bodyMedium: ThemeData.light().textTheme.bodyMedium!.copyWith(
                fontFamily: fontPoppins, color: const Color(0xFF161616)),
            labelLarge: ThemeData.light()
                .textTheme
                .labelLarge
                ?.copyWith(fontFamily: fontPoppins),
          ),
      primaryTextTheme: ThemeData.light().primaryTextTheme.copyWith(
            displayLarge: ThemeData.light()
                .primaryTextTheme
                .displayLarge!
                .copyWith(fontFamily: fontPoppins),
            displayMedium: ThemeData.light()
                .primaryTextTheme
                .displayMedium!
                .copyWith(fontFamily: fontPoppins),
            displaySmall: ThemeData.light()
                .primaryTextTheme
                .displaySmall!
                .copyWith(fontFamily: fontPoppins),
            headlineMedium: ThemeData.light()
                .primaryTextTheme
                .headlineMedium!
                .copyWith(fontFamily: fontPoppins),
            headlineSmall: ThemeData.light()
                .primaryTextTheme
                .headlineSmall!
                .copyWith(
                    fontFamily: fontPoppins,
                    fontWeight: FontWeight.bold,
                    color: appBlueColor),
            titleLarge: ThemeData.light()
                .primaryTextTheme
                .titleLarge!
                .copyWith(fontFamily: fontPoppins),
            titleMedium: ThemeData.light()
                .primaryTextTheme
                .titleMedium!
                .copyWith(fontFamily: fontPoppins),
            titleSmall: ThemeData.light()
                .primaryTextTheme
                .titleSmall!
                .copyWith(fontFamily: fontPoppins),
            labelLarge: ThemeData.light()
                .textTheme
                .labelLarge
                ?.copyWith(fontFamily: fontPoppins),
          ),
      inputDecorationTheme: InputDecorationTheme(
        focusColor: appGreen,
        border: const OutlineInputBorder(),
        fillColor: Colors.white,
      ),
      checkboxTheme: ThemeData.light().checkboxTheme.copyWith(
            fillColor: MaterialStateProperty.resolveWith(getLightCheckboxColor),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          ),
      cardTheme: ThemeData.light().cardTheme.copyWith(
            color: appGrey,
          ),
      tooltipTheme: ThemeData.light().tooltipTheme.copyWith(
            textStyle: const TextStyle(color: Color.fromRGBO(85, 85, 85, 1)),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 1),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF949494).withOpacity(0.25),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(0, 0)),
              ],
            ),
          ),
      iconTheme: ThemeData.light().iconTheme.copyWith(
            color: const Color(0xFF0E4086),
          ));

  ThemeData get darkTheme => ThemeData.dark().copyWith(
      canvasColor: appDarkBlue,
      scaffoldBackgroundColor: appBlue,
      cardColor: appLightBlue,
      primaryColor: appLightBlue,
      dialogTheme: DialogTheme(
        backgroundColor: appDarkBlue,
      ),
      appBarTheme: ThemeData.light().appBarTheme.copyWith(
          color: appBlue,
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          elevation: 0,
          titleTextStyle: TextStyle(color: appWhite, fontSize: 20)),
      buttonTheme: ButtonThemeData(
        buttonColor: appLightBlue,
        disabledColor: appBlueDisabled,
      ),
      colorScheme: ThemeData.dark().colorScheme.copyWith(
            primary: Colors.white,
            secondary: appGreen,
            surface: appDarkBlue,
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appBlue,
          disabledBackgroundColor: appBlueDisabled,
          disabledForegroundColor: appWhite,
        ),
      ),
      applyElevationOverlayColor: true,
      textTheme: ThemeData.dark().textTheme.copyWith(
            displayLarge: ThemeData.dark()
                .textTheme
                .displayLarge!
                .copyWith(fontFamily: fontPoppins),
            displayMedium: ThemeData.dark()
                .textTheme
                .displayMedium!
                .copyWith(fontFamily: fontPoppins),
            displaySmall: ThemeData.dark()
                .textTheme
                .displaySmall!
                .copyWith(fontFamily: fontPoppins),
            headlineMedium: ThemeData.dark().textTheme.headlineMedium!.copyWith(
                  color: Colors.white,
                  fontFamily: fontPoppins,
                ),
            headlineSmall: ThemeData.dark().textTheme.headlineSmall!.copyWith(
                fontFamily: fontPoppins,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            titleLarge: ThemeData.dark().textTheme.titleLarge!.copyWith(
                fontFamily: fontPoppins, fontSize: 15, color: appGreen),
            titleMedium: ThemeData.dark().textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontFamily: fontPoppins,
                ),
            titleSmall: ThemeData.dark()
                .textTheme
                .titleSmall!
                .copyWith(fontFamily: fontPoppins, color: Colors.white),
            bodyLarge: ThemeData.light().textTheme.bodyLarge!.copyWith(
                fontFamily: fontPoppins, color: Colors.white, fontSize: 12),
            bodyMedium: ThemeData.light()
                .textTheme
                .titleSmall!
                .copyWith(fontFamily: fontPoppins, color: Colors.white),
            labelLarge: ThemeData.dark()
                .textTheme
                .labelLarge
                ?.copyWith(fontFamily: fontPoppins),
          ),
      primaryTextTheme: ThemeData.dark().primaryTextTheme.copyWith(
            displayLarge: ThemeData.dark()
                .primaryTextTheme
                .displayLarge!
                .copyWith(fontFamily: fontPoppins),
            displayMedium: ThemeData.dark()
                .primaryTextTheme
                .displayMedium!
                .copyWith(fontFamily: fontPoppins),
            displaySmall: ThemeData.dark()
                .primaryTextTheme
                .displaySmall!
                .copyWith(fontFamily: fontPoppins),
            headlineMedium: ThemeData.dark()
                .primaryTextTheme
                .headlineMedium!
                .copyWith(fontFamily: fontPoppins),
            headlineSmall: ThemeData.dark()
                .primaryTextTheme
                .headlineSmall!
                .copyWith(fontFamily: fontPoppins, fontWeight: FontWeight.bold),
            titleLarge: ThemeData.dark()
                .primaryTextTheme
                .titleLarge!
                .copyWith(fontFamily: fontPoppins),
            titleMedium: ThemeData.dark()
                .primaryTextTheme
                .titleMedium!
                .copyWith(fontFamily: fontPoppins),
            titleSmall: ThemeData.dark()
                .primaryTextTheme
                .titleSmall!
                .copyWith(fontFamily: fontPoppins),
            labelLarge: ThemeData.dark()
                .textTheme
                .labelLarge
                ?.copyWith(fontFamily: fontPoppins),
          ),
      inputDecorationTheme: InputDecorationTheme(
        focusColor: appGreen,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        fillColor: const Color.fromRGBO(255, 255, 255, .09),
        filled: true,
        labelStyle: const TextStyle(color: Colors.white),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            textStyle: ThemeData.dark()
                .textTheme
                .titleSmall!
                .copyWith(fontFamily: fontPoppins),
            foregroundColor: appBlue,
            disabledForegroundColor: appBlueDisabled),
      ),
      checkboxTheme: ThemeData.light().checkboxTheme.copyWith(
            fillColor: MaterialStateProperty.resolveWith(getDarkCheckboxColor),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          ),
      cardTheme: ThemeData.light().cardTheme.copyWith(
            color: appBlue,
          ),
      iconTheme: ThemeData.light().iconTheme.copyWith(
            color: Colors.white,
          ));
}
