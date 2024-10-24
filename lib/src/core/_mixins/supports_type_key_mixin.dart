//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// ignore_for_file: invalid_use_of_protected_member

import '/src/_common.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

base mixin SupportsTypeKeyMixin on DIBase {
  //
  //
  //

  @protected
  Dependency<FutureOr<Object>> _registerDependencyK({
    required Dependency<FutureOr<Object>> dependency,
    bool checkExisting = false,
  }) {
    final groupKey1 = dependency.metadata?.groupKey ?? focusGroup;
    final typeKey = dependency.typeKey;
    if (checkExisting) {
      final existingDep = _getDependencyOrNullK(
        typeKey,
        groupKey: groupKey1,
        traverse: false,
      );
      if (existingDep != null) {
        throw DependencyAlreadyRegisteredException(
          groupKey: groupKey1,
          type: typeKey,
        );
      }
    }
    registry.setDependency(dependency);
    return dependency;
  }

  //
  //
  //

  @protected
  FutureOr<Object> unregisterK(
    DIKey typeKey, {
    DIKey? groupKey,
    bool skipOnUnregisterCallback = false,
  }) {
    final groupKey1 = groupKey ?? focusGroup;
    final removed = [
      registry.removeDependencyK(
        typeKey,
        groupKey: groupKey1,
      ),
      registry.removeDependencyK(
        DIKey.type(Future, [typeKey]),
        groupKey: groupKey1,
      ),
      registry.removeDependencyK(
        DIKey.type(Lazy, [typeKey]),
        groupKey: groupKey1,
      ),
    ].nonNulls.firstOrNull;
    if (removed == null) {
      throw DependencyNotFoundException(
        groupKey: groupKey1,
        type: typeKey,
      );
    }
    final value = removed.value;
    if (skipOnUnregisterCallback) {
      return value;
    }
    return consec(
      removed.metadata?.onUnregister?.call(value),
      (_) => value,
    );
  }

  //
  //
  //

  bool isRegisteredK(
    DIKey typeKey, {
    DIKey? groupKey,
    bool traverse = true,
  }) {
    final groupKey1 = groupKey ?? focusGroup;
    return [
      () =>
          registry.getDependencyOrNullK(
            typeKey,
            groupKey: groupKey1,
          ) !=
          null,
      () =>
          registry.getDependencyOrNullK(
            DIKey.type(Future, [typeKey]),
            groupKey: groupKey1,
          ) !=
          null,
      () =>
          registry.getDependencyOrNullK(
            DIKey.type(Lazy, [typeKey]),
            groupKey: groupKey1,
          ) !=
          null,
      if (traverse)
        () => parents.any(
              (e) => (e as SupportsTypeKeyMixin).isRegisteredK(
                typeKey,
                groupKey: groupKey,
                traverse: true,
              ),
            ),
    ].any((e) => e());
  }

  //
  //
  //

  /// Retrieves a dependency of the exact type [typeKey] registered under the
  /// specified [groupKey].
  ///
  /// Note that this method will not return instances of subtypes. For example,
  /// if [typeKey] is `DIKey('List<dynamic>')` and `DIKey('List<String>')` is
  /// actually registered, this method will not return that registered
  /// dependency. This limitation arises from the use of runtime types. If you
  /// need to retrieve subtypes, consider using the standard [get] method that
  /// employs generics and will return subtypes.
  ///
  /// If the dependency exists, it is returned; otherwise, a
  /// [DependencyNotFoundException] is thrown.
  ///
  /// If [traverse] is set to `true`, the search will also include all parent
  /// containers.
  ///
  /// The return type is a [FutureOr], which means it can either be a
  /// [Future] or a resolved value.
  ///
  /// If the dependency is registered as a non-future, the returned value will
  /// always be non-future. If it is registered as a future, the returned value
  /// will initially be a future. Once that future completes, its resolved value
  /// is re-registered as a non-future, allowing future calls to this method
  /// to return the resolved value directly.
  @protected
  FutureOr<Object> getK(
    DIKey typeKey, {
    DIKey? groupKey,
    bool traverse = true,
  }) {
    final groupKey1 = groupKey ?? focusGroup;
    final value = getOrNullK(
      typeKey,
      groupKey: groupKey1,
      traverse: traverse,
    );
    if (value == null) {
      throw DependencyNotFoundException(
        type: typeKey,
        groupKey: groupKey1,
      );
    }
    return value;
  }

  //
  //
  //

  /// Retrieves a dependency of the exact type [typeKey] registered under the
  /// specified [groupKey].
  ///
  /// Note that this method will not return instances of subtypes. For example,
  /// if [typeKey] is `DIKey('List<dynamic>')` and `DIKey('List<String>')` is
  /// actually registered, this method will not return that registered
  /// dependency. This limitation arises from the use of runtime types. If you
  /// need to retrieve subtypes, consider using the standard [get] method that
  /// employs generics and will return subtypes.
  ///
  /// If the dependency exists, it is returned; otherwise, `null` is returned.
  ///
  /// If [traverse] is set to `true`, the search will also include all parent
  /// containers.
  ///
  /// The return type is a [FutureOr], which means it can either be a
  /// [Future] or a resolved value.
  ///
  /// If the dependency is registered as a non-future, the returned value will
  /// always be non-future. If it is registered as a future, the returned value
  /// will initially be a future. Once that future completes, its resolved value
  /// is re-registered as a non-future, allowing future calls to this method
  /// to return the resolved value directly.
  @protected
  FutureOr<Object>? getOrNullK(
    DIKey typeKey, {
    DIKey? groupKey,
    bool traverse = true,
  }) {
    final groupKey1 = groupKey ?? focusGroup;
    final existingDep = _getDependencyOrNullK(
      typeKey,
      groupKey: groupKey1,
      traverse: traverse,
    );
    final value = existingDep?.value;
    switch (value) {
      case Future<Object> _:
        return value.then(
          (value) {
            _registerDependencyK(
              dependency: Dependency(
                value,
                metadata: existingDep!.metadata,
              ),
              checkExisting: false,
            );
            registry.removeDependencyK(
              typeKey,
              groupKey: groupKey1,
            );
            return value;
          },
        );
      case Object _:
        return value;
      default:
        return null;
    }
  }

  //
  //
  //

  Dependency<FutureOr<Object>>? _getDependencyOrNullK(
    DIKey typeKey, {
    DIKey? groupKey,
    bool traverse = true,
  }) {
    final groupKey1 = groupKey ?? focusGroup;
    var dependency = registry.getDependencyOrNullK(
          typeKey,
          groupKey: groupKey1,
        ) ??
        registry.getDependencyOrNullK(
          DIKey.type(Future, [typeKey]),
          groupKey: groupKey1,
        );

    if (dependency == null && traverse) {
      for (final parent in parents) {
        dependency = (parent as SupportsTypeKeyMixin)._getDependencyOrNullK(
          typeKey,
          groupKey: groupKey1,
        );
        if (dependency != null) {
          break;
        }
      }
    }

    if (dependency != null) {
      final valid = dependency.metadata?.validator?.call(dependency) ?? true;
      if (valid) {
        return dependency.cast();
      } else {
        throw DependencyInvalidException(
          groupKey: groupKey1,
          type: typeKey,
        );
      }
    }

    return null;
  }

  //
  //
  //

  @protected
  FutureOr<Object> untilK(
    DIKey typeKey, {
    DIKey? groupKey,
    bool traverse = true,
  }) {
    final groupKey1 = groupKey ?? focusGroup;

    // Check if the dependency is already registered.
    final test = getOrNullK(typeKey, groupKey: groupKey1);
    if (test != null) {
      // Return the dependency if it is already registered.
      return test;
    }

    CompleterOr<FutureOr<Object>>? completer;
    completer = (completers?.registry
        .getDependencyOrNullK(
          DIKey.type(CompleterOr<FutureOr<Object>>, [typeKey]),
          groupKey: groupKey1,
        )
        ?.value as CompleterOr<FutureOr<Object>>?);
    if (completer != null) {
      return completer.futureOr.thenOr((value) => value);
    }
    completers ??= DIBase();

    // If it's not already registered, register a Completer for the type
    // inside the untilsContainer.
    completer = CompleterOr<FutureOr<Object>>();

    completers!.registry.setDependency(
      Dependency<CompleterOr<FutureOr<Object>>>(
        completer,
        metadata: DependencyMetadata(
          groupKey: groupKey1,
          preemptiveTypeKey: DIKey.type(CompleterOr<Future<Object>>, [typeKey]),
        ),
      ),
    );

    // Wait for the register function to complete the Completer, then unregister
    // the completer before returning the value.
    return completer.futureOr.thenOr((value) {
      completers!.registry.removeDependencyK(
        DIKey.type(CompleterOr<FutureOr<Object>>, [typeKey]),
        groupKey: groupKey1,
      );
      return getK(
        typeKey,
        groupKey: groupKey,
        traverse: traverse,
      );
    });
  }
}
