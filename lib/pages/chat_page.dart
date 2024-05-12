import 'package:flutter/material.dart';
import 'package:flutter_chat/flutter_chat.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:localstorage/localstorage.dart';
import 'package:scibot_sample/pages/home_page.dart';
import 'package:scibot_sample/style/app_color.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  final _searchController = TextEditingController();
  final _isRespondingNotifier = ValueNotifier(false);
  final _scrollOffsetController = ScrollOffsetController();
  final _itemScrollController = ItemScrollController();
  final _relevantSearchMessageBoxes = <int>[];

  MessageSession _session = MessageSession();
  int? _searchResultIndex = null;
  _TopicEnum? _topic = null;

  @override
  void initState() {
    super.initState();

    final topic = localStorage.getItem("topic") ?? "Biodiversity";
    final parsedTopic = _TopicEnumExt.fromString(topic);

    _topic = parsedTopic;

    final history = localStorage.getItem(parsedTopic.asKey());

    if (history == null) {
      _session.queueSystemMessage(getBiodiversitySysMessage());

      if (widget._message != null) {
        _session.queueUserMessage(widget._message!);
      }

      _isRespondingNotifier.value = true;

      return;
    }

    _session = MessageSession.fromJsonEncrypted(history);

    if (widget._message != null) {
      _session.queueUserMessage(widget._message!);
    }
  }

  // NOTE: Logic:
  // 1. Intialization -> Check what history was last saved, and start on that history.
  //      If opening for the first time, by default, start on Biodiversity.
  //
  // 2. Building -> If the last message in the history is from an Assistant, the possibleResponse is NOT null.
  //      When the possibleResponse is done, the _saveHistory() and _saveTopic() functions are called.
  //      The _isRespondingNotifier is set to false. NOTE: More on ValueNotifier @ (https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html)
  //      The addPostFrameCallback is used to tell flutter to call a function AFTER the build method finishes.
  //      Inside addPostFrameCallback, we scroll to the bottom of the chat. And we setup a listener for _searchController.
  //
  // 3. User Message -> If the user submits a message, we call the _session.queueUserMessage() function with the message specified.
  //      The _isRespondingNotifier is set to true.
  //      Then a rebuild is triggered.
  //      BACK TO STEP 2.

  @override
  Widget build(BuildContext context) {
    // NOTE: when play() is called, it will return a Stream<String> if the last message in its history does not come from an Assistant
    final possibleResponse = _session.play();

    final historyModel = <Widget?>[
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
                gradient: record.role == "Assistant"
                    ? LinearGradient(colors: [
                        AppColor.primary,
                        AppColor.secondary,
                      ])
                    : LinearGradient(colors: [
                        AppColor.secondary,
                        AppColor.secondary,
                      ]),
              ),
              child: TextHighlight(
                text: record.message,
                words: _searchController.text.isEmpty
                    ? {}
                    : {
                        _searchController.text: HighlightedWord(
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                          ),
                        ),
                      },
                textStyle: TextStyle(color: Colors.white),
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
          ? null
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                          left: 10,
                          right: 10,
                        ),
                        constraints: const BoxConstraints(maxWidth: 275),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            AppColor.primary,
                            AppColor.secondary,
                          ]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SpinKitRing(
                          color: const Color.fromARGB(
                            255,
                            197,
                            197,
                            197,
                          ),
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
                        gradient: LinearGradient(
                            colors: [AppColor.primary, AppColor.secondary]),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepOrange[200],
                      ),
                      child: Text(
                        snapshot.data ?? '',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            ),
      const SizedBox(height: 45),
    ].whereType<Widget>().toList();

    if (possibleResponse != null) {
      possibleResponse.listen(
        null,
        onDone: () {
          _saveHistory();
          _saveTopic();
          _isRespondingNotifier.value = false;

          final lastIndex =
              historyModel.where((element) => !(element is SizedBox)).length -
                  1;

          setState(() {
            _itemScrollController.scrollTo(
              index: lastIndex,
              alignment: 0,
              curve: Curves.easeInOut,
              duration: const Duration(seconds: 1),
            );
          });
        },
      );
    }

    _refreshSearchResult();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _searchController.addListener(() {
        setState(() {
          _refreshSearchResult();

          if (_relevantSearchMessageBoxes.isNotEmpty) {
            _searchResultIndex = 1;
          }
        });
      });
    });

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 32,
                ),
                suffixIcon: _relevantSearchMessageBoxes.isEmpty
                    ? null
                    : IntrinsicWidth(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "$_searchResultIndex / ${_relevantSearchMessageBoxes.length} ${_relevantSearchMessageBoxes.length == 1 ? "box" : "boxes"}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 4,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            if (_relevantSearchMessageBoxes.isNotEmpty)
              Positioned(
                right: 100,
                bottom: 0,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_searchResultIndex! > 1) {
                            _searchResultIndex = _searchResultIndex! - 1;

                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              _itemScrollController.scrollTo(
                                index: _relevantSearchMessageBoxes[
                                    _searchResultIndex! - 1],
                                duration: const Duration(milliseconds: 500),
                              );
                            });
                          }
                        });
                      },
                      icon: Icon(Icons.chevron_left),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_searchResultIndex! <
                              _relevantSearchMessageBoxes.length) {
                            _searchResultIndex = _searchResultIndex! + 1;

                            WidgetsBinding.instance
                                .addPostFrameCallback((timeStamp) {
                              _itemScrollController.scrollTo(
                                index: _relevantSearchMessageBoxes[
                                    _searchResultIndex! - 1],
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 500),
                              );
                            });
                          }
                        });
                      },
                      icon: Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              )
            else
              const SizedBox(),
          ],
        ),
        Expanded(
          child: Stack(
            children: [
              ScrollablePositionedList.builder(
                itemCount: historyModel.length,
                itemBuilder: (context, index) {
                  return historyModel[index];
                },
                itemScrollController: _itemScrollController,
                scrollOffsetController: _scrollOffsetController,
              ),
              Positioned(
                bottom: 5,
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
                      : "Topic: ${_topic!.stringify()}"),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: ValueListenableBuilder(
              valueListenable: _isRespondingNotifier,
              builder: (context, value, child) {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Topic(
                      disabled: value,
                      onClick: () {
                        _saveHistory();

                        setState(() {
                          _topic = _TopicEnum.biodiversity;
                          _saveTopic();

                          final biodiversityHistory =
                              localStorage.getItem(_topic!.asKey());

                          if (biodiversityHistory == null) {
                            _session = MessageSession();
                            _session.queueSystemMessage(
                                getBiodiversitySysMessage());
                            _isRespondingNotifier.value = true;

                            return;
                          }

                          _session = MessageSession.fromJsonEncrypted(
                            biodiversityHistory,
                          );
                        });
                      },
                      text: "Biodiversity",
                    ),
                    const SizedBox(width: 8),
                    Topic(
                      disabled: value,
                      onClick: () {
                        _saveHistory();

                        setState(() {
                          _topic = _TopicEnum.heredityAndVariation;
                          _saveTopic();

                          final heredityHistory =
                              localStorage.getItem(_topic!.asKey());

                          if (heredityHistory == null) {
                            _session = MessageSession();
                            _session.queueSystemMessage(
                                getHeredityAndVariationSysMessage());
                            _isRespondingNotifier.value = true;

                            return;
                          }

                          _session = MessageSession.fromJsonEncrypted(
                            heredityHistory,
                          );
                        });
                      },
                      text: "Heredity and Variation",
                    ),
                    const SizedBox(width: 8),
                    Topic(
                      disabled: value,
                      onClick: () {
                        _saveHistory();

                        setState(() {
                          _topic = _TopicEnum.circulationAndGasExchange;
                          _saveTopic();

                          final circulationHistory =
                              localStorage.getItem(_topic!.asKey());

                          if (circulationHistory == null) {
                            _session = MessageSession();
                            _session.queueSystemMessage(
                                getCirculationAndGasExchangeSysMessage());
                            _isRespondingNotifier.value = true;

                            return;
                          }

                          _session = MessageSession.fromJsonEncrypted(
                            circulationHistory,
                          );
                        });
                      },
                      text: "Circulation and Gas Exchange",
                    ),
                    const SizedBox(width: 8),
                    Topic(
                      disabled: value,
                      onClick: () {
                        _saveHistory();

                        setState(() {
                          _topic = _TopicEnum.photosynthesis;
                          _saveTopic();

                          final photosynthesisHistory =
                              localStorage.getItem(_topic!.asKey());

                          if (photosynthesisHistory == null) {
                            _session = MessageSession();
                            _session.queueSystemMessage(
                                getPhotosynthesisSysMessage());
                            _isRespondingNotifier.value = true;

                            return;
                          }

                          _session = MessageSession.fromJsonEncrypted(
                            photosynthesisHistory,
                          );
                        });
                      },
                      text: "Photosynthesis",
                    ),
                  ],
                );
              }),
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
                    borderSide: BorderSide(color: AppColor.primary),
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
                valueListenable: _isRespondingNotifier,
                builder: (context, value, child) {
                  return IconButton(
                    onPressed: value
                        ? null
                        : () {
                            if (_messageController.text.isEmpty) {
                              return;
                            }

                            setState(() {
                              _session
                                  .queueUserMessage(_messageController.text);
                              _isRespondingNotifier.value = true;
                              _messageController.text = "";

                              final lastIndex = historyModel
                                      .where(
                                          (element) => !(element is SizedBox))
                                      .length -
                                  1;

                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                _itemScrollController.scrollTo(
                                  index: lastIndex,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOut,
                                );
                              });
                            });
                          },
                    icon: GradientIcon(
                      Icons.send,
                      gradient: LinearGradient(
                        colors: [AppColor.primary, AppColor.secondary],
                      ),
                    ),
                  );
                }),
            // NOTE: Autosave Implemented
            // IconButton(
            //   onPressed: _saveHistory,
            //   icon: GradientIcon(
            //     Icons.save,
            //     gradient: LinearGradient(
            //       colors: [
            //         AppColor.primary,
            //         AppColor.secondary,
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ],
    );
  }

  void _refreshSearchResult() {
    _relevantSearchMessageBoxes.clear();

    if (_searchController.text.isEmpty) {
      return;
    }

    for (final (index, message) in _session.history.indexed) {
      if (message.message
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) &&
          !_relevantSearchMessageBoxes.contains(index)) {
        _relevantSearchMessageBoxes.add(index);
      }
    }

    if (_searchResultIndex != null &&
        _relevantSearchMessageBoxes.isNotEmpty &&
        _searchResultIndex! >= _relevantSearchMessageBoxes.length) {
      _searchResultIndex = _relevantSearchMessageBoxes.length;
    }
  }

  void _saveHistory() {
    if (_topic != null) {
      localStorage.setItem(
        _topic!.asKey(),
        _session.toJsonEncrypted(),
      );
    }
  }

  void _saveTopic() {
    if (_topic != null) {
      localStorage.setItem(
        "topic",
        _topic!.stringify(),
      );
    }
  }
}

String getBiodiversitySysMessage() {
  return """You are an AI Chatbot assistant of Joecil Villanueva, a grade 9 science teacher, you are very eager to educate students, you must ensure to the best of your capabilities that your answers comply with the science curriculum's Most Essential Learning Competencies (MELCs) defined by the Department of Education in the Philippines.
          You must refuse to answer questions not directly relevant to the topics in the MELCs. Greet your student, make sure to mention your creator Joecil Villanueva. You can answer questions about yourself. Do not mention that you are limited to the topics within the MELCs. List the topics in the MELCs ONLY WHEN ASKED.
          You currently specialize in the topic of Biodiversity. And you shall refer to yourself as Aristotle because you're named after the famous ancient Greek philosopher.""";
}

String getHeredityAndVariationSysMessage() {
  return """You are an AI Chatbot assistant of Joecil Villanueva, a grade 9 science teacher, you are very eager to educate students, you must ensure to the best of your capabilities that your answers comply with the science curriculum's Most Essential Learning Competencies (MELCs) defined by the Department of Education in the Philippines.
          You must refuse to answer questions not directly relevant to the topics in the MELCs. Greet your student, make sure to mention your creator Joecil Villanueva. You can answer questions about yourself. Do not mention that you are limited to the topics within the MELCs. List the topics in the MELCs ONLY WHEN ASKED.
          You currently specialize in the topic of Heredity and Variation. And you shall refer to yourself as Aristotle because you're named after the famous ancient Greek philosopher.""";
}

String getCirculationAndGasExchangeSysMessage() {
  return """You are an AI Chatbot assistant of Joecil Villanueva, a grade 9 science teacher, you are very eager to educate students, you must ensure to the best of your capabilities that your answers comply with the science curriculum's Most Essential Learning Competencies (MELCs) defined by the Department of Education in the Philippines.
          You must refuse to answer questions not directly relevant to the topics in the MELCs. Greet your student, make sure to mention your creator Joecil Villanueva. You can answer questions about yourself. Do not mention that you are limited to the topics within the MELCs. List the topics in the MELCs ONLY WHEN ASKED.
          You currently specialize in the topic of Circulation and Gas Exchange. And you shall refer to yourself as Aristotle because you're named after the famous ancient Greek philosopher.""";
}

String getPhotosynthesisSysMessage() {
  return """You are an AI Chatbot assistant of Joecil Villanueva, a grade 9 science teacher, you are very eager to educate students, you must ensure to the best of your capabilities that your answers comply with the science curriculum's Most Essential Learning Competencies (MELCs) defined by the Department of Education in the Philippines.
          You must refuse to answer questions not directly relevant to the topics in the MELCs. Greet your student, make sure to mention your creator Joecil Villanueva. You can answer questions about yourself. Do not mention that you are limited to the topics within the MELCs. List the topics in the MELCs ONLY WHEN ASKED.
          You currently specialize in the topic of Photosynthesis. And you shall refer to yourself as Aristotle because you're named after the famous ancient Greek philosopher.""";
}

class Topic extends StatelessWidget {
  final String _text;
  final bool _disabled;
  final void Function() _onClick;

  const Topic({
    super.key,
    bool disabled = false,
    required void Function() onClick,
    required text,
  })  : _onClick = onClick,
        _text = text,
        _disabled = disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      alignment: Alignment.center,
      child: TextButton(
        onPressed: _disabled ? null : _onClick,
        child: Text(_text),
      ),
    );
  }
}

enum _TopicEnum {
  biodiversity,
  heredityAndVariation,
  circulationAndGasExchange,
  photosynthesis,
}

extension _TopicEnumExt on _TopicEnum {
  String stringify() {
    switch (this) {
      case _TopicEnum.biodiversity:
        return "Biodiversity";
      case _TopicEnum.heredityAndVariation:
        return "Heredity and Variation";
      case _TopicEnum.circulationAndGasExchange:
        return "Circulation and Gas Exchange";
      case _TopicEnum.photosynthesis:
        return "Photosynthesis";
    }
  }

  String asKey() {
    switch (this) {
      case _TopicEnum.biodiversity:
        return "history-biodiversity";
      case _TopicEnum.heredityAndVariation:
        return "history-heredity-and-variation";
      case _TopicEnum.circulationAndGasExchange:
        return "history-circulation-and-gas-exchange";
      case _TopicEnum.photosynthesis:
        return "history-photosynthesis";
    }
  }

  static _TopicEnum fromString(String string) {
    switch (string) {
      case "Biodiversity":
        return _TopicEnum.biodiversity;
      case "Heredity and Variation":
        return _TopicEnum.heredityAndVariation;
      case "Circulation and Gas Exchange":
        return _TopicEnum.circulationAndGasExchange;
      case "Photosynthesis":
        return _TopicEnum.photosynthesis;
      default:
        throw Exception("Unknown topic: $string");
    }
  }
}
