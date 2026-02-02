# Quick Start Guide

Get started with Nothixapp in 5 minutes!

## Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- An IDE (VS Code, Android Studio, or IntelliJ)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/gitadmcopilot-ai/Nothixapp.git
cd Nothixapp
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
# For development
flutter run

# For specific device
flutter run -d chrome  # Web
flutter run -d macos   # macOS
flutter run -d ios     # iOS simulator
```

## First Steps

### 1. Understanding the Interface

When you launch Nothixapp, you'll see:

```
╔════════════════════════════════════════╗
║  Nothixapp           #general      [?] ║
╠════════════════════════════════════════╣
║                                        ║
║  [Messages appear here]                ║
║                                        ║
╠════════════════════════════════════════╣
║  ❯ Type a command or message...    [>] ║
╚════════════════════════════════════════╝
```

### 2. Send Your First Message

Just type in the command line:

```
Hello, Nothixapp!
```

Press Enter, and your message will appear as a commit!

### 3. Try Commands

Commands start with `/`. Try these:

```bash
# Show all available commands
/help

# Join a clan
/join rust-devs

# Leave current clan
/leave

# Insert a shrug emoji
/shrug

# View message history (like git log)
/log

# Claim a username
/claim myusername
```

### 4. Format Messages with Markdown

Your messages support full Markdown:

```markdown
# This is a heading

**Bold text** and *italic text*

- Bullet point 1
- Bullet point 2

[Link to GitHub](https://github.com)

Inline `code` works too!
```

### 5. Share Code Snippets

Use triple backticks with language name:

````markdown
```rust
fn main() {
    println!("Hello from Rust!");
}
```
````

The code will be syntax highlighted automatically!

### 6. Edit Messages

Type `/edit` to edit your last message:

```
/edit
```

This creates a new "commit" linked to the original. View the diff by clicking the edit indicator!

### 7. View Diffs

See what changed between versions:

```
/diff
```

You'll see a git-style diff with:
- Green (+) for additions
- Red (-) for deletions

## Common Workflows

### Starting a Discussion

1. Join or create a clan: `/join rust-discussion`
2. Post your message with code
3. Others can reply
4. Edit your posts as needed with `/edit`

### Collaborating on Code

1. Share a code snippet:
   ````
   Check out this Rust code:
   ```rust
   fn factorial(n: u32) -> u32 {
       match n {
           0 => 1,
           _ => n * factorial(n - 1),
       }
   }
   ```
   ````

2. Others can reply with improvements
3. Edit your code and show diffs

### Managing a Clan

As a **Maintainer**:
- You have full access
- Can manage members
- Can delete any post

As a **Contributor**:
- Can create posts
- Can edit own posts
- Can comment

As a **Viewer**:
- Read-only access
- Cannot post or comment

## Keyboard Shortcuts

- `↑` / `↓` - Navigate command history
- `Enter` - Send message/command
- `Ctrl+C` - Copy code from code blocks

## Tips & Tricks

### 1. Command Shortcuts

Many commands have aliases:
- `/h` = `/help`
- `/shrug` = `/shruggie`

### 2. Quick Actions

- Type `/` to see command suggestions
- Use arrow keys to recall previous commands
- Press `?` icon for help anytime

### 3. Message Hashing

Every message gets a unique hash (like a git commit):
- Full hash: 64 characters (SHA-256)
- Short hash: 7 characters (displayed in UI)
- Click on hash to copy

### 4. Username Claims

Claiming a username is permanent and public:
```
/claim alice
```

Check the claim log:
```
/log
```

### 5. Viewing History

See all your messages in git log style:
```
/log
```

Output looks like:
```
commit 8a3f92b1...
Author: alice <alice@dev.com>
Date: 2024-01-15 10:30:00

    My first message on Nothixapp!
```

## Customization

### Change Your Signature

Edit your author signature in the code:

```dart
// In main.dart
final msg = CommitMessageModel.create(
  authorSignature: 'yourusername <your@email.com>',
  payload: content,
);
```

### Add Custom Commands

Add to `CLICommand.builtInCommands`:

```dart
const CLICommand(
  name: 'wave',
  description: 'Wave hello 👋',
  minArgs: 0,
  maxArgs: 0,
),
```

Then handle it:

```dart
case 'wave':
  _addMessage('👋 Hello everyone!');
  break;
```

## Next Steps

- Read [README.md](README.md) for full feature list
- Check [ARCHITECTURE.md](ARCHITECTURE.md) for technical details
- Explore [examples/](examples/) for code examples
- Join the community and start chatting!

## Troubleshooting

### Dependencies Not Installing?

```bash
flutter clean
flutter pub get
```

### App Not Running?

Check Flutter doctor:
```bash
flutter doctor -v
```

### Issues with Fonts?

The app uses JetBrains Mono via Google Fonts. Make sure you have internet connection for the first run.

### Code Highlighting Not Working?

Make sure these packages are installed:
```bash
flutter pub get flutter_highlight
```

## Getting Help

- Check the examples in `examples/`
- Read the documentation
- Open an issue on GitHub
- Ask in the community

## Contributing

Want to contribute? Great!

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add examples/tests
5. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

**Happy Coding!** 🚀

Remember: Every message is a commit. Every edit is versioned. Every username claim is permanent. Welcome to the Git-centric social platform for developers!
