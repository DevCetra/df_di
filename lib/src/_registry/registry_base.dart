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

import '/src/_internal.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract base class RegistryBase {
  //
  //
  //

  /// Retrieves the dependency of type [T] or any subtype associated with
  /// the specified [group].
  ///
  /// Returns `null` if no matching dependency is found.
  @protected
  Dependency<Object>? getDependencyOrNull<T extends Object>({
    required Gr group,
  }) {
    final deps = getDependenciesByGroup(group: group);
    return deps.where((e) {
      return e.value is T;
    }).firstOrNull;
  }

  /// Retrieves the dependency of the exact [type] associated with the
  /// specified [group].
  ///
  /// Returns `null` if no matching dependency is found.
  @protected
  Dependency<Object>? getDependencyUsingExactTypeOrNull({
    required Gr type,
    required Gr group,
  }) {
    final deps = getDependenciesByGroup(group: group);
    return deps.where((e) => Gr(e.type) == type).firstOrNull?.cast();
  }

  /// Retrieves all dependencies associated with the specified [group].
  Iterable<Dependency<Object>> getDependenciesByGroup({
    required Gr group,
  });

  //
  //
  //

  /// Adds or overwrites the dependency of type [T] with the specified [value].
  @protected
  @pragma('vm:prefer-inline')
  void setDependency<T extends Object>({
    required Dependency<T> value,
  }) {
    setDependencyUsingExactType(
      type: Gr(T),
      value: value,
    );
  }

  /// Adds or overwrites the dependency of the exact [type] with the specified
  /// [value].
  void setDependencyUsingExactType({
    required Gr type,
    required Dependency<Object> value,
  });

  //
  //
  //

  /// Removes the dependency of type [T] or any subtype associated with the
  /// specified [group] if it exists.
  ///
  /// Returns the removed value, or `null` if it does not exist.
  @protected
  Dependency<T>? removeDependency<T extends Object>({
    required Gr group,
  }) {
    final dep = getDependencyOrNull<T>(group: group);
    if (dep != null) {
      final removed = removeDependencyUsingExactType(
        type: Gr(dep.type),
        group: group,
      );
      return removed?.cast();
    }
    return null;
  }

  /// Removes the dependency of the exact [type] or any subtype associated with
  /// the specified [group] if it exists.
  ///
  /// Returns the removed value, or `null` if it does not exist.
  Dependency<Object>? removeDependencyUsingExactType({
    required Gr type,
    required Gr group,
  });

  //
  //
  //

  @protected
  @pragma('vm:prefer-inline')
  bool containsDependencyUsingExactType({
    required Gr type,
    required Gr group,
  }) {
    return getDependencyUsingExactTypeOrNull(type: type, group: group) != null;
  }

  @protected
  @pragma('vm:prefer-inline')
  Iterable<Dependency<Object>> getAllDependenciesByKey({
    required Gr group,
  }) {
    return getDependencyMapByKey(group: group)?.values ?? const Iterable.empty();
  }

  /// Sets the map of dependencies for a given [group].
  void setDependencyMapByKey({
    required Gr group,
    required DependencyMap value,
  });

  /// ...
  DependencyMap<Object>? getDependencyMapByKey({
    required Gr group,
  });

  /// ...
  void removeDependencyMapUsingExactType({
    required Gr type,
  });

  /// Clears all registered dependencies.
  ///
  /// This method removes all entries from the registry, effectively resetting
  /// it.
  void clearRegistry();
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A map of [Dependency], grouped by [Gr].
typedef DependencyMap<T extends Object> = Map<Gr, Dependency<T>>;

/// A map of [Dependency], grouped by [Gr] and [Gr].
typedef RegistryMap = Map<Gr, DependencyMap<Object>>;
