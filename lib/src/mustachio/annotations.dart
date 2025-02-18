// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// See the Mustachio README at tool/mustachio/README.md for high-level
// documentation.

import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:meta/meta.dart';

/// Specifies information for generating both a runtime-interpreted Mustache
/// renderer and a pre-compiled Mustache renderer for a [context] object, using
/// a Mustache template located at [standardHtmlTemplate], for an HTML template,
/// and for a Markdown template, respectively.
// Update `test/builder_test_base.dart` when updating this.
class Renderer {
  /// The name of the render function to generate.
  final Symbol name;

  /// The type of the context type, specified as the [Context] type argument.
  final Context<Object> context;

  /// The unparsed, string form of the URI of the _standard_ HTML template.
  ///
  /// This represents the Mustache template that dartdoc uses out-of-the-box to
  /// render the [context] object while generating documentation in HTML.
  final String standardHtmlTemplate;

  /// A set of types which are "visible" to the Mustache runtime interpreter.
  /// Mustache runtime-rendering has access to all of a type's public getters if
  /// the type is visible to Mustache.
  ///
  /// Note that all subtypes and supertypes of a "visible" type are also visible
  /// to Mustache.
  final Set<Type> visibleTypes;

  /// Returns a Renderer with the specified renderer function [name] which can
  /// render [context] objects.
  ///
  /// [standardTemplateBasename] is used as a basename in an
  /// Asset URL, in both [standardHtmlTemplate], in order to render with the
  /// out-of-the-box Mustache templates.
  const Renderer(
    this.name,
    this.context,
    String standardTemplateBasename, {
    this.visibleTypes = const {},
  }) : standardHtmlTemplate = 'lib/templates/$standardTemplateBasename.html';

  @visibleForTesting
  const Renderer.forTest(
    this.name,
    this.context,
    String standardTemplateBasename, {
    this.visibleTypes = const {},
  }) : standardHtmlTemplate =
            'test/mustachio/templates/$standardTemplateBasename.html';
}

/// A container for a type, [T], which is the type of a context object,
/// referenced in a `@Renderer` annotation.
///
/// An instance of this class holds zero information, except for [T], a type.
// Update `test/builder_test_base.dart` when updating this.
class Context<T> {
  const Context();
}

/// The specification of a renderer, as derived from a @Renderer annotation.
///
/// This is only meant to be used by dartdoc's builders.
@internal
class RendererSpec {
  /// The name of the render function.
  final String name;

  final InterfaceType contextType;

  // TODO(srawlins): I think this should be `Set<InterfaceType>`.
  final Set<DartType> visibleTypes;

  final String standardHtmlTemplate;

  RendererSpec(
    this.name,
    this.contextType,
    this.visibleTypes,
    this.standardHtmlTemplate,
  );

  InterfaceElement2 get contextElement => contextType.element3;
}
