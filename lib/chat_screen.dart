import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'chat_provider.dart';
import 'user_message_bubble.dart';
import 'ai_message_bubble.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceInput = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Provider.of<ChatProvider>(context, listen: false)
          .addImageMessage(pickedFile.path, 'user');
    }
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (val) => setState(() {
            _voiceInput = val.recognizedWords;
          }));
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
    if (_voiceInput.isNotEmpty) {
      Provider.of<ChatProvider>(context, listen: false)
          .addVoiceMessage(_voiceInput, 'user');
      _voiceInput = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                return ListView.builder(
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    if (message['type'] == 'text') {
                      if (message['sender'] == 'user') {
                        return UserMessageBubble(message: message['message']);
                      } else {
                        return AIMessageBubble(message: message['message']);
                      }
                    } else if (message['type'] == 'image') {
                      return ImageMessageBubble(imagePath: message['imagePath']);
                    } else if (message['type'] == 'voice') {
                      return VoiceMessageBubble(voicePath: message['voicePath']);
                    }
                    return SizedBox.shrink();
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      Provider.of<ChatProvider>(context, listen: false)
                          .addMessage(_controller.text, 'user');
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageMessageBubble extends StatelessWidget {
  final String imagePath;

  ImageMessageBubble({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Image.file(File(imagePath)),
      ),
    );
  }
}

class VoiceMessageBubble extends StatelessWidget {
  final String voicePath;

  VoiceMessageBubble({required this.voicePath});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(voicePath), // Placeholder for voice message
      ),
    );
  }
}