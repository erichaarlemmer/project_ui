import 'package:flutter/material.dart';
import 'package:project_ui/web/widgets/big_button.dart';

class HomePage extends StatelessWidget {
  final Function(String) onButtonPressed;
  final Function(String) setUsername;
  final Function(String) onCardChanged;
  final String currentUsername;

  const HomePage({
    super.key,
    required this.onButtonPressed,
    required this.currentUsername,
    required this.setUsername,
    required this.onCardChanged,
  });

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Widget loginLogoutBtn;

    if (currentUsername.isEmpty) {
      loginLogoutBtn = BigButton(
        onButtonPressed: () => {onButtonPressed("login")},
        isLeft: true,
        isBottom: false,
        isCircle: false,
        color: Colors.grey,
        children: [
          Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: ((60 / 1080) * screenHeight),
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.login,
            color: Colors.white,
            size: ((60 / 1080) * screenHeight),
          ),
        ],
      );
    } else {
      loginLogoutBtn = BigButton(
        onButtonPressed: () {
          this.setUsername("");
          onButtonPressed("home");
        },
        isLeft: true,
        isBottom: false,
        isCircle: false,
        color: Colors.grey,
        children: [
          Text(
            "Logout",
            style: TextStyle(
              color: Colors.white,
              fontSize: ((60 / 1080) * screenHeight),
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.logout,
            color: Colors.white,
            size: ((60 / 1080) * screenHeight),
          ),
        ],
      );
    }

    return Stack(
      children: [
        BigButton(
          onButtonPressed: () => {onButtonPressed("help")},
          isLeft: true,
          isBottom: true,
          isCircle: true,
          color: Colors.grey,
          children: [
            Padding(
              padding: EdgeInsets.all((20 / 1080) * screenHeight),
              child: Text(
                "?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ((60 / 1080) * screenHeight),
                ),
              ),
            ),
          ],
        ),
        BigButton(
          onButtonPressed: () => {onButtonPressed("plate")},
          isLeft: false,
          isBottom: true,
          isCircle: false,
          color: Colors.green,
          children: [
            Text(
              "Start",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((60 / 1080) * screenHeight),
              ),
            ),
            SizedBox(width: 20),
            Icon(
              Icons.payment_outlined,
              color: Colors.white,
              size: ((60 / 1080) * screenHeight),
            ),
          ],
        ),

        loginLogoutBtn,

        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Welcome $currentUsername",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ((120 / 1080) * screenHeight),
                ),
              ),
              SizedBox(height: (40 / 1080) * screenHeight),
              Container(
                width: 400,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black26),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter card number',
                    icon: Icon(Icons.credit_card),
                  ),
                  onChanged: onCardChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
