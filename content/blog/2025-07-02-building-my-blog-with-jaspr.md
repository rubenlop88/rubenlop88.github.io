---
title: "Building my blog with Jaspr"
keywords: [ "jaspr", "blog" ]
author: "Ruben Lopez"
date: "02 July 2025"
readTime: "5 min"
authorImage: https://avatars.githubusercontent.com/u/810004?s=96&v=4
tags: [ "Dart", "Jaspr", "Blog" ]
layout: blog
---

<DropCap />
I've been a software engineer for more than 15 years now and I always wanted 
to have my own website and blog, but I never had the courage to actually do
it. I used to think that I didn't have anything useful to say. But after so many 
years I realize now that the real problem was that I was never passionate enough 
about a topic in particular to actually take the time and write about it.

In the past few years, however, I've been working as a full-time mobile engineer 
for the first time in my career. I've been writing Android applications since 2011, 
but I never had a full-time job to do it. In 2022, I got a job as a Flutter
developer, and even though I had never touched Flutter until then, I knew it
was something I wanted to learn. What I didn't know was that it would become
a passion for me. I have the chance to work on many interesting problems that 
other people might be facing too. That's what finally convinced me to create 
this blog, so I can share with others what I've learned.

# Choosing Jaspr

I used to have a webpage deployed on GitHub Pages using a Jekyll template, It was
OK, but I wasn't interested in that technology, so for this new blog I wanted to
try something new, something in Dart. The most interesting option for me was 
[Jaspr](https://jaspr.site/). It has a really nice [documentation](https://docs.jaspr.site/) 
and a specific [package](https://docs.jaspr.site/content) to create blogs like this. 
Another essential reason to choose Jaspr was being able to put Flutter apps as part 
of the content of a post.

I followed the documentation to [create a new site](https://docs.jaspr.site/get_started/quick_start), 
[add `jaspr_content` to it](https://docs.jaspr.site/content/quick_start) and 
[deploy it](https://docs.jaspr.site/concepts/deploying#github-pages) to GitHub Pages,
almost everything worked right out of the box, excpet for one thing, I couldn't get the 
Flutter embedded widget to work.

# Embedding Flutter

After going through the documentation more carefully, I realized that I was missing a few
document headers to make it work. This is the final code that worked for me:

```dart
runApp(
  Document(
    head: [
      link(rel: 'manifest', href: 'manifest.json'),
      script(src: "flutter_bootstrap.js", async: true, []),
    ],
    body: ContentApp(...),
  ),
);
```

With this configuration I can include Flutter apps in my posts, like this one:

<EmbeddedCounter />

The entire site is statically generated, but this Flutter app in particular is run entirely
on the client side. Here's how to do it:

First, define the Flutter widget, for example:

```dart
import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF01589B)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => setState(() => count--),
            ),
            const SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Flutter Counter'),
                Text('${count}', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 5),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => setState(() => count++),
            ),
          ],
        ),
      ),
    );
  }
}
```

Then, define a corresponding Jaspr component like this:

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_flutter_embed/jaspr_flutter_embed.dart';

// The flutter widget is only imported on the web (as the server cannot import flutter)
// and is imported as a deferred library, to not block hydration of the remaining website.
@Import.onWeb('../widgets/counter.dart', show: [#CounterWidget])
import 'embedded_counter.imports.dart' deferred as counter;

@client
class EmbeddedCounter extends StatelessComponent {
  const EmbeddedCounter({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield FlutterEmbedView.deferred(
      styles: Styles(margin: Margin.only(top: 2.rem)),
      // We need to set constraints as the flutter view cannot dynamically size itself.
      constraints: ViewConstraints(
        minWidth: 300,
        minHeight: 100,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
      ),
      // The [FlutterEmbedView.deferred] component will take care of loading
      // the widget and initializing flutter.
      loadLibrary: counter.loadLibrary(),
      builder: () => counter.CounterWidget(),
    );
  }
}
```

Finally, include the component in the `ContentApp` configuration like this:

```dart
runApp(
  Document(
    ...,
    body: ContentApp(
      ...
      components: [
        ...
        CustomComponent(
          pattern: 'EmbeddedCounter',
          builder: (name, attributes, child) => EmbeddedCounter(),
        ),
      ],
    ),
  ),
);
```

With everything set up, you can now include the widget in any markdown file like this:

```
...
<EmbeddedCounter />
...
```

You can see the full code of this site in my [GitHub repository](https://github.com/rubenlop88/rubenlop88.github.io)

# What's missing in Jaspr

While Jaspr is a great framework, it still has some limitations compared to using 
a dedicated blogging platform like WordPress or HashNode. For example, it doesn't 
have a built-in commenting system or upvoting system. But in my case that's not a 
problem.

# Conclusion

Writing about something you love forces you to think about it and really 
understand it to be able to communicate it to other people in the simplest
terms possible. For me, writing about Flutter and Dart means that I can 
become a better developer, and in the process I can help other people to do
the same. With the help of Jaspr and Flutter embedded widgets, I hope to do 
just that.

