import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/terminal_theme.dart';

/// CommandLineInterface widget provides a terminal-style input for quick actions.
/// Supports commands like /join, /shrug, /leave, etc.
class CommandLineInterface extends StatefulWidget {
  final Function(String command, List<String> args) onCommand;
  final String? placeholder;
  
  const CommandLineInterface({
    Key? key,
    required this.onCommand,
    this.placeholder,
  }) : super(key: key);

  @override
  State<CommandLineInterface> createState() => _CommandLineInterfaceState();
}

class _CommandLineInterfaceState extends State<CommandLineInterface> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<String> _commandHistory = [];
  int _historyIndex = -1;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (text.startsWith('/')) {
      // Parse command
      final parts = text.substring(1).split(' ');
      final command = parts[0];
      final args = parts.length > 1 ? parts.sublist(1) : <String>[];
      
      // Add to history
      _commandHistory.add(text);
      _historyIndex = _commandHistory.length;
      
      // Execute command
      widget.onCommand(command, args);
    } else {
      // Regular message (not a command)
      widget.onCommand('message', [text]);
    }

    _controller.clear();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        // Navigate history up
        if (_historyIndex > 0) {
          _historyIndex--;
          _controller.text = _commandHistory[_historyIndex];
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        // Navigate history down
        if (_historyIndex < _commandHistory.length - 1) {
          _historyIndex++;
          _controller.text = _commandHistory[_historyIndex];
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        } else if (_historyIndex == _commandHistory.length - 1) {
          _historyIndex = _commandHistory.length;
          _controller.clear();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TerminalTheme.surface,
        border: Border.all(color: TerminalTheme.border),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: _handleKeyEvent,
        child: Row(
          children: [
            // Terminal prompt indicator
            Text(
              '❯',
              style: TerminalTheme.commandStyle,
            ),
            SizedBox(width: 8),
            
            // Command input
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: TerminalTheme.commandStyle.copyWith(
                  color: TerminalTheme.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: widget.placeholder ?? 'Type a command or message...',
                  hintStyle: TextStyle(
                    color: TerminalTheme.textMuted,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) => _handleSubmit(),
              ),
            ),
            
            // Send button
            IconButton(
              icon: Icon(Icons.send, size: 18),
              color: TerminalTheme.primary,
              onPressed: _handleSubmit,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Available commands in the CLI
class CLICommand {
  final String name;
  final String description;
  final List<String> aliases;
  final int minArgs;
  final int maxArgs;

  const CLICommand({
    required this.name,
    required this.description,
    this.aliases = const [],
    this.minArgs = 0,
    this.maxArgs = -1, // -1 means unlimited
  });

  static const List<CLICommand> builtInCommands = [
    CLICommand(
      name: 'join',
      description: 'Join a clan',
      minArgs: 1,
      maxArgs: 1,
    ),
    CLICommand(
      name: 'leave',
      description: 'Leave the current clan',
      minArgs: 0,
      maxArgs: 0,
    ),
    CLICommand(
      name: 'shrug',
      description: 'Insert ¯\\_(ツ)_/¯',
      aliases: ['shruggie'],
      minArgs: 0,
      maxArgs: 0,
    ),
    CLICommand(
      name: 'help',
      description: 'Show available commands',
      aliases: ['h', '?'],
      minArgs: 0,
      maxArgs: 1,
    ),
    CLICommand(
      name: 'edit',
      description: 'Edit your last message',
      minArgs: 0,
      maxArgs: 0,
    ),
    CLICommand(
      name: 'diff',
      description: 'Show diff of a message',
      minArgs: 1,
      maxArgs: 1,
    ),
    CLICommand(
      name: 'log',
      description: 'Show message history (git-style)',
      minArgs: 0,
      maxArgs: 1,
    ),
    CLICommand(
      name: 'claim',
      description: 'Claim a username',
      minArgs: 1,
      maxArgs: 1,
    ),
  ];

  static CLICommand? findCommand(String name) {
    for (final cmd in builtInCommands) {
      if (cmd.name == name || cmd.aliases.contains(name)) {
        return cmd;
      }
    }
    return null;
  }
}

/// Help dialog showing available commands
class CommandHelpDialog extends StatelessWidget {
  const CommandHelpDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TerminalTheme.surface,
      child: Container(
        constraints: BoxConstraints(maxWidth: 600, maxHeight: 500),
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Commands',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: CLICommand.builtInCommands.length,
                itemBuilder: (context, index) {
                  final cmd = CLICommand.builtInCommands[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            '/${cmd.name}',
                            style: TerminalTheme.commandStyle,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cmd.description,
                                style: TextStyle(color: TerminalTheme.textPrimary),
                              ),
                              if (cmd.aliases.isNotEmpty)
                                Text(
                                  'Aliases: ${cmd.aliases.map((a) => '/$a').join(', ')}',
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
                },
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('CLOSE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
