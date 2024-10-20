import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmailComposer extends StatefulWidget {
  @override
  _EmailComposerState createState() => _EmailComposerState();
}

class _EmailComposerState extends State<EmailComposer> {
  final TextEditingController _emailReceivedController = TextEditingController();
  final TextEditingController _emailReplyController = TextEditingController();
  int _countToken = 100;

  void _createDraft(String action) {
    String draft;
    switch (action) {
      case 'Thanks':
        draft = 'Thank you for your email.';
        break;
      case 'Sorry':
        draft = 'I apologize for any inconvenience caused.';
        break;
      case 'Yes':
        draft = 'Yes, I agree with your proposal.';
        break;
      case 'No':
        draft = 'No, I do not agree with your proposal.';
        break;
      case 'Follow Up':
        draft = 'I am following up on our previous conversation.';
        break;
      case 'Request for more information':
        draft = 'Could you please provide more information?';
        break;
      default:
        draft = '';
    }
    setState(() {
      _emailReplyController.text = draft;
    });
  }
  Widget _buildTextField(String label, TextEditingController controller) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
        ),
        maxLines: 20,
      ),
    );
  }
  Widget _buildButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          Text(label),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Center(
          child: Text(
              'Email reply',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 30,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Row(
            children: [
              Icon(
                Icons.flash_on,
                color: Colors.greenAccent,
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  '$_countToken',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                ),
              ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField('Email received', _emailReceivedController),
            const SizedBox(height: 20),
            _buildTextField('AI reply', _emailReplyController),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                _buildButton(Icons.handshake, 'Thanks', () => _createDraft('Thanks')),
                _buildButton(Icons.emoji_emotions_rounded, 'Sorry', () => _createDraft('Sorry')),
                _buildButton(Icons.thumb_up, 'Yes', () => _createDraft('Yes')),
                _buildButton(Icons.thumb_down, 'No', () => _createDraft('No')),
                _buildButton(Icons.follow_the_signs, 'Follow Up', () => _createDraft('Follow Up')),
                _buildButton(Icons.question_answer, 'Request for more information', () => _createDraft('Request for more information')),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.send),
                  color: Colors.blue, // Icon color
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}