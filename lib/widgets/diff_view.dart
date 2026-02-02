import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../themes/terminal_theme.dart';
import '../models/commit_message_model.dart';

/// DiffView widget displays git-style diffs between two versions of a message.
/// Shows additions in green and deletions in red, similar to `git diff`.
class DiffView extends StatelessWidget {
  final CommitMessageModel originalCommit;
  final CommitMessageModel editedCommit;
  final bool showFullContent;

  const DiffView({
    Key? key,
    required this.originalCommit,
    required this.editedCommit,
    this.showFullContent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final diff = _computeDiff(
      originalCommit.payload,
      editedCommit.payload,
    );

    return Container(
      decoration: BoxDecoration(
        color: TerminalTheme.surface,
        border: Border.all(color: TerminalTheme.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Diff header (similar to git diff)
          _buildDiffHeader(context),
          Divider(height: 1, color: TerminalTheme.border),
          
          // Diff content
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: diff.map((line) => _buildDiffLine(line)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiffHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      color: TerminalTheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'diff --git ',
                style: TerminalTheme.commitHashStyle,
              ),
              Text(
                'a/${originalCommit.shortHash}',
                style: TerminalTheme.commitHashStyle.copyWith(
                  color: TerminalTheme.error,
                ),
              ),
              Text(
                ' b/${editedCommit.shortHash}',
                style: TerminalTheme.commitHashStyle.copyWith(
                  color: TerminalTheme.success,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                'index ${originalCommit.shortHash}..${editedCommit.shortHash}',
                style: TerminalTheme.timestampStyle,
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                '--- a/${originalCommit.shortHash}',
                style: TextStyle(
                  color: TerminalTheme.error,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '+++ b/${editedCommit.shortHash}',
                style: TextStyle(
                  color: TerminalTheme.success,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiffLine(DiffLine line) {
    Color? bgColor;
    Color? textColor;
    String prefix = ' ';

    switch (line.type) {
      case DiffLineType.added:
        bgColor = TerminalTheme.diffAddedBg;
        textColor = TerminalTheme.diffAdded;
        prefix = '+';
        break;
      case DiffLineType.removed:
        bgColor = TerminalTheme.diffRemovedBg;
        textColor = TerminalTheme.diffRemoved;
        prefix = '-';
        break;
      case DiffLineType.unchanged:
        textColor = TerminalTheme.textSecondary;
        prefix = ' ';
        break;
    }

    return Container(
      color: bgColor,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prefix,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              line.content,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DiffLine> _computeDiff(String original, String edited) {
    final originalLines = original.split('\n');
    final editedLines = edited.split('\n');
    final diff = <DiffLine>[];

    // Simple line-by-line diff (for production, use a proper diff algorithm)
    // This is a simplified Myers diff implementation
    
    int i = 0, j = 0;
    
    while (i < originalLines.length || j < editedLines.length) {
      if (i >= originalLines.length) {
        // Only additions remain
        diff.add(DiffLine(
          type: DiffLineType.added,
          content: editedLines[j],
        ));
        j++;
      } else if (j >= editedLines.length) {
        // Only deletions remain
        diff.add(DiffLine(
          type: DiffLineType.removed,
          content: originalLines[i],
        ));
        i++;
      } else if (originalLines[i] == editedLines[j]) {
        // Lines are the same
        diff.add(DiffLine(
          type: DiffLineType.unchanged,
          content: originalLines[i],
        ));
        i++;
        j++;
      } else {
        // Lines differ - check if it's a replacement or separate add/delete
        if (i + 1 < originalLines.length && originalLines[i + 1] == editedLines[j]) {
          // Next original line matches current edited line (deletion)
          diff.add(DiffLine(
            type: DiffLineType.removed,
            content: originalLines[i],
          ));
          i++;
        } else if (j + 1 < editedLines.length && originalLines[i] == editedLines[j + 1]) {
          // Current original line matches next edited line (addition)
          diff.add(DiffLine(
            type: DiffLineType.added,
            content: editedLines[j],
          ));
          j++;
        } else {
          // Lines are different (replacement)
          diff.add(DiffLine(
            type: DiffLineType.removed,
            content: originalLines[i],
          ));
          diff.add(DiffLine(
            type: DiffLineType.added,
            content: editedLines[j],
          ));
          i++;
          j++;
        }
      }
    }

    return diff;
  }
}

/// Represents a line in a diff
class DiffLine {
  final DiffLineType type;
  final String content;

  DiffLine({
    required this.type,
    required this.content,
  });
}

/// Types of diff lines
enum DiffLineType {
  added,
  removed,
  unchanged,
}

/// Compact diff indicator widget (shows +X/-Y)
class DiffIndicator extends StatelessWidget {
  final int additions;
  final int deletions;

  const DiffIndicator({
    Key? key,
    required this.additions,
    required this.deletions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (additions > 0) ...[
          Text(
            '+$additions',
            style: TextStyle(
              color: TerminalTheme.success,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          SizedBox(width: 4),
        ],
        if (deletions > 0) ...[
          Text(
            '-$deletions',
            style: TextStyle(
              color: TerminalTheme.error,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ],
    );
  }

  static DiffIndicator fromCommits(
    CommitMessageModel original,
    CommitMessageModel edited,
  ) {
    final originalLines = original.payload.split('\n');
    final editedLines = edited.payload.split('\n');
    
    int additions = 0;
    int deletions = 0;
    
    // Simple counting (for production, use proper diff)
    for (final line in editedLines) {
      if (!originalLines.contains(line)) {
        additions++;
      }
    }
    
    for (final line in originalLines) {
      if (!editedLines.contains(line)) {
        deletions++;
      }
    }
    
    return DiffIndicator(
      additions: additions,
      deletions: deletions,
    );
  }
}

/// Dialog showing full diff view
class DiffViewDialog extends StatelessWidget {
  final CommitMessageModel originalCommit;
  final CommitMessageModel editedCommit;

  const DiffViewDialog({
    Key? key,
    required this.originalCommit,
    required this.editedCommit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TerminalTheme.background,
      child: Container(
        constraints: BoxConstraints(maxWidth: 800, maxHeight: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TerminalTheme.surface,
                border: Border(
                  bottom: BorderSide(color: TerminalTheme.border),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.difference, color: TerminalTheme.primary),
                  SizedBox(width: 8),
                  Text(
                    'Message Diff',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Diff content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: DiffView(
                  originalCommit: originalCommit,
                  editedCommit: editedCommit,
                  showFullContent: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
