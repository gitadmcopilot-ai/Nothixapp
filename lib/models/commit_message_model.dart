import 'package:crypto/crypto.dart';
import 'dart:convert';

/// CommitMessageModel represents a message/post in the Git-centric social platform.
/// Each message is treated like a Git commit with versioning, parent references,
/// and cryptographic signatures.
class CommitMessageModel {
  /// Unique hash (SHA-256) identifying this message commit
  final String hash;
  
  /// Hash of the parent message (null for initial post)
  /// For edits, this points to the previous version
  final String? parentHash;
  
  /// Author's ED25519 signature for verification
  /// Format: "username <email>" or just "username"
  final String authorSignature;
  
  /// The actual message content (supports Markdown)
  final String payload;
  
  /// Unix timestamp when this commit was created
  final DateTime timestamp;
  
  /// Optional: List of parent hashes for merge commits
  /// (e.g., when combining two discussion threads)
  final List<String>? parentHashes;
  
  /// Metadata: Clan/channel this message belongs to
  final String? clanId;
  
  /// Metadata: Type of commit (message, edit, system)
  final CommitType commitType;
  
  /// Verification status of the signature
  bool isVerified;

  CommitMessageModel({
    required this.hash,
    this.parentHash,
    required this.authorSignature,
    required this.payload,
    required this.timestamp,
    this.parentHashes,
    this.clanId,
    this.commitType = CommitType.message,
    this.isVerified = false,
  });

  /// Creates a CommitMessageModel from a Map (e.g., from JSON)
  factory CommitMessageModel.fromJson(Map<String, dynamic> json) {
    return CommitMessageModel(
      hash: json['hash'] as String,
      parentHash: json['parent_hash'] as String?,
      authorSignature: json['author_signature'] as String,
      payload: json['payload'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      parentHashes: json['parent_hashes'] != null
          ? List<String>.from(json['parent_hashes'] as List)
          : null,
      clanId: json['clan_id'] as String?,
      commitType: CommitType.values.firstWhere(
        (e) => e.name == json['commit_type'],
        orElse: () => CommitType.message,
      ),
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }

  /// Converts this CommitMessageModel to a Map (e.g., for JSON serialization)
  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'parent_hash': parentHash,
      'author_signature': authorSignature,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
      'parent_hashes': parentHashes,
      'clan_id': clanId,
      'commit_type': commitType.name,
      'is_verified': isVerified,
    };
  }

  /// Generates a hash for this commit based on its content
  /// Similar to how Git generates commit hashes
  static String generateHash(String content, String author, DateTime timestamp) {
    final data = '$content$author${timestamp.millisecondsSinceEpoch}';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Creates a new CommitMessageModel (initial post)
  factory CommitMessageModel.create({
    required String authorSignature,
    required String payload,
    String? clanId,
  }) {
    final timestamp = DateTime.now();
    final hash = generateHash(payload, authorSignature, timestamp);
    
    return CommitMessageModel(
      hash: hash,
      authorSignature: authorSignature,
      payload: payload,
      timestamp: timestamp,
      clanId: clanId,
      commitType: CommitType.message,
    );
  }

  /// Creates a new version (edit) of an existing message
  /// Links to the parent via parentHash
  factory CommitMessageModel.edit({
    required CommitMessageModel parent,
    required String newPayload,
  }) {
    final timestamp = DateTime.now();
    final hash = generateHash(newPayload, parent.authorSignature, timestamp);
    
    return CommitMessageModel(
      hash: hash,
      parentHash: parent.hash,
      authorSignature: parent.authorSignature,
      payload: newPayload,
      timestamp: timestamp,
      clanId: parent.clanId,
      commitType: CommitType.edit,
    );
  }

  /// Generates a short hash (first 7 characters) like Git
  String get shortHash => hash.substring(0, 7);

  /// Gets the author username from the signature
  String get author {
    // Extract username from "username <email>" or just "username"
    final match = RegExp(r'^([^\<]+)').firstMatch(authorSignature);
    return match?.group(1)?.trim() ?? authorSignature;
  }

  /// Checks if this commit is an edit of another
  bool get isEdit => commitType == CommitType.edit && parentHash != null;

  /// Checks if this commit has multiple parents (merge)
  bool get isMerge => parentHashes != null && parentHashes!.length > 1;

  /// Creates a copy of this model with updated fields
  CommitMessageModel copyWith({
    String? hash,
    String? parentHash,
    String? authorSignature,
    String? payload,
    DateTime? timestamp,
    List<String>? parentHashes,
    String? clanId,
    CommitType? commitType,
    bool? isVerified,
  }) {
    return CommitMessageModel(
      hash: hash ?? this.hash,
      parentHash: parentHash ?? this.parentHash,
      authorSignature: authorSignature ?? this.authorSignature,
      payload: payload ?? this.payload,
      timestamp: timestamp ?? this.timestamp,
      parentHashes: parentHashes ?? this.parentHashes,
      clanId: clanId ?? this.clanId,
      commitType: commitType ?? this.commitType,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  String toString() {
    return 'Commit $shortHash\n'
        'Author: $authorSignature\n'
        'Date: ${timestamp.toIso8601String()}\n'
        '\n'
        '    $payload';
  }
}

/// Types of commits in the system
enum CommitType {
  /// Regular message/post
  message,
  
  /// Edit of a previous message
  edit,
  
  /// System message (e.g., user joined, permissions changed)
  system,
  
  /// Merge of multiple threads
  merge,
}
