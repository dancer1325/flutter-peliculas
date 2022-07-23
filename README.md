# peliculas

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How to compile?
* `flutter pub get`
    * Get the dependencies listed in the 'pubspec.yaml'

## How to run?
* Via IDE
    * Android Studio
        * Select the Flutter Device and 'main.dart'
        * Click in run button
* Via terminal
    * `flutter run lib/main.dart`
        * 'lib/main.dart' depends on the relative path between your current terminal and the 'main.dart' file
    
## How has the project created?
* Alternatives
    * Command line
        * `flutter create NameOfTheProject`
    * IDE
        * File > New > New Flutter Project
    
## Note
* Warnings
    * Warning1: 'Warning: Operand of null-aware operation '!' has type 'SchedulerBinding'/'WidgetsBinding'/ which excludes null'
        * https://stackoverflow.com/questions/72210806/warning-operand-of-null-aware-operation-has-type-schedulerbinding-which-e
* Structure
    * Each folder contains specific file to export all the rest of files
