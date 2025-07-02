import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/components/callout.dart';
import 'package:jaspr_content/components/code_block.dart';
import 'package:jaspr_content/components/theme_toggle.dart';
import 'package:jaspr_content/components/github_button.dart';
import 'package:source/components/counter.dart';
import 'package:source/components/embedded_counter.dart';
import 'package:jaspr_content/theme.dart';

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
        layouts: [
          DocsLayout(
            header: Header(
              title: 'Jaspr',
              logo:
                  'https://raw.githubusercontent.com/schultek/jaspr/refs/heads/main/assets/logo.png',
              items: [
                ThemeToggle(),
                GithubButton(repo: 'schultek/jaspr'),
              ],
            ),
            sidebar: Sidebar(groups: [
              SidebarGroup(
                links: [
                  SidebarLink(text: "Overview", href: '/'),
                ],
              ),
              SidebarGroup(title: 'Get Started', links: [
                SidebarLink(
                    text: "Quickstart", href: '/blog/hello-world'),
                SidebarLink(
                    text: "Installation", href: '/get_started/installation'),
              ]),
            ]),
          ),
          BlogLayout(
            header: Header(
              title: 'Jaspr Blog',
              logo:
                  'https://raw.githubusercontent.com/schultek/jaspr/refs/heads/main/assets/logo.png',
              items: [
                ThemeToggle(),
                GithubButton(repo: 'schultek/jaspr'),
              ],
            ),
          ),
        ],
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
