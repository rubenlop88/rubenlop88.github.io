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
