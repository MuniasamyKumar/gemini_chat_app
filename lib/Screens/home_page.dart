import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_chat_app/Controller/themeNotifier.dart';
import 'package:gemini_chat_app/Models/message.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  final List<Message> _messages = [
    // Message(text: "Hi", isUser: true),
    // Message(text: "Hello What's Up ? ", isUser: false),
    // Message(text: "Great and You?", isUser: true),
    // Message(text: "I'm Excellent", isUser: false),
  ];

  bool isLoading = false;

  callGeminiModel() async {
    try {
      if (_controller.text.isNotEmpty) {
        _messages.add(Message(text: _controller.text, isUser: true));
        isLoading = true;
      }
      final prompt = _controller.text.trim();
      _controller.clear();

      FocusScope.of(context).unfocus();

      final model = GenerativeModel(
          model: 'gemini-1.5-flash', apiKey: dotenv.env['GOOGLE_API_KEY']!);

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      print(response.text);

      setState(() {
        _messages.add(Message(text: response.text!, isUser: false));
        isLoading = false;
      });
    } catch (e) {
      print("Error : $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.read(themeProvider);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset("assets/gpt-robot.png"),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Gemini Gpt",
                      style: Theme.of(context).textTheme.titleLarge)
                ],
              ),
              GestureDetector(
                  onTap: () {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                  child: (currentTheme == ThemeMode.dark)
                      ? Icon(
                          Icons.light_mode,
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      : Icon(
                          Icons.dark_mode,
                          color: Theme.of(context).colorScheme.primary,
                        ))
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ListTile(
                    title: Align(
                      alignment: message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: message.isUser
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary,
                              borderRadius: message.isUser
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))
                                  : BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                          child: Text(
                            message.text,
                            style: message.isUser
                                ? Theme.of(context).textTheme.bodyMedium
                                : Theme.of(context).textTheme.bodySmall,
                          )),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 32, top: 16, left: 16, right: 16),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            hintText: "Write your message",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.grey, fontSize: 17),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20)),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    isLoading
                        ? Padding(
                            padding: EdgeInsets.all(16),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GestureDetector(
                              child: Image.asset("assets/send.png"),
                              onTap: () {
                                callGeminiModel();
                              },
                            ),
                          )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
