import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scibot_sample/pages/chat_page.dart';
import 'package:scibot_sample/style/app_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 80,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 80,
                width: 80,
              ),
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [AppColor.primary, AppColor.secondary],
                  ).createShader(bounds);
                },
                child: const Text(
                  "Sci-Bot",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Bungee',
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              color: Colors.black,
              icon: Icon(Icons.settings_outlined),
              onPressed: () {},
            ),
          ],
          automaticallyImplyLeading: false,
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    color: AppColor.green,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 4.0,
                              left: 4.0,
                              top: 4.0,
                              bottom: 4.0,
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Go To...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      ChatHead(message: 'Maayong adlaw!', showIcon: true),
                      SizedBox(height: 8),
                      ChatHead(
                        message:
                            'Welcome to Science Contextualized Instruction through AI-based Chatbot (SCI-bot)!',
                        showIcon: false,
                      ),
                      SizedBox(height: 8),
                      ChatHead(
                        message:
                            'I am your companion for learning Living Things and their Environment 9 Subject',
                        showIcon: false,
                      ),
                      SizedBox(height: 8),
                      ChatHead(
                        message:
                            'So, what lesson are you going to learn today?',
                        showIcon: false,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 85,
        child: BottomAppBar(
          color: AppColor.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: SizedBox(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: GradientIcon(
                          Icons.home_rounded,
                          gradient: LinearGradient(
                            colors: [AppColor.blue, AppColor.blue],
                          ),
                        ),
                        onPressed: () {
                          // Navigate to home page
                        },
                      ),
                      Text(
                        'Home',
                        style: TextStyle(fontSize: 9, color: AppColor.blue),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chat_rounded),
                        color: AppColor.blue,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 400),
                              pageBuilder: (_, __, ___) => ChatAppScaffold(),
                              transitionsBuilder: (_, animation, __, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(-1.0, 0.0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      Text(
                        'Chat',
                        style: TextStyle(fontSize: 9, color: AppColor.blue),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: 80, // Maximum height for the content
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.queue),
                        color: AppColor.blue,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 400),
                              pageBuilder: (_, __, ___) => ChatAppScaffold(),
                              transitionsBuilder: (_, animation, __, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(-1.0, 0.0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      Text(
                        'More',
                        style: TextStyle(fontSize: 9, color: AppColor.blue),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.face_6_sharp),
                        color: AppColor.blue,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 400),
                              pageBuilder: (_, __, ___) => ChatAppScaffold(),
                              transitionsBuilder: (_, animation, __, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(-1.0, 0.0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      Text(
                        'Aristotle',
                        style: TextStyle(fontSize: 9, color: AppColor.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatHead extends StatelessWidget {
  final String message;
  final bool showIcon;

  const ChatHead({Key? key, required this.message, this.showIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showIcon)
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 0),
            child: Image.asset('assets/images/head.png', width: 45, height: 45),
          ),
        SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TypingAnimation(
              message: message,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class TypingAnimation extends StatefulWidget {
  final String message;
  final Duration duration;
  final double fontSize;

  const TypingAnimation({
    Key? key,
    required this.message,
    this.duration = const Duration(milliseconds: 500),
    required this.fontSize,
  }) : super(key: key);

  @override
  _TypingAnimationState createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<TypingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  String _typedMessage = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0, end: widget.message.length.toDouble())
        .animate(_controller)
      ..addListener(() {
        setState(() {
          _typedMessage = widget.message.substring(0, _animation.value.toInt());
        });
      });

    _timer = Timer(widget.duration, () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _typedMessage,
      style: TextStyle(
        fontSize: widget.fontSize,
        fontWeight: FontWeight.bold,
      ),
      maxLines: null,
    );
  }
}
