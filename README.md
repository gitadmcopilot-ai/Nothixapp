# Nothixapp

A **Git-centric** social/chat platform for developers, built with Flutter and Rust principles.

## Overview

Nothixapp is a developer-first social platform that treats communication like code. Every message is a "commit" with versioning, diffs, and cryptographic signatures. The platform features a terminal-driven UI with monospace fonts and git-style commands.

## Features

### 🖥️ Terminal-Driven UI
- **Monospace Fonts**: Uses JetBrains Mono for authentic terminal feel
- **Dark Mode Only**: High-contrast terminal aesthetic
- **Command-Line Interface**: Quick actions via `/commands`
  - `/join <clan_name>` - Join a clan
  - `/leave` - Leave current clan
  - `/shrug` - Insert ¯\_(ツ)_/¯
  - `/edit` - Edit your last message
  - `/diff <hash>` - Show diff view
  - `/log` - Show message history (git-style)
  - `/claim <username>` - Claim a username
  - `/help` - Show all commands

### 📝 Markdown Support
- Full Markdown rendering for all messages
- Code blocks with syntax highlighting
- Support for multiple programming languages
- Terminal-themed code blocks

### 🔄 Git-Like Versioning
- **Commit Messages**: Every message is a commit with a unique hash
- **Parent References**: Edits link to previous versions via parent hash
- **Diff View**: See changes between versions with git-style diffs
- **Message History**: View commit logs like `git log`
- **Cryptographic Signatures**: ED25519 signatures for verification

### 👥 Clan Hierarchy
Repository-style permissions for teams:
- **Maintainer (★)**: Full access, can manage members and clan settings
- **Contributor (●)**: Can create/edit own posts and comment
- **Viewer (○)**: Read-only access

### 🎖️ Username Claim System
- **Claim Log**: Blockchain/git-log style username claims
- **Immutable Records**: Every claim is permanent and publicly visible
- **Timestamp Verification**: Proof of when username was claimed
- **Chain Integrity**: Verifiable chain of username claims

## Architecture

### Core Models

#### `CommitMessageModel`
```dart
class CommitMessageModel {
  final String hash;              // SHA-256 commit hash
  final String? parentHash;       // Parent commit reference
  final String authorSignature;   // Author with ED25519 signature
  final String payload;           // Message content (Markdown)
  final DateTime timestamp;       // Unix timestamp
  final CommitType commitType;    // message, edit, system, merge
}
```

#### `ClanHierarchy`
```dart
enum ClanRole {
  maintainer,   // Full access
  contributor,  // Create/edit own content
  viewer,       // Read-only
}

class ClanModel {
  final String id;
  final String name;
  final String description;
  final ClanVisibility visibility;  // public, private, secret
  final ClanRole defaultRole;
}
```

#### `UsernameClaimLog`
```dart
class UsernameClaimLog {
  final String claimHash;
  final String username;
  final String claimerPublicKey;
  final DateTime timestamp;
  final String? previousClaimHash;  // Links to previous claim
  final String signature;
}
```

### Core Services

#### `SyntaxHighlighterService`
- Integrates with `flutter_highlight`
- Custom terminal theme for code blocks
- Supports 20+ programming languages
- Auto-detection of language from code content

### UI Components

#### `TerminalTheme`
- Dark-mode terminal aesthetic
- GitHub-inspired color palette
- Monospace fonts throughout
- Git-specific styling (commit hashes, diffs, timestamps)

#### `CommandLineInterface`
- Terminal-style command input
- Command history with up/down arrows
- Auto-completion support
- Built-in commands with validation

#### `DiffView`
- Git-style diff display
- Green (+) for additions
- Red (-) for deletions
- Line-by-line comparison
- Compact diff indicator (+X/-Y)

#### `MarkdownRenderer`
- Full Markdown support
- Syntax-highlighted code blocks
- Terminal-themed styling
- Selectable content

## Installation

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Setup
```bash
# Clone the repository
git clone https://github.com/gitadmcopilot-ai/Nothixapp.git
cd Nothixapp

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## Usage Examples

### Sending Messages
```
# Regular message
Hello, world!

# Message with code
Check out this Rust code:
```rust
fn main() {
    println!("Hello from Rust!");
}
```
```

### Using Commands
```
# Join a clan
/join rust-devs

# Leave clan
/leave

# Edit last message
/edit

# View diff between messages
/diff abc123

# Show message log
/log

# Claim username
/claim alice

# Get help
/help
```

### Editing Messages
1. Type `/edit` to edit your last message
2. The original message is preserved as parent commit
3. View changes with `/diff` or click the diff indicator

## Project Structure

```
lib/
├── main.dart                   # App entry point
├── models/
│   ├── commit_message_model.dart
│   ├── clan_hierarchy_model.dart
│   └── username_claim_log.dart
├── services/
│   └── syntax_highlighter_service.dart
├── themes/
│   └── terminal_theme.dart
├── widgets/
│   ├── command_line_interface.dart
│   ├── diff_view.dart
│   └── markdown_renderer.dart
└── utils/
    └── crypto_utils.dart
```

## Dependencies

- `flutter_markdown`: Markdown rendering
- `flutter_highlight`: Syntax highlighting
- `google_fonts`: JetBrains Mono font
- `cryptography`: ED25519 signatures
- `crypto`: SHA-256 hashing
- `diff_match_patch`: Git-style diffing

## Roadmap

- [ ] Backend integration (Rust server)
- [ ] Real-time messaging (WebSocket)
- [ ] ED25519 signature verification
- [ ] User authentication
- [ ] Clan management UI
- [ ] Search functionality
- [ ] Notifications
- [ ] Mobile-optimized layouts
- [ ] Desktop app (Flutter Desktop)

## Contributing

Contributions are welcome! This is a developer-first platform, so we appreciate:
- Clean, well-documented code
- Terminal-aesthetic UI components
- Git-style features
- Performance optimizations

## License

MIT License - See LICENSE file for details

## Author

Built with ❤️ by the Nothixapp team

---

**Note**: This is a Flutter architecture demonstration. For production use, implement proper backend integration, authentication, and security measures.