# UI Design Overview

This document provides a visual representation of the Nothixapp user interface.

## Terminal Aesthetic

The entire UI follows a dark-mode terminal aesthetic with:
- **Background**: `#0D1117` (GitHub dark)
- **Surface**: `#161B22` (GitHub dark surface)
- **Text**: `#C9D1D9` (Light gray)
- **Primary**: `#58A6FF` (Blue)
- **Success**: `#3FB950` (Green)
- **Error**: `#F85149` (Red)
- **Monospace Font**: JetBrains Mono

## Main Screen Layout

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ ❯ Nothixapp          #general                          [?]  ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                                             ┃
┃  ┌─────────────────────────────────────────────────────┐   ┃
┃  │ alice   8a3f92b                        2 hours ago  │   ┃
┃  ├─────────────────────────────────────────────────────┤   ┃
┃  │ # Welcome to Nothixapp!                             │   ┃
┃  │                                                      │   ┃
┃  │ This is a **Git-centric** social platform.          │   ┃
┃  │                                                      │   ┃
┃  │ ```rust                                             │   ┃
┃  │ fn main() {                                         │   ┃
┃  │     println!("Hello, Nothixapp!");                  │   ┃
┃  │ }                                                    │   ┃
┃  │ ```                                                  │   ┃
┃  └─────────────────────────────────────────────────────┘   ┃
┃                                                             ┃
┃  ┌─────────────────────────────────────────────────────┐   ┃
┃  │ bob     1f2e9a3                        1 hour ago   │   ┃
┃  ├─────────────────────────────────────────────────────┤   ┃
┃  │ Great platform! Let me share some Python:           │   ┃
┃  │                                                      │   ┃
┃  │ ```python                                           │   ┃
┃  │ def greet(name):                                    │   ┃
┃  │     print(f"Hello, {name}!")                        │   ┃
┃  │ ```                                                  │   ┃
┃  └─────────────────────────────────────────────────────┘   ┃
┃                                                             ┃
┃  ┌─────────────────────────────────────────────────────┐   ┃
┃  │ alice   7bc4d8f                        30 min ago   │   ┃
┃  ├─────────────────────────────────────────────────────┤   ┃
┃  │ Thanks! Check out the diff view with /diff          │   ┃
┃  └─────────────────────────────────────────────────────┘   ┃
┃                                                             ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃  ❯ Type a command or message...                        [>] ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

## Message Card Structure

```
┌─────────────────────────────────────────────────┐
│ ┌─────────────────────────────────────────────┐ │  ← Header (surfaceVariant)
│ │ alice   8a3f92b            2 hours ago      │ │
│ │ ▲       ▲                  ▲                │ │
│ │ author  hash              timestamp         │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│  Message content rendered as Markdown           │  ← Content area
│  with full syntax highlighting                  │
│                                                 │
│ ┌─────────────────────────────────────────────┐ │  ← Edit indicator (if edited)
│ │ ✏ Edited (parent: 1a2b3c4)                  │ │
│ └─────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────┘
```

## Code Block Display

```
┌─────────────────────────────────────────────────┐
│ RUST                                      COPY  │  ← Language header
├─────────────────────────────────────────────────┤
│ fn main() {                                     │  ← Syntax highlighted code
│     println!("Hello, Nothixapp!");              │
│ }                                               │
└─────────────────────────────────────────────────┘
```

## Diff View

```
┌─────────────────────────────────────────────────┐
│ diff --git a/8a3f92b b/7bc4d8f                  │  ← Git-style header
│ index 8a3f92b..7bc4d8f                          │
│ --- a/8a3f92b                                   │
│ +++ b/7bc4d8f                                   │
├─────────────────────────────────────────────────┤
│ - Old line of text                              │  ← Red background
│ + New line of text                              │  ← Green background
│   Unchanged line                                │  ← Normal
└─────────────────────────────────────────────────┘
```

## Command Help Dialog

```
┌─────────────────────────────────────────────────┐
│ Available Commands                           [×]│
├─────────────────────────────────────────────────┤
│                                                 │
│  /join          Join a clan                     │
│                 Aliases: none                   │
│                                                 │
│  /leave         Leave the current clan          │
│                 Aliases: none                   │
│                                                 │
│  /shrug         Insert ¯\_(ツ)_/¯               │
│                 Aliases: /shruggie              │
│                                                 │
│  /edit          Edit your last message          │
│                 Aliases: none                   │
│                                                 │
│  /diff          Show diff of a message          │
│                 Aliases: none                   │
│                                                 │
│  /log           Show message history            │
│                 Aliases: none                   │
│                                                 │
│  /claim         Claim a username                │
│                 Aliases: none                   │
│                                                 │
│  /help          Show available commands         │
│                 Aliases: /h, /?                 │
│                                                 │
├─────────────────────────────────────────────────┤
│                                         [CLOSE] │
└─────────────────────────────────────────────────┘
```

## Git Log View

```
┌─────────────────────────────────────────────────┐
│ Message Log (git log style)                 [×]│
├─────────────────────────────────────────────────┤
│                                                 │
│ commit 7bc4d8f9e3a1b2c4d5e6f7a8b9c0d1e2f3a4b5c6│
│ Author: alice <alice@developers.io>             │
│ Date: Mon Feb 2 23:17:42 2024                   │
│                                                 │
│     Updated the welcome message                 │
│                                                 │
│ ────────────────────────────────────────────────│
│                                                 │
│ commit 8a3f92b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7│
│ parent 1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b│
│ Author: alice <alice@developers.io>             │
│ Date: Mon Feb 2 21:15:30 2024                   │
│                                                 │
│     Welcome to Nothixapp!                       │
│                                                 │
│ ────────────────────────────────────────────────│
│                                                 │
└─────────────────────────────────────────────────┘
```

## Command Line Interface Features

### Normal Mode
```
❯ Type a command or message...                [>]
```

### Command Mode (typing /command)
```
❯ /join rust-devs                             [>]
```

### History Navigation (arrow keys)
```
❯ /help                                       [>]
  ↑ Previous: /log
  ↓ Next: /join rust-devs
```

## Clan Role Indicators

```
★ alice       Maintainer
● bob         Contributor  
○ charlie     Viewer
```

## Color Coding

### Status Colors
- **Success/Added**: `#3FB950` (Green) - For additions, success messages
- **Error/Removed**: `#F85149` (Red) - For deletions, errors
- **Warning**: `#D29922` (Yellow) - For commit hashes, warnings
- **Info**: `#58A6FF` (Blue) - For links, commands, primary actions

### Text Hierarchy
- **Primary Text**: `#C9D1D9` (Light gray) - Main content
- **Secondary Text**: `#8B949E` (Gray) - Metadata, timestamps
- **Muted Text**: `#6E7681` (Dark gray) - Hints, placeholders

### Backgrounds
- **Background**: `#0D1117` (Darkest) - Main background
- **Surface**: `#161B22` (Dark) - Cards, panels
- **Surface Variant**: `#21262D` (Medium) - Headers, inputs
- **Diff Added**: `#1B2E20` (Green tint) - Added line background
- **Diff Removed**: `#3D1F1F` (Red tint) - Removed line background

## Typography

All text uses **JetBrains Mono** (monospace):

```
Display Large:   32px, Bold     - Large headers
Display Medium:  28px, Bold     - Medium headers
Display Small:   24px, Bold     - Small headers
Headline Medium: 20px, SemiBold - Section headers
Headline Small:  18px, SemiBold - Subsection headers
Title Large:     16px, SemiBold - Card titles
Body Large:      14px, Regular  - Main content
Body Medium:     12px, Regular  - Secondary content
Body Small:      11px, Regular  - Metadata
```

## Interactive Elements

### Buttons
```
┌─────────────┐
│   BUTTON    │  ← Primary: Blue background
└─────────────┘

┌─────────────┐
│   BUTTON    │  ← Secondary: Transparent with border
└─────────────┘
```

### Input Fields
```
┌─────────────────────────────────────┐
│ Placeholder text...                 │  ← Muted text
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ User input                          │  ← Primary text
└─────────────────────────────────────┘ (focused: blue border)
```

## Responsive Layout

### Desktop (>800px)
- Full width message cards
- Side-by-side diff views
- Large code blocks

### Tablet (600-800px)
- Adjusted card padding
- Stacked diff views
- Medium code blocks

### Mobile (<600px)
- Compact card layout
- Scrollable code blocks
- Touch-optimized commands

## Animations

All interactions use subtle terminal-style animations:
- **Message appear**: Fade in from top (200ms)
- **Command submit**: Slight scale effect (150ms)
- **Dialog open**: Slide down (250ms)
- **Diff expand**: Height transition (300ms)

## Accessibility

- **High Contrast**: Minimum 4.5:1 ratio
- **Keyboard Navigation**: Full support
- **Screen Readers**: Semantic HTML
- **Focus Indicators**: Clear blue outline

## Terminal Cursor

The CLI uses a pulsing cursor effect:
```
❯ Type here|
           ^ Pulsing vertical bar (1s interval)
```

## Icon Set

Uses Material Icons with terminal aesthetic:
- `terminal` - App icon
- `content_copy` - Copy code
- `help_outline` - Help
- `send` - Send message
- `edit` - Edit message
- `difference` - Diff view
- `history` - Log view
- `close` - Close dialogs

## Summary

The UI is designed to feel like a modern terminal emulator with:
1. **Monospace typography** throughout
2. **Dark mode only** with high contrast
3. **Git-inspired** visual elements
4. **Developer-friendly** interactions
5. **Terminal commands** as primary input method

Every element reinforces the "Git-centric" nature of the platform while maintaining a clean, professional appearance.
