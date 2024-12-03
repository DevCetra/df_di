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

import 'package:meta/meta.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// An entity is a uniquely identifiable object that serves as a container or
/// identifier for components in a Dependency Injection (DI) or
/// Entity-Component-System (ECS) framework.
class Entity {
  /// Creates an integer [id] from the specified [object]. If the object
  /// is already an [int], it is returned as is. Otherwise, the object is
  /// converted to a string with spaces removed, then the [hashCode] is
  /// calculated and returned.
  @protected
  static int objId(Object object) =>
      object is int ? object : object.toString().replaceAll(' ', '').hashCode;

  /// The value associated with this Entity instance.
  final int id;

  /// Creates a new instance of [Entity] identified by [id].
  const Entity(this.id);

  /// Creates a new instance of [Entity] from the specified [object]. This
  /// effectively uses [objId] to convert the [object] to an [int] and then
  /// uses that as the [id] for the new [Entity] instance.
  factory Entity.obj(Object object) => Entity(objId(object));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is Entity) {
      return other.hashCode == hashCode;
    } else {
      return id == objId(other);
    }
  }

  @override
  int get hashCode => id;

  @override
  String toString() => id.toString();
}