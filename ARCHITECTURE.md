# Nothixapp Architecture Guide

## Design Principles

### 1. Dev-First Philosophy
Everything in Nothixapp is designed with developers in mind:
- Terminal-driven UI familiar to command-line users
- Git-inspired versioning and history
- Markdown-first content with code highlighting
- Keyboard-friendly interactions

### 2. Immutable Message History
Like Git commits, messages are immutable:
- Every message gets a unique SHA-256 hash
- Edits create new commits linked to parents
- Complete audit trail of all changes
- Diff views show exactly what changed

### 3. Cryptographic Trust
Security through cryptography:
- ED25519 signatures for message authentication
- Public key infrastructure for user identity
- Blockchain-style username claim log
- Verifiable chain of trust

## Component Architecture

### State Management
The app uses a simple state management approach suitable for the architecture:
```dart
// Current implementation uses StatefulWidget
// For production, consider:
// - Provider for global state
// - Riverpod for more complex state
// - Bloc for event-driven architecture
```

### Data Flow
```
User Input (CLI/UI)
    ↓
Command Parser
    ↓
Business Logic (Models/Services)
    ↓
State Update
    ↓
UI Re-render
```

### Message Lifecycle
```
1. Create Message
   ↓
2. Generate Hash (SHA-256)
   ↓
3. Sign with Private Key (ED25519)
   ↓
4. Add to Commit Chain
   ↓
5. Broadcast to Network
   ↓
6. Verify Signature
   ↓
7. Store in Local/Remote DB
```

## Key Components

### TerminalTheme
**Purpose**: Provides consistent terminal aesthetic across the app

**Features**:
- Dark-mode only design
- Monospace fonts (JetBrains Mono)
- Git-inspired color scheme
- Semantic color coding (success=green, error=red, etc.)

**Usage**:
```dart
MaterialApp(
  theme: TerminalTheme.darkTheme,
  // ...
)
```

### CommitMessageModel
**Purpose**: Represents a message as a git-style commit

**Key Methods**:
- `create()` - Create new message
- `edit()` - Create edited version with parent link
- `generateHash()` - Generate unique commit hash
- `shortHash` - Get abbreviated hash (git-style)

**Example**:
```dart
// Create initial message
final msg = CommitMessageModel.create(
  authorSignature: 'alice <alice@dev.com>',
  payload: 'Hello, world!',
  clanId: 'general',
);

// Edit the message
final edited = CommitMessageModel.edit(
  parent: msg,
  newPayload: 'Hello, Nothixapp!',
);

print(edited.parentHash); // Points to original
```

### ClanHierarchy
**Purpose**: Manage repository-style permissions

**Roles**:
- **Maintainer**: Full access (like repo owner)
- **Contributor**: Can post/edit own content (like collaborator)
- **Viewer**: Read-only (like public viewer)

**Example**:
```dart
final clan = ClanModel(
  id: 'rust-devs',
  name: 'Rust Developers',
  description: 'A clan for Rust enthusiasts',
  creator: 'alice',
  createdAt: DateTime.now(),
  visibility: ClanVisibility.public,
  defaultRole: ClanRole.viewer,
);

// Check permissions
if (role.canPerform(ClanPermission.createPost)) {
  // User can post
}
```

### UsernameClaimLog
**Purpose**: Blockchain-style username registration

**Features**:
- Immutable claim records
- Chained previous claims
- Public verification
- Timestamp proof

**Example**:
```dart
final service = UsernameClaimService();

// Claim a username
final claim = await service.claimUsername(
  username: 'alice',
  publicKey: 'user_public_key',
  signature: 'cryptographic_signature',
);

// Check availability
if (service.isAvailable('bob')) {
  // Username is available
}

// Verify chain integrity
if (service.verifyChain()) {
  // Chain is valid
}
```

### SyntaxHighlighterService
**Purpose**: Render code blocks with syntax highlighting

**Supported Languages**:
- Rust, Dart, Go, Python, JavaScript/TypeScript
- Java, C/C++, Swift, Kotlin
- Ruby, PHP, Scala
- Shell, SQL, JSON, YAML, XML

**Example**:
```dart
// Render code block
SyntaxHighlighterService.renderCodeBlock(
  code: 'fn main() { println!("Hello"); }',
  language: 'rust',
  showLineNumbers: true,
);

// Auto-detect language
final lang = SyntaxHighlighterService.detectLanguage(code);

// Extract code blocks from markdown
final blocks = SyntaxHighlighterService.extractCodeBlocks(markdown);
```

### CommandLineInterface
**Purpose**: Terminal-style input for commands

**Built-in Commands**:
- `/join <clan>` - Join a clan
- `/leave` - Leave current clan
- `/shrug` - Insert shrug emoji
- `/edit` - Edit last message
- `/diff <hash>` - Show diff
- `/log` - Show message history
- `/claim <username>` - Claim username
- `/help` - Show help

**Features**:
- Command history (up/down arrows)
- Auto-completion
- Command validation
- Extensible command system

**Example**:
```dart
CommandLineInterface(
  onCommand: (command, args) {
    switch (command) {
      case 'join':
        joinClan(args[0]);
        break;
      // Handle other commands
    }
  },
  placeholder: 'Type a command or message...',
)
```

### DiffView
**Purpose**: Show git-style diffs between message versions

**Features**:
- Line-by-line comparison
- Green (+) for additions
- Red (-) for deletions
- Compact diff indicators
- Full diff dialog

**Example**:
```dart
DiffView(
  originalCommit: original,
  editedCommit: edited,
  showFullContent: true,
)

// Show compact indicator
DiffIndicator.fromCommits(original, edited)
```

## Extending the Architecture

### Adding Custom Commands
```dart
// 1. Add to CLICommand.builtInCommands
const CLICommand(
  name: 'mycommand',
  description: 'My custom command',
  minArgs: 1,
  maxArgs: 2,
)

// 2. Handle in onCommand callback
case 'mycommand':
  handleMyCommand(args);
  break;
```

### Adding New Commit Types
```dart
// 1. Extend CommitType enum
enum CommitType {
  message,
  edit,
  system,
  merge,
  myCustomType, // Add here
}

// 2. Handle in UI
if (msg.commitType == CommitType.myCustomType) {
  // Custom rendering
}
```

### Custom Syntax Highlighting Themes
```dart
// Create custom theme
static final Map<String, TextStyle> myTheme = {
  'root': TextStyle(color: Colors.white),
  'keyword': TextStyle(color: Colors.blue),
  // ... other styles
};

// Use in service
SyntaxHighlighterService.renderCodeBlock(
  code: code,
  language: language,
  // Pass custom theme if needed
);
```

## Performance Considerations

### Message List Optimization
```dart
// Use ListView.builder for large lists
ListView.builder(
  itemCount: messages.length,
  itemBuilder: (context, index) {
    return MessageCard(message: messages[index]);
  },
)
```

### Diff Computation
For large messages, consider:
- Computing diffs in isolates
- Caching computed diffs
- Using incremental diff algorithms

### Syntax Highlighting
- Lazy load highlighter
- Cache highlighted code
- Use web workers for long code blocks

## Testing Strategy

### Unit Tests
```dart
test('CommitMessageModel generates valid hash', () {
  final msg = CommitMessageModel.create(
    authorSignature: 'test',
    payload: 'test message',
  );
  
  expect(msg.hash.length, 64); // SHA-256
  expect(msg.shortHash.length, 7);
});
```

### Widget Tests
```dart
testWidgets('CommandLineInterface handles commands', (tester) async {
  bool commandCalled = false;
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CommandLineInterface(
          onCommand: (cmd, args) {
            commandCalled = true;
          },
        ),
      ),
    ),
  );
  
  // Test command input
  await tester.enterText(find.byType(TextField), '/help');
  await tester.testTextInput.receiveAction(TextInputAction.done);
  
  expect(commandCalled, true);
});
```

## Security Best Practices

1. **Never store private keys in code**
2. **Always verify signatures before trusting content**
3. **Use secure random for key generation**
4. **Implement rate limiting for username claims**
5. **Validate all user input**
6. **Use HTTPS for all network communication**
7. **Implement proper session management**

## Future Enhancements

### Backend Integration
- WebSocket for real-time updates
- REST API for CRUD operations
- GraphQL for complex queries
- Redis for caching

### Mobile Features
- Push notifications
- Offline mode
- Background sync
- Biometric auth

### Desktop Features
- Multiple windows
- System tray integration
- Native menus
- File drag-and-drop

### Advanced Git Features
- Branching conversations
- Merging threads
- Cherry-picking messages
- Rebasing discussions
- Tagging important messages
