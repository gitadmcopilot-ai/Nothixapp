import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:typed_data';

/// Utilities for cryptographic operations in the Git-centric social platform
class CryptoUtils {
  /// Generates a SHA-256 hash of the given data
  static String sha256Hash(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generates a short hash (first N characters)
  static String shortHash(String fullHash, {int length = 7}) {
    return fullHash.substring(0, length.clamp(0, fullHash.length));
  }

  /// Generates a deterministic hash from multiple inputs
  static String combineHash(List<String> inputs) {
    final combined = inputs.join('');
    return sha256Hash(combined);
  }

  /// Generates a commit-style hash from message content
  static String generateCommitHash({
    required String content,
    required String author,
    required DateTime timestamp,
    String? parentHash,
  }) {
    final data = StringBuffer();
    data.write('content:$content\n');
    data.write('author:$author\n');
    data.write('timestamp:${timestamp.millisecondsSinceEpoch}\n');
    if (parentHash != null) {
      data.write('parent:$parentHash\n');
    }
    
    return sha256Hash(data.toString());
  }
}

/// Time formatting utilities for git-log style output
class TimeUtils {
  /// Formats timestamp in git-log style
  static String formatGitStyle(DateTime timestamp) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    final weekday = weekdays[timestamp.weekday - 1];
    final month = months[timestamp.month - 1];
    final day = timestamp.day;
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    final year = timestamp.year;
    
    return '$weekday $month $day $hour:$minute:$second $year';
  }

  /// Formats relative time (e.g., "2 hours ago")
  static String formatRelative(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds} seconds ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return '$weeks weeks ago';
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return '$months months ago';
    } else {
      final years = (diff.inDays / 365).floor();
      return '$years years ago';
    }
  }
}

/// String utilities for terminal-style formatting
class StringUtils {
  /// Truncates text to a maximum length with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  /// Extracts username from signature (handles "username <email>" format)
  static String extractUsername(String signature) {
    final match = RegExp(r'^([^<]+)').firstMatch(signature);
    return match?.group(1)?.trim() ?? signature;
  }

  /// Extracts email from signature
  static String? extractEmail(String signature) {
    final match = RegExp(r'<([^>]+)>').firstMatch(signature);
    return match?.group(1);
  }

  /// Converts text to a valid identifier (for clan names, usernames)
  static String toIdentifier(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9_-]'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }
}
