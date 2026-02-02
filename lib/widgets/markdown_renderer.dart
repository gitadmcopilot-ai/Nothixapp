import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../themes/terminal_theme.dart';
import '../services/syntax_highlighter_service.dart';

/// MarkdownRenderer widget renders Markdown content with syntax highlighting
/// for code blocks, following the terminal aesthetic.
class MarkdownRenderer extends StatelessWidget {
  final String content;
  final bool selectable;

  const MarkdownRenderer({
    Key? key,
    required this.content,
    this.selectable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: content,
      selectable: selectable,
      styleSheet: _buildMarkdownStyleSheet(context),
      builders: {
        'code': CodeBlockBuilder(),
      },
      syntaxHighlighter: TerminalSyntaxHighlighter(),
    );
  }

  MarkdownStyleSheet _buildMarkdownStyleSheet(BuildContext context) {
    final theme = Theme.of(context);
    
    return MarkdownStyleSheet(
      a: TextStyle(color: TerminalTheme.primary),
      p: theme.textTheme.bodyLarge,
      code: TextStyle(
        backgroundColor: TerminalTheme.surfaceVariant,
        color: TerminalTheme.warning,
        fontFamily: 'monospace',
        fontSize: 13,
      ),
      h1: theme.textTheme.displaySmall,
      h2: theme.textTheme.headlineMedium,
      h3: theme.textTheme.headlineSmall,
      h4: theme.textTheme.titleLarge,
      h5: theme.textTheme.titleLarge,
      h6: theme.textTheme.titleLarge,
      em: TextStyle(fontStyle: FontStyle.italic),
      strong: TextStyle(fontWeight: FontWeight.bold),
      blockquote: TextStyle(
        color: TerminalTheme.textSecondary,
        fontStyle: FontStyle.italic,
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: TerminalTheme.border, width: 4),
        ),
      ),
      codeblockDecoration: TerminalTheme.codeBlockDecoration,
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: TerminalTheme.divider, width: 1),
        ),
      ),
      listBullet: theme.textTheme.bodyLarge,
      tableBody: theme.textTheme.bodyMedium,
      tableHead: theme.textTheme.titleLarge,
    );
  }
}

/// Custom syntax highlighter for terminal theme
class TerminalSyntaxHighlighter extends SyntaxHighlighter {
  @override
  TextSpan format(String source) {
    return TextSpan(
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        color: TerminalTheme.textPrimary,
      ),
      text: source,
    );
  }
}

/// Custom builder for code blocks
class CodeBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final language = element.attributes['class']?.replaceFirst('language-', '') ?? 'text';
    final code = element.textContent;
    
    return SyntaxHighlighterService.codeBlockWithHeader(
      code: code,
      language: language,
      onCopy: () {
        // Copy functionality would be implemented here
      },
    );
  }
}
