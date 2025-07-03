import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/callout.dart';
import 'package:jaspr_content/components/code_block.dart';
import 'package:jaspr_content/components/drop_cap.dart';
import 'package:jaspr_content/components/theme_toggle.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:source/components/embedded_counter.dart';

import 'jaspr_options.dart';

void main() {
  Jaspr.initializeApp(options: defaultJasprOptions);

  runApp(
    Document(
      head: [
        link(rel: 'manifest', href: 'manifest.json'),
        script(src: "flutter_bootstrap.js", async: true, []),
      ],
      styles: [
        css('.center').styles(
          display: Display.block,
          width: 50.percent,
          margin: Margin.symmetric(horizontal: Unit.auto),
        ),
        css('.circular').styles(
          radius: BorderRadius.circular(50.percent),
        ),
        css('.row').styles(
          display: Display.flex,
        ),
        css('.column').styles(
          padding: Spacing.all(20.px),
        ),
      ],
      body: ContentApp(
        parsers: [MarkdownParser()],
        layouts: [
          DocsLayout(
            header: Header(
              title: 'Ruben Lopez\'s Flutter Blog',
              logo: 'images/logo.png',
              items: [ThemeToggle()],
            ),
            sidebar: Sidebar(
              groups: [
                SidebarGroup(
                  links: [
                    SidebarLink(text: "Welcome", href: '/'),
                  ],
                ),
                SidebarGroup(
                  title: 'Posts',
                  links: [
                    SidebarLink(
                      text: 'Building my blog with Jaspr',
                      href: '/blog/2025-07-02-building-my-blog-with-jaspr',
                    ),
                  ],
                ),
              ],
            ),
          ),
          BlogLayout(
            header: Header(
              title: 'Ruben Lopez\'s Flutter Blog',
              logo: 'images/logo.png',
              items: [ThemeToggle()],
            ),
          ),
        ],
        components: [
          Callout(),
          CodeBlock(),
          DropCap(),
          CustomComponent(
            pattern: 'EmbeddedCounter',
            builder: (name, attributes, child) => EmbeddedCounter(),
          ),
        ],
      ),
    ),
  );
}
