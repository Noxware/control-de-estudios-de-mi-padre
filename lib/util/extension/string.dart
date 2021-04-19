import 'package:url_launcher/url_launcher.dart';

extension StringExtension on String {
  Future<void> google() {
    final uri = Uri(
        scheme: 'https',
        host: 'www.google.com',
        path: 'search',
        queryParameters: {
          'q': this,
        });

    return launch(uri.toString());
  }
}
