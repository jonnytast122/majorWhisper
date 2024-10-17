import 'dart:async';
import 'dart:convert'; // For JSON encoding and decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'RouteHosting.dart';

class Chatbot extends StatefulWidget {
  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  String fullMessage = "How may I help you?";
  String displayedMessage = "";
  int charIndex = 0;
  late Timer _timer;
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = []; // Stores conversation history
  bool isTyping = false; // Flag to show typing indicator

  @override
  void initState() {
    super.initState();
    _startTypingEffect();
  }

  void _startTypingEffect() {
    _timer = Timer.periodic(Duration(milliseconds: 0), (timer) {
      setState(() {
        if (charIndex < fullMessage.length) {
          displayedMessage += fullMessage[charIndex];
          charIndex++;
        } else {
          messages.add({"sender": "bot", "text": fullMessage});
          _timer.cancel();
        }
      });
    });
  }

  // Sends user input to the API and handles the response
  Future<void> _sendMessage(String message) async {
    setState(() {
      messages.add({"sender": "user", "text": message}); // Add user message
      displayedMessage = ''; // Reset for new message typing effect
      isTyping = true; // Show typing indicator
      messages.add(
          {"sender": "bot", "text": "typing"}); // Temporary typing indicator
    });
    _controller.clear(); // Clear the input field

    // Make the API call
    try {
      var response = await http.post(
        Uri.parse('${RouteHosting.baseUrl}/chatbot'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"questioning": message}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        fullMessage = data["answer"]; // Get the answer from the API response
      } else {
        fullMessage = "Sorry, something went wrong. Please try again.";
      }
    } catch (e) {
      fullMessage = "Failed to connect to the server. Please try again later.";
    }

    // After getting the API response, remove the typing indicator
    setState(() {
      isTyping = false;
      messages.removeLast(); // Remove the "typing" message
      charIndex = 0;
      _startTypingEffect(); // Start typing effect for the response
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose(); // Dispose the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildAppBar(screenWidth, screenHeight),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(
                            messages[index], screenWidth, screenHeight);
                      },
                    ),
                  ),
                ),
              ],
            ),
            _buildMessageInputField(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(double screenWidth, double screenHeight) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01,
            horizontal: screenWidth * 0.08,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF006FFD),
                radius: screenWidth * 0.08,
                child: Image.asset(
                  'assets/images/Ai_vector.png',
                  width: screenWidth * 0.12,
                  height: screenWidth * 0.12,
                ),
              ),
              SizedBox(width: screenWidth * 0.05),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MajorMentor",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.05,
                      fontFamily: "Inter-medium",
                    ),
                  ),
                  Text(
                    "Active Now",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 164, 164, 164),
                      fontSize: screenWidth * 0.035,
                      fontFamily: "Inter-regular",
                    ),
                  ),
                ],
              ),
              Spacer(),
              Image.asset(
                'assets/images/Active_vector.png',
                width: screenWidth * 0.12,
                height: screenWidth * 0.12,
              ),
            ],
          ),
        ),
        Divider(
          color: const Color.fromARGB(255, 236, 236, 236),
          height: 1.0,
          thickness: 1.0,
        ),
      ],
    );
  }

  Widget _buildMessageBubble(
      Map<String, String> message, double screenWidth, double screenHeight) {
    bool isUser = message["sender"] == "user";
    bool isTypingMessage = message["text"] == "typing"; // Detect typing message
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.01,
        horizontal: screenWidth * 0.04,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              backgroundColor: Color(0xFF006FFD),
              radius: screenWidth * 0.06,
              child: Image.asset(
                'assets/images/Ai_vector.png',
                width: screenWidth * 0.07,
                height: screenWidth * 0.07,
              ),
            ),
          SizedBox(width: screenWidth * 0.03),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                color: isUser
                    ? Colors.grey[300]
                    : isTypingMessage
                        ? Colors.transparent
                        : Color(0xFF006FFD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.04),
                  topRight: Radius.circular(screenWidth * 0.04),
                  bottomLeft: isUser
                      ? Radius.circular(screenWidth * 0.04)
                      : Radius.zero,
                  bottomRight: isUser
                      ? Radius.zero
                      : Radius.circular(screenWidth * 0.04),
                ),
              ),
              child: isTypingMessage
                  ? Transform.translate(
                      offset: Offset(0,
                          -10), // Adjust the second value (Y-axis) to move up
                      child: Lottie.asset(
                        'assets/icon/chat_typing.json', // Lottie animation
                        width: 50,
                        height: 50,
                      ),
                    )
                  : Text(
                      message["text"]!,
                      style: TextStyle(
                        color: isUser ? Colors.black : Colors.white,
                        fontSize: screenWidth * 0.04,
                        fontFamily: 'Inter-regular',
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInputField(double screenWidth, double screenHeight) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: TextFormField(
          controller: _controller,
          onFieldSubmitted: _sendMessage,
          decoration: InputDecoration(
            hintText: "Message MajorWhisper",
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: screenWidth * 0.04,
              fontFamily: 'Inter-regular',
            ),
            suffixIcon: GestureDetector(
              onTap: () => _sendMessage(_controller.text),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Image.asset(
                  'assets/icon/arrow_up.png',
                  width: screenWidth * 0.06,
                  height: screenWidth * 0.06,
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: const Color(0xFFEDEDED),
            contentPadding:
                EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
          ),
        ),
      ),
    );
  }
}
