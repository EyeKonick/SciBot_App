import 'package:flutter/material.dart';
import 'package:scibot_sample/pages/chat_page.dart';
import 'package:scibot_sample/pages/home_page.dart';
import 'package:scibot_sample/style/app_color.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.primary,
              AppColor.secondary
            ], 
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/Scibot-logo.png',
                      height: 250,
                      width: 250,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'S',
                            style: TextStyle(
                                color: Colors.yellow), 
                          ),
                          TextSpan(
                            text: 'cience ',
                          ),
                          TextSpan(
                            text: 'C',
                            style: TextStyle(
                                color: Colors.yellow), 
                          ),
                          TextSpan(
                            text: 'ontextualized ',
                          ),
                          TextSpan(
                            text: 'I',
                            style: TextStyle(
                                color: Colors.yellow), 
                          ),
                          TextSpan(
                            text: 'nstruction through AI-Based Chat',
                          ),
                          TextSpan(
                            text: 'bot',
                            style: TextStyle(
                                color: Colors.yellow), 
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Powered by',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      'GPT API',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(
                                  milliseconds: 800),
                              pageBuilder: (_, __, ___) => HomePage(),
                              transitionsBuilder: (_, animation, __, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(-2.0, 0.0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Continue',
                                textAlign: TextAlign.center, // Center the text
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle Terms of Use tap
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'By Proceeding, You accept our \n',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Terms of Use',
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                            ),
                            TextSpan(
                              text: ' and ',
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
