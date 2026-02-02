# Nothixapp Examples

This directory contains example code demonstrating how to use the various components of the Nothixapp Git-centric social platform.

## Running Examples

To run any example:

```bash
# Make sure you're in the project root
cd Nothixapp

# Run an example
flutter run examples/message_example.dart
# or
dart run examples/message_example.dart
```

## Available Examples

### 1. Message Example (`message_example.dart`)
Demonstrates the `CommitMessageModel` - the core data structure for messages.

**What it covers:**
- Creating new messages
- Editing messages (creating child commits)
- JSON serialization/deserialization
- Custom hash generation
- Building commit chains
- System messages

**Key concepts:**
```dart
// Create a message
final msg = CommitMessageModel.create(
  authorSignature: 'alice <alice@dev.com>',
  payload: 'Hello, world!',
);

// Edit creates a new commit with parent reference
final edited = CommitMessageModel.edit(
  parent: msg,
  newPayload: 'Hello, Nothixapp!',
);
```

### 2. Clan Example (`clan_example.dart`)
Demonstrates the clan hierarchy system with repository-style permissions.

**What it covers:**
- Creating clans with different visibility levels
- Managing clan members
- Role-based permissions (Maintainer, Contributor, Viewer)
- Permission checking
- Role promotion/demotion

**Key concepts:**
```dart
// Create a clan
final clan = ClanModel(
  id: 'rust-devs',
  name: 'Rust Developers',
  visibility: ClanVisibility.public,
  defaultRole: ClanRole.contributor,
);

// Add members with roles
final member = ClanMember(
  username: 'alice',
  role: ClanRole.maintainer,
);

// Check permissions
if (role.canPerform(ClanPermission.createPost)) {
  // User can post
}
```

### 3. Username Claim Example (`username_claim_example.dart`)
Demonstrates the blockchain-style username claim system.

**What it covers:**
- Claiming usernames
- Checking availability
- Viewing the claim chain
- Verifying chain integrity
- Handling duplicate claims
- JSON serialization

**Key concepts:**
```dart
final service = UsernameClaimService();

// Claim a username
final claim = await service.claimUsername(
  username: 'alice',
  publicKey: 'ed25519:...',
  signature: '...',
);

// Check availability
if (service.isAvailable('bob')) {
  // Username is available
}

// Verify the entire chain
if (service.verifyChain()) {
  // All claims are valid
}
```

## Full App Example

The `lib/main.dart` file contains a complete working Flutter application that demonstrates:

- **Terminal UI**: Dark mode terminal aesthetic with monospace fonts
- **Command System**: `/join`, `/leave`, `/shrug`, `/edit`, `/diff`, `/log`, `/claim`, `/help`
- **Message Display**: Cards with commit hashes, authors, timestamps
- **Markdown Rendering**: Full Markdown support with syntax highlighting
- **Diff Views**: Git-style diffs showing additions/deletions
- **Interactive CLI**: Command history with arrow keys

### Running the Full App

```bash
flutter run
```

## Code Snippets

### Creating a Terminal-Themed UI

```dart
import 'package:nothixapp/themes/terminal_theme.dart';

MaterialApp(
  theme: TerminalTheme.darkTheme,
  home: MyHomePage(),
)
```

### Rendering Markdown with Code Highlighting

```dart
import 'package:nothixapp/widgets/markdown_renderer.dart';

MarkdownRenderer(
  content: '''# Hello
  
```rust
fn main() {
    println!("Hello!");
}
```
  ''',
  selectable: true,
)
```

### Showing Diffs

```dart
import 'package:nothixapp/widgets/diff_view.dart';

DiffView(
  originalCommit: original,
  editedCommit: edited,
  showFullContent: true,
)

// Or compact indicator
DiffIndicator.fromCommits(original, edited)
```

### Command Line Interface

```dart
import 'package:nothixapp/widgets/command_line_interface.dart';

CommandLineInterface(
  onCommand: (command, args) {
    switch (command) {
      case 'join':
        joinClan(args[0]);
        break;
      case 'help':
        showHelp();
        break;
    }
  },
  placeholder: 'Type a command...',
)
```

### Syntax Highlighting

```dart
import 'package:nothixapp/services/syntax_highlighter_service.dart';

// Render a code block
SyntaxHighlighterService.codeBlockWithHeader(
  code: 'fn main() { }',
  language: 'rust',
  onCopy: () {
    // Handle copy
  },
)

// Auto-detect language
final lang = SyntaxHighlighterService.detectLanguage(code);

// Extract code blocks from markdown
final blocks = SyntaxHighlighterService.extractCodeBlocks(markdown);
```

## Architecture Patterns

### Message Versioning Flow

```
Original Message (msg1)
    ↓ [user edits]
Edit v1 (msg2 → parent: msg1)
    ↓ [user edits]
Edit v2 (msg3 → parent: msg2)
    ↓ [user edits]
Edit v3 (msg4 → parent: msg3)
```

### Permission Hierarchy

```
Maintainer (Level 3)
    ↓ Can do everything
Contributor (Level 2)
    ↓ Can create/edit own content
Viewer (Level 1)
    ↓ Read-only access
```

### Username Claim Chain

```
Genesis Claim (alice)
    ↓ [previousClaimHash: null]
Claim 2 (bob)
    ↓ [previousClaimHash: alice's hash]
Claim 3 (charlie)
    ↓ [previousClaimHash: bob's hash]
...
```

## Testing Examples

Each component has testable interfaces. Here's how to test them:

```dart
// Test CommitMessageModel
test('creates valid commit hash', () {
  final msg = CommitMessageModel.create(
    authorSignature: 'test',
    payload: 'test',
  );
  expect(msg.hash.length, 64); // SHA-256
});

// Test ClanRole permissions
test('maintainer can manage clan', () {
  expect(
    ClanRole.maintainer.canPerform(ClanPermission.manageClan),
    true,
  );
});

// Test username claims
test('prevents duplicate claims', () async {
  final service = UsernameClaimService();
  await service.claimUsername(
    username: 'alice',
    publicKey: 'key1',
    signature: 'sig1',
  );
  
  expect(
    () => service.claimUsername(
      username: 'alice',
      publicKey: 'key2',
      signature: 'sig2',
    ),
    throwsA(isA<UsernameAlreadyClaimedException>()),
  );
});
```

## Common Patterns

### Creating a Message Thread

```dart
// Original post
final post = CommitMessageModel.create(
  authorSignature: 'alice',
  payload: 'Original post',
);

// Reply (just another message in the same clan)
final reply = CommitMessageModel.create(
  authorSignature: 'bob',
  payload: 'Reply to alice',
  clanId: post.clanId,
);
```

### Handling Commands

```dart
void handleCommand(String cmd, List<String> args) {
  final command = CLICommand.findCommand(cmd);
  
  if (command == null) {
    print('Unknown command: $cmd');
    return;
  }
  
  if (args.length < command.minArgs) {
    print('Not enough arguments');
    return;
  }
  
  // Execute command
  executeCommand(command, args);
}
```

## Tips and Best Practices

1. **Always use CommitMessageModel.create() or .edit()**
   - Don't construct CommitMessageModel directly
   - These factory methods ensure proper hash generation

2. **Check permissions before actions**
   ```dart
   if (member.role.canPerform(permission)) {
     // Perform action
   }
   ```

3. **Verify username claims**
   ```dart
   if (!service.isAvailable(username)) {
     // Username taken
   }
   ```

4. **Use short hashes for display**
   ```dart
   print(commit.shortHash); // Instead of commit.hash
   ```

5. **Leverage the command system**
   - Add custom commands to CLICommand.builtInCommands
   - Use command history for better UX

## Need Help?

- Check the main [README.md](../README.md) for overview
- Read [ARCHITECTURE.md](../ARCHITECTURE.md) for deep dive
- Look at `lib/main.dart` for a complete working example
- Run the examples to see components in action

## Contributing Examples

If you create a useful example, please contribute it!

1. Create a new `.dart` file in `examples/`
2. Add documentation at the top
3. Add it to this README
4. Submit a pull request
