/// Example: Clan Hierarchy and Permissions
/// This file demonstrates how to use the ClanHierarchy models

import 'package:nothixapp/models/clan_hierarchy_model.dart';

void main() {
  // Example 1: Create a clan
  print('=== Example 1: Creating a Clan ===');
  final clan = ClanModel(
    id: 'rust-devs',
    name: 'Rust Developers',
    description: '''# Rust Developers Clan

A community for Rust programming enthusiasts.

## Rules
1. Be respectful
2. Share knowledge
3. Help others learn

## Topics
- Systems programming
- Web development with Actix/Rocket
- Async programming
- Memory safety
''',
    creator: 'alice',
    createdAt: DateTime.now(),
    visibility: ClanVisibility.public,
    defaultRole: ClanRole.contributor,
  );

  print('Clan ID: ${clan.id}');
  print('Name: ${clan.name}');
  print('Creator: ${clan.creator}');
  print('Visibility: ${clan.visibility.name}');
  print('Default Role: ${clan.defaultRole.displayName}');
  print('\n');

  // Example 2: Clan members with different roles
  print('=== Example 2: Clan Members ===');
  final maintainer = ClanMember(
    username: 'alice',
    role: ClanRole.maintainer,
    joinedAt: DateTime.now(),
  );

  final contributor = ClanMember(
    username: 'bob',
    role: ClanRole.contributor,
    joinedAt: DateTime.now(),
    invitedBy: 'alice',
  );

  final viewer = ClanMember(
    username: 'charlie',
    role: ClanRole.viewer,
    joinedAt: DateTime.now(),
    invitedBy: 'alice',
  );

  final members = [maintainer, contributor, viewer];

  for (final member in members) {
    print('${member.role.icon} ${member.username} - ${member.role.displayName}');
    if (member.invitedBy != null) {
      print('  Invited by: ${member.invitedBy}');
    }
  }
  print('\n');

  // Example 3: Permission checks
  print('=== Example 3: Permission Checks ===');
  final permissions = [
    ClanPermission.viewPosts,
    ClanPermission.createPost,
    ClanPermission.editOwnPost,
    ClanPermission.deleteOwnPost,
    ClanPermission.deleteAnyPost,
    ClanPermission.manageMembers,
    ClanPermission.manageClan,
  ];

  for (final member in members) {
    print('\n${member.username} (${member.role.displayName}):');
    for (final permission in permissions) {
      final can = member.role.canPerform(permission);
      final icon = can ? '✓' : '✗';
      print('  $icon ${permission.name}');
    }
  }
  print('\n');

  // Example 4: Role comparison
  print('=== Example 4: Role Comparison ===');
  print('Maintainer level: ${ClanRole.maintainer.level}');
  print('Contributor level: ${ClanRole.contributor.level}');
  print('Viewer level: ${ClanRole.viewer.level}');
  print('\n');

  print('Can contributor do what maintainer can?');
  print('  ${ClanRole.contributor.level >= ClanRole.maintainer.level}');
  print('\n');

  // Example 5: Changing roles
  print('=== Example 5: Changing Member Roles ===');
  print('Original: ${viewer.username} is a ${viewer.role.displayName}');

  final promoted = viewer.copyWithRole(ClanRole.contributor);
  print('Promoted: ${promoted.username} is now a ${promoted.role.displayName}');
  print('\n');

  // Example 6: Different visibility types
  print('=== Example 6: Clan Visibility Types ===');
  final publicClan = ClanModel(
    id: 'public-clan',
    name: 'Public Clan',
    description: 'Everyone can see and join',
    creator: 'alice',
    createdAt: DateTime.now(),
    visibility: ClanVisibility.public,
  );

  final privateClan = ClanModel(
    id: 'private-clan',
    name: 'Private Clan',
    description: 'Everyone can see, but needs approval to join',
    creator: 'alice',
    createdAt: DateTime.now(),
    visibility: ClanVisibility.private,
  );

  final secretClan = ClanModel(
    id: 'secret-clan',
    name: 'Secret Clan',
    description: 'Invite-only, hidden from search',
    creator: 'alice',
    createdAt: DateTime.now(),
    visibility: ClanVisibility.secret,
  );

  print('Public: ${publicClan.name} - ${publicClan.visibility.name}');
  print('Private: ${privateClan.name} - ${privateClan.visibility.name}');
  print('Secret: ${secretClan.name} - ${secretClan.visibility.name}');
}
