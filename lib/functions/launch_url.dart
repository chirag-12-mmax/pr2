// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlServiceFunction(
    {required String url, required BuildContext context}) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}
