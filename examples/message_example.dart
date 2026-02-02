/// Example: Creating and Managing Messages
/// This file demonstrates how to use the CommitMessageModel

import 'package:nothixapp/models/commit_message_model.dart';

void main() {
  // Example 1: Create a new message
  print('=== Example 1: Creating a Message ===');
  final message1 = CommitMessageModel.create(
    authorSignature: 'alice <alice@developers.io>',
    payload: '''# Hello Nothixapp!

This is my first post on this Git-centric platform.

Check out this Rust code:

```rust
fn main() {
    println!("Hello from Rust!");
}
```
''',
    clanId: 'rust-devs',
  );

  print('Hash: ${message1.hash}');
  print('Short Hash: ${message1.shortHash}');
  print('Author: ${message1.author}');
  print('Timestamp: ${message1.timestamp}');
  print('Is Edit: ${message1.isEdit}');
  print('\n');

  // Example 2: Edit a message (creates new commit)
  print('=== Example 2: Editing a Message ===');
  final editedMessage = CommitMessageModel.edit(
    parent: message1,
    newPayload: '''# Hello Nothixapp! (Updated)

This is my first post on this Git-centric platform.
I've updated it to add more details.

Check out this improved Rust code:

```rust
fn main() {
    let greeting = "Hello from Rust!";
    println!("{}", greeting);
}
```
''',
  );

  print('Edited Hash: ${editedMessage.hash}');
  print('Parent Hash: ${editedMessage.parentHash}');
  print('Is Edit: ${editedMessage.isEdit}');
  print('Same Author: ${editedMessage.author == message1.author}');
  print('\n');

  // Example 3: JSON Serialization
  print('=== Example 3: JSON Serialization ===');
  final json = message1.toJson();
  print('Serialized to JSON:');
  print(json);
  print('\n');

  final fromJson = CommitMessageModel.fromJson(json);
  print('Deserialized from JSON:');
  print('Hash matches: ${fromJson.hash == message1.hash}');
  print('Author matches: ${fromJson.author == message1.author}');
  print('\n');

  // Example 4: Custom hash generation
  print('=== Example 4: Custom Hash Generation ===');
  final customHash = CommitMessageModel.generateHash(
    'Custom content',
    'bob',
    DateTime.now(),
  );
  print('Custom hash: $customHash');
  print('Hash length: ${customHash.length} characters');
  print('\n');

  // Example 5: Commit chain
  print('=== Example 5: Commit Chain (Multiple Edits) ===');
  var current = message1;
  print('Original: ${current.shortHash}');

  for (var i = 1; i <= 3; i++) {
    current = CommitMessageModel.edit(
      parent: current,
      newPayload: 'Edit version $i',
    );
    print('Edit $i: ${current.shortHash} (parent: ${current.parentHash?.substring(0, 7)})');
  }
  print('\n');

  // Example 6: System messages
  print('=== Example 6: System Messages ===');
  final systemMsg = CommitMessageModel.create(
    authorSignature: 'System',
    payload: 'User @alice joined the clan #rust-devs',
    clanId: 'rust-devs',
  ).copyWith(commitType: CommitType.system);

  print('System message hash: ${systemMsg.shortHash}');
  print('Type: ${systemMsg.commitType}');
  print('Payload: ${systemMsg.payload}');
}
