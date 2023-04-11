import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:simple_login/helper/firebase_helper.dart';

class DiagnosticForm extends StatefulWidget {
  @override
  _DiagnosticFormState createState() => _DiagnosticFormState();
}

class _DiagnosticFormState extends State<DiagnosticForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

// Initialise a controller. It will contains signature points, stroke width and pen color.
// It will allow you to interact with the widget
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My Page'),
      // ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Text('Message 1')),
                    Expanded(child: Text('Message 2')),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text('Text Box 1')),
                    Expanded(child: Text('Text Box 2')),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Diagnosis',
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Medication',
                    ),
                  ),
                  TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Extra notes',
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // INITIALIZE. RESULT IS A WIDGET, SO IT CAN BE DIRECTLY USED IN BUILD METHOD
                  Signature(
                    controller: _controller,
                    width: 300,
                    height: 200,
                    backgroundColor: Color.fromARGB(255, 225, 225, 225),
                  ),
                  Spacer(),
                  Container(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Handle submit button press
                        final name = _nameController.text;
                        final email = _emailController.text;
                        final message = _messageController.text;
                        print('Name: $name, Email: $email, Message: $message');
                        if (_controller.isNotEmpty) {
                          var signature = await _controller.toPngBytes();
                          var signId = await uploadImageByte(
                              signature!, 'name', 'description');
                        }
                      },
                      child: Text('Publish'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
