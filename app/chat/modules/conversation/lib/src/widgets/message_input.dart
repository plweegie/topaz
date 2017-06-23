// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

const double _kPaddingValue = 16.0;

/// UI Widget for message text input
class MessageInput extends StatefulWidget {
  /// Indicates whether this message input is interactive.
  final bool enabled;

  /// Callback for when a new message is submitted
  final ValueChanged<String> onSubmitMessage;

  /// Callback for when the share photo button is tapped
  final VoidCallback onTapSharePhoto;

  /// Constructor
  MessageInput({
    Key key,
    this.enabled: true,
    this.onSubmitMessage,
    this.onTapSharePhoto,
  })
      : super(key: key) {
    assert(this.enabled != null);
  }

  @override
  _MessageInputState createState() => new _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = new TextEditingController();

  bool get _sendButtonEnabled => widget.enabled && _controller.text.isNotEmpty;

  void _handleSubmit() {
    if (_controller.text.isNotEmpty) {
      widget.onSubmitMessage?.call(_controller.text);
      _controller.clear();
    }
  }

  Widget buildAttachmentButton({
    IconData icon,
    VoidCallback onPressed,
  }) {
    return new InkWell(
      onTap: widget.enabled ? onPressed : null,
      child: new Container(
        padding: const EdgeInsets.all(_kPaddingValue),
        child: new Icon(
          icon,
          color: widget.enabled ? Colors.grey[700] : Colors.grey[300],
        ),
      ),
    );
  }

  Widget buildSendButton(Color primaryColor) {
    return new Container(
      padding: const EdgeInsets.all(_kPaddingValue),
      child: new AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return new Material(
            color: _sendButtonEnabled ? primaryColor : Colors.grey[300],
            type: MaterialType.circle,
            elevation: _sendButtonEnabled ? 4.0 : 2.0,
            child: new Container(
              width: 40.0,
              height: 40.0,
              child: new InkWell(
                onTap: _sendButtonEnabled ? _handleSubmit : null,
                child: new Center(
                  child: new Icon(
                    Icons.send,
                    color: _sendButtonEnabled ? Colors.white : Colors.grey[700],
                    size: 16.0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return new Container(
      decoration: new BoxDecoration(
        border: new Border(
          top: new BorderSide(
            color: Colors.grey[300],
          ),
        ),
      ),
      child: new Material(
        color: Colors.white,
        child: new Row(
          children: <Widget>[
            buildAttachmentButton(
              icon: Icons.photo_library,
              onPressed: () => widget.onTapSharePhoto?.call(),
            ),
            new Expanded(
              child: widget.enabled
                  ? new TextField(
                      maxLines: null,
                      controller: _controller,
                      onSubmitted: (_) => _handleSubmit(),
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Type a message',
                      ),
                    )
                  : new Container(),
            ),
            buildSendButton(theme.primaryColor),
          ],
        ),
      ),
    );
  }
}
