import 'package:flutter/material.dart';
import 'package:scibot_sample/pages/chat_page.dart';
import 'package:scibot_sample/style/app_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _DropDownvalue1 =
      'How do the respiratory and circulatory systems work together?'; // Initial dropdown value
  var _items1 = [
    'How do the respiratory and circulatory systems work together?',
    'What role does oxygen play in nutrient and gas transport?',
    'How does the blood carry nutrients to different body parts?',
    'Why is gas exchange important for the body?',
    "What happens when there's a disruption in either the respiratory or circulatory system?"
  ];

  String _DropDownvalue2 =
      'How does smoking affect breathing and blood flow?'; // Initial dropdown value
  var _items2 = [
    'How does smoking affect breathing and blood flow?',
    'Can exercise improve lung and heart health?',
    'Does diet impact breathing and blood circulation?',
    "What's the link between stress and respiratory/circulatory health?",
    "How does air pollution harm our breathing and blood circulation?"
  ]; // Dropdown items

  String _DropDownvalue3 =
      'What are the alternative inheritance patterns beyond Mendelian genetics?'; // Initial dropdown value
  var _items3 = [
    'What are the alternative inheritance patterns beyond Mendelian genetics?',
    'How do traits exhibit incomplete dominance in non-Mendelian inheritance?',
    'What role do multiple alleles play in non-Mendelian inheritance patterns?',
    "Can you explain how codominance operates in non-Mendelian inheritance?",
    "How do sex-linked traits demonstrate non-Mendelian inheritance patterns?"
  ];

  String _DropDownvalue4 =
      'How does environmental change drive species extinction?'; // Initial dropdown value
  var _items4 = [
    'How does environmental change drive species extinction?',
    'Can rapid environment shifts lead to population decline and extinction?',
    'Why is genetic diversity crucial for adapting to abrupt changes?',
    "How do human actions worsen species' adaptation challenges?",
    "Are there clear cases of extinction due to slow adaptation?"
  ];

  String _DropDownvalue5 =
      'How do photosynthesis and respiration differ?'; // Initial dropdown value
  var _items5 = [
    'How do photosynthesis and respiration differ?',
    'Why is photosynthesis anabolic and respiration catabolic?',
    'What are the main products and reactants of each process?',
    "Why is photosynthesis important for oxygen production and ecosystem balance?",
    "How does respiration contribute to energy release in both plants and animals?"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 32,
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [AppColor.primary, AppColor.secondary],
            ).createShader(bounds);
          },
          child: const Text(
            "Welcome to Sci-Bot",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Bungee',
              fontSize: 16,
            ),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Text(
                  '''             Hello there! Welcome to our educational app. I'm your AI Chatbot assistant, created by Joecil Villanueva, a grade 9 science teacher. My primary goal is to help you learn and understand various science topics covered in the Most Essential Learning Competencies (MELCs) defined by the Department of Education in the Philippines.
      
      In this app, you can ask me questions related to the science curriculum, and I'll do my best to provide you with accurate and helpful answers. However, it's important to note that my responses are based on the topics within the MELCs, and I'm unable to provide information on subjects outside of that scope.
      
      If you have any questions about specific science topics, feel free to ask, and I'll be happy to assist you. Let's embark on this learning journey together!
                  ''',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 3.0,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColor.primary,
                        AppColor.secondary
                      ], // Updated colors to built-in ones
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    'Provided Topics with Sample questions:',
                    style: TextStyle(fontFamily: 'Bungee'),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white, // Choose your desired color
                      width: 1.0, // Adjust the width of the bottom outline
                    ),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Respiratory-Circulatory Interaction in Nutrient & Gas Transport',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AnimatedContainer(
                      color: Colors.transparent,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(16),
                      duration: Duration(milliseconds: 300),
                      height: _DropDownvalue1 == null ? 56 : null,
                      curve: Curves.easeInOut,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          dropdownColor: AppColor.background2,
                          value: _DropDownvalue1,
                          items: _items1.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 12,
                                ), // Adjust font size here
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _DropDownvalue1 = newValue!;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconSize: 20,
                          style: TextStyle(color: Colors.white),
                          underline: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white, // Choose your desired color
                      width: 1.0, // Adjust the width of the bottom outline
                    ),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lifestyle Impact on Respiratory and Circulatory Systems',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AnimatedContainer(
                      color: Colors.transparent,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(16),
                      duration: Duration(milliseconds: 300),
                      height: _DropDownvalue2 == null ? 56 : null,
                      curve: Curves.easeInOut,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          dropdownColor: AppColor.background2,
                          value: _DropDownvalue2,
                          items: _items2.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 12,
                                ), // Adjust font size here
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _DropDownvalue2 = newValue!;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconSize: 20,
                          style: TextStyle(color: Colors.white),
                          underline: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white, // Choose your desired color
                      width: 1.0, // Adjust the width of the bottom outline
                    ),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patterns of Non-Mendelian Inheritance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AnimatedContainer(
                      color: Colors.transparent,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(16),
                      duration: Duration(milliseconds: 300),
                      height: _DropDownvalue3 == null ? 56 : null,
                      curve: Curves.easeInOut,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          dropdownColor: AppColor.background2,
                          value: _DropDownvalue3,
                          items: _items3.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 12,
                                ), // Adjust font size here
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _DropDownvalue3 = newValue!;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconSize: 20,
                          style: TextStyle(color: Colors.white),
                          underline: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white, // Choose your desired color
                      width: 1.0, // Adjust the width of the bottom outline
                    ),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Extinction & Environmental Change',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AnimatedContainer(
                      color: Colors.transparent,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(16),
                      duration: Duration(milliseconds: 300),
                      height: _DropDownvalue4 == null ? 56 : null,
                      curve: Curves.easeInOut,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          dropdownColor: AppColor.background2,
                          value: _DropDownvalue4,
                          items: _items4.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 12,
                                ), // Adjust font size here
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _DropDownvalue4 = newValue!;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconSize: 20,
                          style: TextStyle(color: Colors.white),
                          underline: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white, // Choose your desired color
                      width: 1.0, // Adjust the width of the bottom outline
                    ),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Photosynthesis vs. Respiration: Features & Importance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AnimatedContainer(
                      color: Colors.transparent,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(16),
                      duration: Duration(milliseconds: 300),
                      height: _DropDownvalue5 == null ? 56 : null,
                      curve: Curves.easeInOut,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          dropdownColor: AppColor.background2,
                          value: _DropDownvalue5,
                          items: _items5.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 12,
                                ), // Adjust font size here
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _DropDownvalue5 = newValue!;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconSize: 20,
                          style: TextStyle(color: Colors.white),
                          underline: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: BottomAppBar(
          color: AppColor.background2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(
                child: SizedBox(
                  height: 80, // Maximum height for the content
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: GradientIcon(
                          Icons.home_rounded,
                          gradient: LinearGradient(
                            colors: [AppColor.primary, AppColor.secondary],
                          ),
                        ),
                        onPressed: () {
                          // Navigate to home page
                        },
                      ),
                      Text(
                        'Home',
                        style: TextStyle(fontSize: 9, color: Colors.white),
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
                        icon: Icon(Icons.chat_rounded),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(
                                  milliseconds: 400), // Set animation duration
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
                        style: TextStyle(fontSize: 9, color: Colors.white),
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
