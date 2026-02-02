/// UsernameClaimLog represents a blockchain/git-log style record of username claims.
/// Each claim is immutable and publicly visible with timestamp and verification.
class UsernameClaimLog {
  /// Unique claim ID (hash)
  final String claimHash;
  
  /// The username being claimed
  final String username;
  
  /// Public key or identifier of the claimer
  final String claimerPublicKey;
  
  /// When the claim was made
  final DateTime timestamp;
  
  /// Hash of the previous claim in the chain
  final String? previousClaimHash;
  
  /// Cryptographic signature of this claim
  final String signature;
  
  /// Verification status
  final bool isVerified;
  
  /// Additional metadata
  final Map<String, dynamic>? metadata;

  UsernameClaimLog({
    required this.claimHash,
    required this.username,
    required this.claimerPublicKey,
    required this.timestamp,
    this.previousClaimHash,
    required this.signature,
    this.isVerified = false,
    this.metadata,
  });

  factory UsernameClaimLog.fromJson(Map<String, dynamic> json) {
    return UsernameClaimLog(
      claimHash: json['claim_hash'] as String,
      username: json['username'] as String,
      claimerPublicKey: json['claimer_public_key'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      previousClaimHash: json['previous_claim_hash'] as String?,
      signature: json['signature'] as String,
      isVerified: json['is_verified'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'claim_hash': claimHash,
      'username': username,
      'claimer_public_key': claimerPublicKey,
      'timestamp': timestamp.toIso8601String(),
      'previous_claim_hash': previousClaimHash,
      'signature': signature,
      'is_verified': isVerified,
      'metadata': metadata,
    };
  }

  /// Short hash for display (git-style)
  String get shortHash => claimHash.substring(0, 8);

  @override
  String toString() {
    return 'Claim $shortHash\n'
        'Username: @$username\n'
        'Claimer: ${claimerPublicKey.substring(0, 16)}...\n'
        'Date: ${timestamp.toIso8601String()}\n'
        'Verified: ${isVerified ? "✓" : "✗"}';
  }
}

/// Service for managing username claims
class UsernameClaimService {
  /// In-memory storage of claims (in production, use a database)
  final List<UsernameClaimLog> _claimChain = [];
  
  /// Map of username to claim for quick lookup
  final Map<String, UsernameClaimLog> _usernameToClaim = {};

  /// Adds a new claim to the chain
  Future<UsernameClaimLog> claimUsername({
    required String username,
    required String publicKey,
    required String signature,
  }) async {
    // Check if username is already claimed
    if (_usernameToClaim.containsKey(username.toLowerCase())) {
      throw UsernameAlreadyClaimedException(username);
    }

    final timestamp = DateTime.now();
    final previousHash = _claimChain.isEmpty ? null : _claimChain.last.claimHash;
    
    // Generate claim hash
    final claimData = '$username$publicKey${timestamp.millisecondsSinceEpoch}$previousHash';
    final claimHash = _generateHash(claimData);

    final claim = UsernameClaimLog(
      claimHash: claimHash,
      username: username,
      claimerPublicKey: publicKey,
      timestamp: timestamp,
      previousClaimHash: previousHash,
      signature: signature,
      isVerified: true, // In production, verify signature
    );

    _claimChain.add(claim);
    _usernameToClaim[username.toLowerCase()] = claim;

    return claim;
  }

  /// Gets the claim for a specific username
  UsernameClaimLog? getClaim(String username) {
    return _usernameToClaim[username.toLowerCase()];
  }

  /// Checks if a username is available
  bool isAvailable(String username) {
    return !_usernameToClaim.containsKey(username.toLowerCase());
  }

  /// Gets all claims (the full chain)
  List<UsernameClaimLog> getAllClaims() {
    return List.unmodifiable(_claimChain);
  }

  /// Gets recent claims (last N)
  List<UsernameClaimLog> getRecentClaims(int count) {
    final start = _claimChain.length - count;
    return _claimChain.sublist(start.clamp(0, _claimChain.length));
  }

  /// Verifies the integrity of the claim chain
  bool verifyChain() {
    if (_claimChain.isEmpty) return true;

    for (int i = 1; i < _claimChain.length; i++) {
      final current = _claimChain[i];
      final previous = _claimChain[i - 1];

      if (current.previousClaimHash != previous.claimHash) {
        return false; // Chain is broken
      }
    }

    return true;
  }

  String _generateHash(String data) {
    // Simple hash for demonstration
    // In production, use crypto library
    return data.hashCode.toRadixString(16).padLeft(64, '0');
  }
}

/// Exception thrown when a username is already claimed
class UsernameAlreadyClaimedException implements Exception {
  final String username;

  UsernameAlreadyClaimedException(this.username);

  @override
  String toString() => 'Username "@$username" is already claimed';
}
