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
        color: Colors.white,
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
                transitionDuration: Duration(milliseconds: 400),
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
              // TODO: Clear history of current selected topic instead of everything
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
  final _scrollController = ScrollController();

  MessageSession _session = MessageSession();
  Topic? _topic = null;

  @override
  void initState() {
    super.initState();
    final topic = localStorage.getItem("topic");

    if (topic == null) {
      _session.queueSystemMessage(
        """You are an AI Chatbot assistant of Joecil Villanueva, a grade 9 science teacher, you are very eager to educate students, you must ensure to the best of your capabilities that your answers comply with the science curriculum's Most Essential Learning Competencies (MELCs) defined by the Department of Education in the Philippines.
          You must refuse to answer questions not directly relevant to the topics in the MELCs. Greet your student, make sure to mention your creator Joecil Villanueva. You can answer questions about yourself. Do not mention that you are limited to the topics within the MELCs. List the topics in the MELCs ONLY WHEN ASKED.""",
      );

      if (widget._message != null) {
        _session.queueUserMessage(widget._message!);
      }

      return;
    }

    final history = localStorage.getItem("history-" + topic);

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

    _topic = topicFromString(topic);
    _session = MessageSession.fromJsonEncrypted(history);

    if (widget._message != null) {
      _session.queueUserMessage(widget._message!);
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.bounceIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_topic == null) {
      // TODO: Display initial page
    } else {
      final history =
          localStorage.getItem("history-" + topicToSnakeCase(_topic!));

      debugPrint("history-" + topicToSnakeCase(_topic!));
      debugPrint(history);

      if (history == null) {
        _session.queueSystemMessage(
          """You are an AI Chatbot assistant of Joecil Villanueva, a grade 9 science teacher, you are very eager to educate students, you must ensure to the best of your capabilities that your answers comply with the science curriculum's Most Essential Learning Competencies (MELCs) defined by the Department of Education in the Philippines.
          You must refuse to answer questions not directly relevant to the topics in the MELCs. Greet your student, make sure to mention your creator Joecil Villanueva. You can answer questions about yourself. Do not mention that you are limited to the topics within the MELCs. List the topics in the MELCs ONLY WHEN ASKED.""",
        );
      } else {
        _session = MessageSession.fromJsonEncrypted(history);
      }
    }

    // NOTE: when play() is called, it will return a Stream<String> if the last message in its history does not come from an Assistant
    final possibleResponse = _session.play();

    if (possibleResponse != null) {
      possibleResponse.listen(null, onDone: _saveHistory);
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView(
                controller: _scrollController,
                children: [
                  const SizedBox(height: 35),
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
                                      color: const Color.fromARGB(
                                          255, 197, 197, 197),
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
                                  constraints:
                                      const BoxConstraints(maxWidth: 275),
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
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  child: Text(_topic == null
                      ? "(Select a topic)"
                      : "Topic: ${topicToString(_topic!)}"),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    _saveHistory();

                    setState(() {
                      _topic = Topic.biodiversity;
                    });
                  },
                  child: Text("Biodiversity"),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    _saveHistory();

                    setState(() {
                      _topic = Topic.heredityAndVariation;
                    });
                  },
                  child: Text("Heredity and Variation"),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    _saveHistory();
                    debugPrint(topicToSnakeCase(_topic!));

                    setState(() {
                      _topic = Topic.circulationAndGasExchange;
                    });
                  },
                  child: Text("Circulation and Gas Exchange"),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    _saveHistory();

                    setState(() {
                      _topic = Topic.photosynthesis;
                    });
                  },
                  child: Text("Photosynthesis"),
                ),
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

                _saveHistory();
              },
              icon: GradientIcon(
                Icons.send,
                gradient: LinearGradient(
                  colors: [AppColor.primary, AppColor.secondary],
                ),
              ),
            ),
            // NOTE: Not needed anymore
            // IconButton(
            //   onPressed: _saveHistory,
            //   icon: GradientIcon(
            //     Icons.save,
            //     gradient: LinearGradient(
            //         colors: [AppColor.primary, AppColor.secondary]),
            //   ),
            // )
          ],
        ),
      ],
    );
  }

  void _saveHistory() {
    if (_topic != null) {
      localStorage.setItem(
        "history-" + topicToSnakeCase(_topic!),
        _session.toJsonEncrypted(),
      );
      localStorage.setItem("topic", topicToString(_topic!));
    }
  }
}

enum Topic {
  biodiversity,
  heredityAndVariation,
  circulationAndGasExchange,
  photosynthesis,
}

String topicToString(Topic topic) {
  switch (topic) {
    case Topic.biodiversity:
      return "Biodiversity";
    case Topic.heredityAndVariation:
      return "Heredity and Variation";
    case Topic.circulationAndGasExchange:
      return "Circulation and Gas Exchange";
    case Topic.photosynthesis:
      return "Photosynthesis";
  }
}

String topicToSnakeCase(Topic topic) {
  switch (topic) {
    case Topic.biodiversity:
      return "biodiversity";
    case Topic.heredityAndVariation:
      return "heredity-and-variation";
    case Topic.circulationAndGasExchange:
      return "circulation-and-gas-exchange";
    case Topic.photosynthesis:
      return "photosynthesis";
  }
}

Topic topicFromString(String topic) {
  switch (topic) {
    case "Biodiversity":
      return Topic.biodiversity;
    case "Heredity and Variation":
      return Topic.heredityAndVariation;
    case "Circulation and Gas Exchange":
      return Topic.circulationAndGasExchange;
    case "Photosynthesis":
      return Topic.photosynthesis;
    default:
      throw Exception("Invalid topic: $topic");
  }
}
