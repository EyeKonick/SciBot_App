import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:localstorage/localstorage.dart';
import 'package:scibot_sample/pages/home_page.dart';
import 'package:scibot_sample/style/app_color.dart';

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final Gradient gradient;
  final double size;

  const GradientIcon(
    this.icon, {
    Key? key,
    required this.gradient,
    this.size = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return gradient.createShader(bounds);
      },
      child: Icon(
        icon,
        size: size,
        color: Colors.white, // Required, but irrelevant
      ),
    );
  }
}

class ChatAppScaffold extends StatefulWidget {
  final String? _message;

  const ChatAppScaffold({
    super.key,
    String? message = null,
  }) : _message = message;

  @override
  State<ChatAppScaffold> createState() => _ChatAppScaffoldState();
}

class _ChatAppScaffoldState extends State<ChatAppScaffold> {
  @override
  Widget build(BuildContext context) {
    final refreshKey = UniqueKey();

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Color(0x00),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration:
                    Duration(milliseconds: 400), // Set animation duration
                pageBuilder: (_, __, ___) => HomePage(),
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
          icon: Icon(
            Icons.arrow_back,
            color: AppColor.primary,
          ),
        ),
        leadingWidth: 100,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [AppColor.primary, AppColor.secondary],
            ).createShader(bounds);
          },
          child: const Text(
            "Chat with Sci-Bot",
            style: TextStyle(
                color: Colors.white, fontFamily: 'Bungee', fontSize: 16),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // NOTE: This clears the chat history
              localStorage.clear();
              setState(() {});
            },
            icon: const Icon(
              Icons.more_horiz_sharp,
              size: 32,
              color: AppColor.secondary,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ChatApp(
            key: refreshKey,
            message: widget._message,
          ),
        ),
      ),
    );
  }
}

class ChatApp extends StatefulWidget {
  final String? _message;

  const ChatApp({
    super.key,
    String? message = null,
  }) : _message = message;

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  final _messageController = TextEditingController();
  var _session = MessageSession();

  @override
  void initState() {
    super.initState();

    final history = localStorage.getItem("history");

    if (history == null) {
      _session.queueSystemMessage(
        """You are an AI Chatbot assistant of Joecil Villanueva, a grade 9 science teacher, you are very eager to educate students, you must ensure to the best of your capabilities that your answers comply with the science curriculum's Most Essential Learning Competencies (MELCs) defined by the Department of Education in the Philippines.
          You must refuse to answer questions not directly relevant to the topics in the MELCs. Greet your student, make sure to mention your creator Joecil Villanueva. You can answer questions about yourself. Do not mention that you are limited to the topics within the MELCs. List the topics in the MELCs ONLY WHEN ASKED.""",
      );

      if (widget._message != null) {
        _session.queueUserMessage(widget._message!);
      }

      return;
    }

    _session = MessageSession.fromJsonEncrypted(history);

    if (widget._message != null) {
      _session.queueUserMessage(widget._message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: when play() is called, it will return a Stream<String> if the last message in its history does not come from an Assistant
    final possibleResponse = _session.play();

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              ..._session.history.map(
                (record) => Row(
                  mainAxisAlignment: record.role == "User"
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    record.role == "Assistant"
                        ? const Icon(
                            Icons.outlet_sharp,
                            color: AppColor.primary,
                          )
                        : const SizedBox(),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 10,
                      ),
                      constraints: const BoxConstraints(maxWidth: 250),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: record.role == "User"
                            ? AppColor.secondary
                            : AppColor.primary,
                      ),
                      child: Text(
                        record.message,
                      ),
                    ),
                    record.role == "User"
                        ? const Icon(
                            Icons.face,
                            color: AppColor.secondary,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              possibleResponse == null
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.outlet_sharp,
                          color: AppColor.primary,
                        ),
                        StreamBuilder(
                          stream: possibleResponse,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                margin: const EdgeInsets.only(
                                  top: 10,
                                  left: 10,
                                  right: 10,
                                ),
                                constraints:
                                    const BoxConstraints(maxWidth: 275),
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    AppColor.primary,
                                    AppColor.secondary
                                  ]),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SpinKitRing(
                                  color:
                                      const Color.fromARGB(255, 197, 197, 197),
                                  size: 25,
                                  lineWidth: 4,
                                ),
                              );
                            }

                            return Container(
                              margin: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 10,
                              ),
                              constraints: const BoxConstraints(maxWidth: 275),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  AppColor.primary,
                                  AppColor.secondary
                                ]),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepOrange[200],
                              ),
                              child: Text(
                                snapshot.data ?? '',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: AppColor.primary))),
              ),
            ),
            IconButton(
              onPressed: () {
                if (_messageController.text.isEmpty) {
                  return;
                }

                setState(() {
                  _session.queueUserMessage(_messageController.text);
                  _messageController.text = "";
                });
              },
              icon: GradientIcon(
                Icons.send,
                gradient: LinearGradient(
                  colors: [AppColor.primary, AppColor.secondary],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                localStorage.setItem(
                  "history",
                  _session.toJsonEncrypted(),
                );
              },
              icon: GradientIcon(
                Icons.save,
                gradient: LinearGradient(
                    colors: [AppColor.primary, AppColor.secondary]),
              ),
            )
          ],
        ),
      ],
    );
  }
}
