import 'package:flutter/material.dart';
import 'package:project_ui/web/utils/config_web.dart';
import 'package:project_ui/web/widgets/big_button.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  final Function(String) onNavButtonPressed;
  final String clienId;

  const LoginPage({
    super.key,
    required this.onNavButtonPressed,
    required this.clienId,
  });

  void _openLoginUrl() async {
    final url = Uri.parse('$httpServerAddress/auth/login/$clienId');
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        webOnlyWindowName: '_blank', // This opens in a new tab
      );
    } else {
      // Handle error
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        BigButton(
          onButtonPressed: () => onNavButtonPressed("home"),
          isLeft: true,
          isBottom: true,
          isCircle: false,
          color: Colors.red,
          children: [
            Icon(Icons.arrow_back, color: Colors.white, size: ((100 / 1080) * screenHeight)),
            const SizedBox(width: 16),
            Text(
              "Back",
              style: TextStyle(color: Colors.white, fontSize: ((100 / 1080) * screenHeight)),
            ),
          ],
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Click below to log in:',
                style: TextStyle(
                  fontSize: ((84 / 1080) * screenHeight),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ((40 / 1080) * screenHeight)),
              ElevatedButton.icon(
                onPressed: _openLoginUrl,
                icon: Icon(Icons.open_in_new),
                label: Text("Open Login Page"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: TextStyle(fontSize: ((64 / 1080) * screenHeight)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
