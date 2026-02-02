import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/github-dark.dart';

/// SyntaxHighlighterService provides code block rendering with syntax highlighting
/// for various programming languages. Integrates with flutter_highlight package.
class SyntaxHighlighterService {
  /// Default theme for syntax highlighting (terminal-style)
  static final Map<String, TextStyle> terminalTheme = {
    'root': TextStyle(
      backgroundColor: Color(0xFF161B22),
      color: Color(0xFFC9D1D9),
    ),
    'keyword': TextStyle(color: Color(0xFFFF7B72), fontWeight: FontWeight.bold),
    'built_in': TextStyle(color: Color(0xFFD2A8FF)),
    'type': TextStyle(color: Color(0xFFD2A8FF)),
    'literal': TextStyle(color: Color(0xFF79C0FF)),
    'number': TextStyle(color: Color(0xFF79C0FF)),
    'operator': TextStyle(color: Color(0xFFFF7B72)),
    'punctuation': TextStyle(color: Color(0xFFC9D1D9)),
    'property': TextStyle(color: Color(0xFF79C0FF)),
    'regexp': TextStyle(color: Color(0xFF7EE787)),
    'string': TextStyle(color: Color(0xFFA5D6FF)),
    'char.escape': TextStyle(color: Color(0xFF79C0FF)),
    'subst': TextStyle(color: Color(0xFFC9D1D9)),
    'symbol': TextStyle(color: Color(0xFF79C0FF)),
    'variable': TextStyle(color: Color(0xFFFFA657)),
    'template-variable': TextStyle(color: Color(0xFFFFA657)),
    'link': TextStyle(color: Color(0xFF79C0FF)),
    'selector-attr': TextStyle(color: Color(0xFFFFA657)),
    'selector-pseudo': TextStyle(color: Color(0xFFFFA657)),
    'attribute': TextStyle(color: Color(0xFF79C0FF)),
    'comment': TextStyle(color: Color(0xFF8B949E), fontStyle: FontStyle.italic),
    'quote': TextStyle(color: Color(0xFF8B949E), fontStyle: FontStyle.italic),
    'meta': TextStyle(color: Color(0xFF8B949E)),
    'meta-keyword': TextStyle(color: Color(0xFF8B949E)),
    'meta-string': TextStyle(color: Color(0xFFA5D6FF)),
    'section': TextStyle(color: Color(0xFF79C0FF), fontWeight: FontWeight.bold),
    'name': TextStyle(color: Color(0xFFD2A8FF)),
    'tag': TextStyle(color: Color(0xFF7EE787)),
    'title': TextStyle(color: Color(0xFFD2A8FF)),
    'emphasis': TextStyle(fontStyle: FontStyle.italic),
    'strong': TextStyle(fontWeight: FontWeight.bold),
  };

  /// Supported programming languages
  static const List<String> supportedLanguages = [
    'dart',
    'rust',
    'javascript',
    'typescript',
    'python',
    'java',
    'cpp',
    'c',
    'go',
    'ruby',
    'php',
    'swift',
    'kotlin',
    'scala',
    'shell',
    'bash',
    'sql',
    'json',
    'yaml',
    'xml',
    'html',
    'css',
    'markdown',
  ];

  /// Renders a code block with syntax highlighting
  static Widget renderCodeBlock({
    required String code,
    required String language,
    bool showLineNumbers = true,
    TextStyle? textStyle,
  }) {
    return HighlightView(
      code,
      language: _normalizeLanguage(language),
      theme: terminalTheme,
      padding: EdgeInsets.all(12),
      textStyle: textStyle ?? TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
      ),
    );
  }

  /// Normalizes language identifiers (handles aliases)
  static String _normalizeLanguage(String language) {
    final normalized = language.toLowerCase().trim();
    
    switch (normalized) {
      case 'js':
        return 'javascript';
      case 'ts':
        return 'typescript';
      case 'py':
        return 'python';
      case 'sh':
      case 'zsh':
        return 'bash';
      case 'c++':
        return 'cpp';
      case 'yml':
        return 'yaml';
      case 'rs':
        return 'rust';
      default:
        return normalized;
    }
  }

  /// Detects language from code content (basic heuristics)
  static String detectLanguage(String code) {
    // Remove leading/trailing whitespace
    final trimmed = code.trim();
    
    // Check for shebang
    if (trimmed.startsWith('#!')) {
      if (trimmed.contains('python')) return 'python';
      if (trimmed.contains('node')) return 'javascript';
      if (trimmed.contains('bash') || trimmed.contains('sh')) return 'bash';
      if (trimmed.contains('ruby')) return 'ruby';
    }
    
    // Check for language-specific patterns
    if (trimmed.contains('fn main()') || trimmed.contains('let mut ')) {
      return 'rust';
    }
    if (trimmed.contains('class ') && trimmed.contains('extends Widget')) {
      return 'dart';
    }
    if (trimmed.contains('public static void main')) {
      return 'java';
    }
    if (trimmed.contains('def ') && trimmed.contains(':')) {
      return 'python';
    }
    if (trimmed.contains('function ') || trimmed.contains('const ') || 
        trimmed.contains('let ') || trimmed.contains('=>')) {
      return 'javascript';
    }
    if (trimmed.contains('package main') || trimmed.contains('func ')) {
      return 'go';
    }
    
    // Default fallback
    return 'text';
  }

  /// Creates a code block widget with header showing language
  static Widget codeBlockWithHeader({
    required String code,
    required String language,
    VoidCallback? onCopy,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF161B22),
        border: Border.all(color: Color(0xFF30363D)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFF0D1117),
              border: Border(
                bottom: BorderSide(color: Color(0xFF30363D)),
              ),
            ),
            child: Row(
              children: [
                Text(
                  language.toUpperCase(),
                  style: TextStyle(
                    color: Color(0xFF8B949E),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Spacer(),
                if (onCopy != null)
                  InkWell(
                    onTap: onCopy,
                    child: Row(
                      children: [
                        Icon(Icons.content_copy, size: 14, color: Color(0xFF8B949E)),
                        SizedBox(width: 4),
                        Text(
                          'COPY',
                          style: TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // Code
          renderCodeBlock(
            code: code,
            language: language,
            showLineNumbers: true,
          ),
        ],
      ),
    );
  }

  /// Extracts code blocks from Markdown text
  static List<CodeBlock> extractCodeBlocks(String markdown) {
    final codeBlocks = <CodeBlock>[];
    final regex = RegExp(r'```(\w+)?\n([\s\S]*?)```', multiLine: true);
    
    for (final match in regex.allMatches(markdown)) {
      final language = match.group(1) ?? 'text';
      final code = match.group(2) ?? '';
      
      codeBlocks.add(CodeBlock(
        code: code.trim(),
        language: language,
        startIndex: match.start,
        endIndex: match.end,
      ));
    }
    
    return codeBlocks;
  }
}

/// Represents a code block extracted from text
class CodeBlock {
  final String code;
  final String language;
  final int startIndex;
  final int endIndex;

  CodeBlock({
    required this.code,
    required this.language,
    required this.startIndex,
    required this.endIndex,
  });
}
