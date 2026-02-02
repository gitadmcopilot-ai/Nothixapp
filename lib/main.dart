import 'package:flutter/material.dart';
import 'themes/terminal_theme.dart';
import 'widgets/command_line_interface.dart';
import 'widgets/diff_view.dart';
import 'widgets/markdown_renderer.dart';
import 'models/commit_message_model.dart';
import 'models/clan_hierarchy_model.dart';
import 'models/username_claim_log.dart';

void main() {
  runApp(const NothixApp());
}

class NothixApp extends StatelessWidget {
  const NothixApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nothixapp - Git-Centric Social Platform',
      theme: TerminalTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CommitMessageModel> _messages = [];
  final UsernameClaimService _claimService = UsernameClaimService();
  String _currentClan = 'general';

  @override
  void initState() {
    super.initState();
    _loadDemoData();
  }

  void _loadDemoData() {
    // Add some demo messages
    final msg1 = CommitMessageModel.create(
      authorSignature: 'alice <alice@dev.com>',
      payload: '''# Welcome to Nothixapp!

This is a **Git-centric** social platform for developers.

## Features
- Terminal UI with monospace fonts
- Markdown support with syntax highlighting
- Git-like versioning for posts
- Diff views for edits
- Clan hierarchy (Maintainer/Contributor/Viewer)

Try some commands:
- `/join rust-devs` - Join a clan
- `/shrug` - Insert ¯\\_(ツ)_/¯
- `/help` - Show all commands

```rust
fn main() {
    println!("Hello, Nothixapp!");
}
```
''',
      clanId: _currentClan,
    );

    setState(() {
      _messages.add(msg1);
    });
  }

  void _handleCommand(String command, List<String> args) {
    switch (command) {
      case 'join':
        if (args.isNotEmpty) {
          setState(() {
            _currentClan = args[0];
          });
          _showSystemMessage('Joined clan: ${args[0]}');
        }
        break;

      case 'leave':
        setState(() {
          _currentClan = 'general';
        });
        _showSystemMessage('Left clan, returned to general');
        break;

      case 'shrug':
        _addMessage('¯\\_(ツ)_/¯');
        break;

      case 'help':
        showDialog(
          context: context,
          builder: (context) => const CommandHelpDialog(),
        );
        break;

      case 'edit':
        if (_messages.isNotEmpty) {
          _showEditDialog(_messages.last);
        }
        break;

      case 'diff':
        if (_messages.length >= 2) {
          showDialog(
            context: context,
            builder: (context) => DiffViewDialog(
              originalCommit: _messages[_messages.length - 2],
              editedCommit: _messages.last,
            ),
          );
        }
        break;

      case 'log':
        _showMessageLog();
        break;

      case 'claim':
        if (args.isNotEmpty) {
          _claimUsername(args[0]);
        }
        break;

      case 'message':
        if (args.isNotEmpty) {
          _addMessage(args[0]);
        }
        break;

      default:
        _showSystemMessage('Unknown command: /$command');
    }
  }

  void _addMessage(String content) {
    final msg = CommitMessageModel.create(
      authorSignature: 'You <you@dev.com>',
      payload: content,
      clanId: _currentClan,
    );

    setState(() {
      _messages.add(msg);
    });
  }

  void _showSystemMessage(String content) {
    final msg = CommitMessageModel.create(
      authorSignature: 'System',
      payload: content,
      clanId: _currentClan,
    );

    setState(() {
      _messages.add(msg.copyWith(commitType: CommitType.system));
    });
  }

  void _showEditDialog(CommitMessageModel message) {
    final controller = TextEditingController(text: message.payload);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(24),
          constraints: BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Message',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Content',
                  hintText: 'Enter new message content...',
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('CANCEL'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final edited = CommitMessageModel.edit(
                        parent: message,
                        newPayload: controller.text,
                      );
                      setState(() {
                        _messages.add(edited);
                      });
                      Navigator.pop(context);
                    },
                    child: Text('SAVE'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessageLog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(24),
          constraints: BoxConstraints(maxWidth: 800, maxHeight: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Message Log (git log style)',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[_messages.length - 1 - index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'commit ${msg.hash}',
                            style: TerminalTheme.commitHashStyle,
                          ),
                          if (msg.parentHash != null)
                            Text(
                              'parent ${msg.parentHash}',
                              style: TerminalTheme.timestampStyle,
                            ),
                          Text(
                            'Author: ${msg.authorSignature}',
                            style: TerminalTheme.authorStyle,
                          ),
                          Text(
                            'Date: ${msg.timestamp}',
                            style: TerminalTheme.timestampStyle,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '    ${msg.payload.split('\n').first}',
                            style: TextStyle(color: TerminalTheme.textPrimary),
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _claimUsername(String username) async {
    try {
      final claim = await _claimService.claimUsername(
        username: username,
        publicKey: 'demo_public_key_${username}',
        signature: 'demo_signature',
      );
      _showSystemMessage('Successfully claimed username: @$username\nClaim hash: ${claim.shortHash}');
    } catch (e) {
      _showSystemMessage('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.terminal, size: 20),
            SizedBox(width: 8),
            Text('Nothixapp'),
            SizedBox(width: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: TerminalTheme.border),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '#$_currentClan',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CommandHelpDialog(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages area
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageCard(msg);
              },
            ),
          ),
          
          // Command line interface
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TerminalTheme.surface,
              border: Border(
                top: BorderSide(color: TerminalTheme.border),
              ),
            ),
            child: CommandLineInterface(
              onCommand: _handleCommand,
              placeholder: 'Type a command or message...',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(CommitMessageModel msg) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: TerminalTheme.surface,
        border: Border.all(color: TerminalTheme.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Message header
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TerminalTheme.surfaceVariant,
              borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
            ),
            child: Row(
              children: [
                Text(
                  msg.author,
                  style: TerminalTheme.authorStyle,
                ),
                SizedBox(width: 8),
                Text(
                  msg.shortHash,
                  style: TerminalTheme.commitHashStyle,
                ),
                Spacer(),
                Text(
                  _formatTimestamp(msg.timestamp),
                  style: TerminalTheme.timestampStyle,
                ),
              ],
            ),
          ),
          
          // Message content
          Padding(
            padding: EdgeInsets.all(16),
            child: MarkdownRenderer(content: msg.payload),
          ),
          
          // Show edit indicator if this is an edit
          if (msg.isEdit)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: TerminalTheme.background,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit, size: 14, color: TerminalTheme.warning),
                  SizedBox(width: 4),
                  Text(
                    'Edited (parent: ${msg.parentHash?.substring(0, 7)})',
                    style: TextStyle(
                      color: TerminalTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return 'just now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
