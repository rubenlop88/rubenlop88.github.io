import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/components/callout.dart';
import 'package:jaspr_content/components/code_block.dart';
import 'package:source/components/counter.dart';
import 'package:source/components/embedded_counter.dart';

import 'jaspr_options.dart';

void main() {
  Jaspr.initializeApp(options: defaultJasprOptions);

  runApp(
    Document(
      title: 'source',
      styles: [
        // Special import rule to include to another css file.
        css.import('https://fonts.googleapis.com/css?family=Roboto'),
        // Each style rule takes a valid css selector and a set of styles.
        // Styles are defined using type-safe css bindings and can be freely chained and nested.
        css('html, body').styles(
          width: 100.percent,
          minHeight: 100.vh,
          padding: Padding.zero,
          margin: Margin.zero,
          fontFamily: const FontFamily.list(
              [FontFamily('Roboto'), FontFamilies.sansSerif]),
        ),
        css('h1').styles(
          margin: Margin.unset,
          fontSize: 4.rem,
        ),
      ],
      head: [
        // The generated flutter manifest and bootstrap script.
        link(rel: 'manifest', href: 'manifest.json'),
        script(src: "flutter_bootstrap.js", async: true, []),
      ],
      body: ContentApp(
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
    ),
  );
}
