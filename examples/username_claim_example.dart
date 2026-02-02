/// Example: Username Claim System
/// This file demonstrates how to use the UsernameClaimLog

import 'package:nothixapp/models/username_claim_log.dart';

void main() async {
  final service = UsernameClaimService();

  // Example 1: Claim usernames
  print('=== Example 1: Claiming Usernames ===');
  
  try {
    final claim1 = await service.claimUsername(
      username: 'alice',
      publicKey: 'ed25519:AAAA1111BBBB2222CCCC3333DDDD4444',
      signature: 'signature_alice_claim',
    );
    print('Claimed: @${claim1.username}');
    print('Hash: ${claim1.claimHash}');
    print('Short Hash: ${claim1.shortHash}');
    print('Timestamp: ${claim1.timestamp}');
    print('Verified: ${claim1.isVerified ? "✓" : "✗"}');
    print('\n');

    final claim2 = await service.claimUsername(
      username: 'bob',
      publicKey: 'ed25519:EEEE5555FFFF6666GGGG7777HHHH8888',
      signature: 'signature_bob_claim',
    );
    print('Claimed: @${claim2.username}');
    print('Hash: ${claim2.claimHash}');
    print('Previous claim: ${claim2.previousClaimHash?.substring(0, 8)}');
    print('\n');

    final claim3 = await service.claimUsername(
      username: 'charlie',
      publicKey: 'ed25519:IIII9999JJJJ0000KKKK1111LLLL2222',
      signature: 'signature_charlie_claim',
    );
    print('Claimed: @${claim3.username}');
    print('Hash: ${claim3.claimHash}');
    print('Previous claim: ${claim3.previousClaimHash?.substring(0, 8)}');
    print('\n');

  } catch (e) {
    print('Error: $e');
  }

  // Example 2: Check username availability
  print('=== Example 2: Check Availability ===');
  final usernames = ['alice', 'bob', 'charlie', 'dave', 'eve'];
  
  for (final username in usernames) {
    final available = service.isAvailable(username);
    final status = available ? 'Available ✓' : 'Taken ✗';
    print('@$username: $status');
  }
  print('\n');

  // Example 3: Get specific claim
  print('=== Example 3: Get Claim Details ===');
  final aliceClaim = service.getClaim('alice');
  if (aliceClaim != null) {
    print(aliceClaim.toString());
    print('\n');
  }

  // Example 4: View all claims (the chain)
  print('=== Example 4: View Claim Chain ===');
  final allClaims = service.getAllClaims();
  print('Total claims in chain: ${allClaims.length}');
  print('\nChain structure:');
  
  for (var i = 0; i < allClaims.length; i++) {
    final claim = allClaims[i];
    final prefix = i == 0 ? '├─' : '├─';
    final parentInfo = claim.previousClaimHash != null 
        ? ' → ${claim.previousClaimHash!.substring(0, 8)}'
        : ' (genesis)';
    print('$prefix ${claim.shortHash}: @${claim.username}$parentInfo');
  }
  print('\n');

  // Example 5: Verify chain integrity
  print('=== Example 5: Verify Chain Integrity ===');
  final isValid = service.verifyChain();
  print('Chain is valid: ${isValid ? "✓" : "✗"}');
  
  if (isValid) {
    print('All claims are properly linked');
    print('Chain contains ${allClaims.length} claims');
  }
  print('\n');

  // Example 6: Recent claims
  print('=== Example 6: Recent Claims ===');
  final recentClaims = service.getRecentClaims(2);
  print('Last 2 claims:');
  
  for (final claim in recentClaims) {
    print('- @${claim.username} (${claim.shortHash})');
    print('  Claimed at: ${claim.timestamp}');
  }
  print('\n');

  // Example 7: Try to claim taken username
  print('=== Example 7: Duplicate Claim Attempt ===');
  try {
    await service.claimUsername(
      username: 'alice', // Already claimed
      publicKey: 'ed25519:MMMM3333NNNN4444OOOO5555PPPP6666',
      signature: 'signature_duplicate',
    );
  } catch (e) {
    print('Expected error: $e');
  }
  print('\n');

  // Example 8: JSON serialization
  print('=== Example 8: JSON Serialization ===');
  if (aliceClaim != null) {
    final json = aliceClaim.toJson();
    print('Serialized claim:');
    json.forEach((key, value) {
      print('  $key: $value');
    });
    print('\n');

    final deserialized = UsernameClaimLog.fromJson(json);
    print('Deserialized successfully:');
    print('  Username: ${deserialized.username}');
    print('  Hash: ${deserialized.shortHash}');
  }
}
