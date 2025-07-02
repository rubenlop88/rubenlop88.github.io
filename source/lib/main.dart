import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/components/callout.dart';
import 'package:jaspr_content/components/code_block.dart';
import 'package:source/components/counter.dart';
import 'package:source/components/embedded_counter.dart';

import 'jaspr_options.dart';

void main() {
  Jaspr.initializeApp(options: defaultJasprOptions);

  runApp(
    ContentApp(
      parsers: [MarkdownParser()],
      components: [
        Callout(), // Callout boxes, like <Info>, <Warning>, <Success> and <Error>
        CodeBlock(), // Code block with syntax highlighting and copy button
        CustomComponent(
          pattern: 'Counter',
          builder: (name, attributes, child) => Counter(),
        ),
        CustomComponent(
          pattern: 'EmbeddedCounter',
          builder: (name, attributes, child) => EmbeddedCounter(),
        ),
      ],
    ),
  );
}
