/// ClanHierarchy models define repository-style permissions for Clans/Teams.
/// Follows Git repository permission patterns: Maintainer, Contributor, Viewer

/// Represents a user's role within a clan
enum ClanRole {
  /// Full access: can manage members, delete posts, change settings
  maintainer,
  
  /// Can create and edit own posts, comment on others
  contributor,
  
  /// Read-only access: can view but not post or comment
  viewer,
}

/// Extension for ClanRole to provide utility methods
extension ClanRoleExtension on ClanRole {
  /// Display name for the role
  String get displayName {
    switch (this) {
      case ClanRole.maintainer:
        return 'Maintainer';
      case ClanRole.contributor:
        return 'Contributor';
      case ClanRole.viewer:
        return 'Viewer';
    }
  }

  /// Icon identifier for the role (terminal-style)
  String get icon {
    switch (this) {
      case ClanRole.maintainer:
        return '★'; // Star for maintainer
      case ClanRole.contributor:
        return '●'; // Dot for contributor
      case ClanRole.viewer:
        return '○'; // Empty dot for viewer
    }
  }

  /// Checks if this role can perform an action
  bool canPerform(ClanPermission permission) {
    switch (this) {
      case ClanRole.maintainer:
        return true; // Maintainers can do everything
      case ClanRole.contributor:
        return permission != ClanPermission.manageClan &&
               permission != ClanPermission.manageMembers &&
               permission != ClanPermission.deleteAnyPost;
      case ClanRole.viewer:
        return permission == ClanPermission.viewPosts ||
               permission == ClanPermission.viewMembers;
    }
  }

  /// Numeric level for comparison (higher = more permissions)
  int get level {
    switch (this) {
      case ClanRole.maintainer:
        return 3;
      case ClanRole.contributor:
        return 2;
      case ClanRole.viewer:
        return 1;
    }
  }
}

/// Available permissions in a clan
enum ClanPermission {
  viewPosts,
  viewMembers,
  createPost,
  editOwnPost,
  deleteOwnPost,
  commentOnPosts,
  deleteAnyPost,
  manageMembers,
  manageClan,
}

/// Represents a clan/team in the platform
class ClanModel {
  /// Unique identifier for the clan (like a repository name)
  final String id;
  
  /// Display name of the clan
  final String name;
  
  /// Description (supports Markdown)
  final String description;
  
  /// Creator/owner of the clan
  final String creator;
  
  /// When the clan was created
  final DateTime createdAt;
  
  /// Clan visibility
  final ClanVisibility visibility;
  
  /// Default role for new members
  final ClanRole defaultRole;

  ClanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.creator,
    required this.createdAt,
    this.visibility = ClanVisibility.public,
    this.defaultRole = ClanRole.viewer,
  });

  factory ClanModel.fromJson(Map<String, dynamic> json) {
    return ClanModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      creator: json['creator'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      visibility: ClanVisibility.values.firstWhere(
        (e) => e.name == json['visibility'],
        orElse: () => ClanVisibility.public,
      ),
      defaultRole: ClanRole.values.firstWhere(
        (e) => e.name == json['default_role'],
        orElse: () => ClanRole.viewer,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creator': creator,
      'created_at': createdAt.toIso8601String(),
      'visibility': visibility.name,
      'default_role': defaultRole.name,
    };
  }
}

/// Clan visibility settings
enum ClanVisibility {
  /// Anyone can view and join
  public,
  
  /// Anyone can view, but needs approval to join
  private,
  
  /// Invite-only, hidden from search
  secret,
}

/// Represents a member's role in a clan
class ClanMember {
  /// Username
  final String username;
  
  /// Role in this clan
  final ClanRole role;
  
  /// When they joined
  final DateTime joinedAt;
  
  /// Who invited/approved them
  final String? invitedBy;

  ClanMember({
    required this.username,
    required this.role,
    required this.joinedAt,
    this.invitedBy,
  });

  factory ClanMember.fromJson(Map<String, dynamic> json) {
    return ClanMember(
      username: json['username'] as String,
      role: ClanRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => ClanRole.viewer,
      ),
      joinedAt: DateTime.parse(json['joined_at'] as String),
      invitedBy: json['invited_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'role': role.name,
      'joined_at': joinedAt.toIso8601String(),
      'invited_by': invitedBy,
    };
  }

  /// Creates a copy with updated role
  ClanMember copyWithRole(ClanRole newRole) {
    return ClanMember(
      username: username,
      role: newRole,
      joinedAt: joinedAt,
      invitedBy: invitedBy,
    );
  }
}
