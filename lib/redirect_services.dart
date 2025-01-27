import 'package:url_launcher/url_launcher.dart';

Future<bool> redirectToLink(String url) async {
  bool canLaunch = await canLaunchUrl(Uri.parse(url));
  if (canLaunch) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    return true;
  } else {
    return false;
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Could not open link: $url')),
    // );
  }
}
