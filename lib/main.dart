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
      head: [
        link(rel: 'manifest', href: 'manifest.json'),
        script(src: "flutter_bootstrap.js", async: true, []),
      ],
      body: ContentApp(
        parsers: [MarkdownParser()],
        layouts: [
          DocsLayout(
            header: Header(
              title: 'Ruben Lopez',
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
