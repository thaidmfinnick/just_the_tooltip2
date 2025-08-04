import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The interface for a tooltip builder. This is useful when the user wants to
/// insert the tooltip into a stack rather than an overlay
typedef TooltipBuilder = Widget Function(
  BuildContext context,
  Widget tooltip,

  /// This widget should be placed behind the tooltip. When tapped, it will
  /// collapse the tooltip. When, isModal is set to false, this will always be
  /// null
  Widget scrim,
);

class InheritedTooltipArea2 extends InheritedWidget {
  final JustTheTooltipArea2State data;

  const InheritedTooltipArea2({
    super.key,
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedTooltipArea2 oldWidget) =>
      data != oldWidget.data;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<JustTheTooltipArea2State>('data', data));
  }
}

class JustTheTooltipArea2 extends StatefulWidget {
  final TooltipBuilder builder;

  const JustTheTooltipArea2({super.key, required this.builder});

  /// Used to retrieve the scope of the tooltip. This scope is responsible for
  /// managing the children `JustTheTooltip`s
  static JustTheTooltipArea2State of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<InheritedTooltipArea2>();

    assert(
      () {
        if (scope == null) {
          throw FlutterError(
            'JustTheTooltipArea operation requested with a context that does not '
            'include a JustTheTooltipArea.\n Make sure you wrapped your'
            'JustTheTooltip.entry children inside a JustTheTooltipArea',
          );
        }
        return true;
      }(),
    );

    return scope!.data;
  }

  static JustTheTooltipArea2State? maybeOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<InheritedTooltipArea2>();

    return scope?.data;
  }

  @override
  State<JustTheTooltipArea2> createState() => JustTheTooltipArea2State();
}

// TODO: Change the logic here eventually to something cleaner.
/// This parent child works around the fact that the [JustTheTooltipEntry] will
/// send updates to here and thus manage the state. We must create listenable
/// wrappers aruond the skrim and entry as otherwise, when we update this parent
/// from the child, that would trigger a rebuild of the child... Which, without
/// fancy logic, would cause this parent to rebuild again. To avoid that, we
/// instead update the listeners and they then only update their state.
class JustTheTooltipArea2State extends State<JustTheTooltipArea2> {
  var entry = ValueNotifier<Widget?>(null);
  var skrim = ValueNotifier<Widget?>(null);

  void setEntries({required Widget entry, required Widget skrim}) {
    if (mounted) {
      setState(() {
        this.entry.value = entry;
        this.skrim.value = skrim;
      });
    }
  }

  void removeEntries() {
    if (mounted) {
      entry.value = null;
      skrim.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedTooltipArea2(
      data: this,
      // This Builder allows direct children to call `JustTheTooltipArea.of`
      // without requiring a builder themselves.
      child: Builder(
        builder: (context) {
          return widget.builder(
            context,
            ValueListenableBuilder<Widget?>(
              valueListenable: entry,
              builder: (context, widget, child) => widget ?? child!,
              child: const SizedBox.shrink(),
            ),
            ValueListenableBuilder<Widget?>(
              valueListenable: skrim,
              builder: (context, widget, child) => widget ?? child!,
              child: const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
