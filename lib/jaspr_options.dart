// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/components/_internal/code_block_copy_button.dart'
    as prefix0;
import 'package:jaspr_content/components/callout.dart' as prefix1;
import 'package:jaspr_content/components/code_block.dart' as prefix2;
import 'package:jaspr_content/components/drop_cap.dart' as prefix3;
import 'package:jaspr_content/components/sidebar_toggle_button.dart' as prefix4;
import 'package:source/components/embedded_counter.dart' as prefix5;

/// Default [JasprOptions] for use with your jaspr project.
///
/// Use this to initialize jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'jaspr_options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultJasprOptions,
///   );
///
///   runApp(...);
/// }
/// ```
JasprOptions get defaultJasprOptions => JasprOptions(
  clients: {
    prefix0.CodeBlockCopyButton: ClientTarget<prefix0.CodeBlockCopyButton>(
      'jaspr_content:components/_internal/code_block_copy_button',
    ),

    prefix4.SidebarToggleButton: ClientTarget<prefix4.SidebarToggleButton>(
      'jaspr_content:components/sidebar_toggle_button',
    ),

    prefix5.EmbeddedCounter: ClientTarget<prefix5.EmbeddedCounter>(
      'components/embedded_counter',
    ),
  },
  styles: () => [
    ...prefix1.Callout.styles,
    ...prefix2.CodeBlock.styles,
    ...prefix3.DropCap.styles,
  ],
);
