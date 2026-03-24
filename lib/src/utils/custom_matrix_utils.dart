import 'dart:math';
import 'package:flutter/material.dart';

/// Utility class for modern Matrix4 operations
/// Replaces deprecated translate(), scale(), and rotate() methods
class CustomMatrixUtils {
  CustomMatrixUtils._();

  /// Creates a translation matrix
  static Matrix4 translate({
    double x = 0.0,
    double y = 0.0,
    double z = 0.0,
  }) {
    final matrix = Matrix4.identity();
    _setTranslation(matrix, x, y, z);
    return matrix;
  }

  /// Creates a translation matrix with double values
  static Matrix4 translateByDouble(double x, double y, double z) {
    final matrix = Matrix4.identity();
    _setTranslation(matrix, x, y, z);
    return matrix;
  }

  /// Creates a scale matrix
  static Matrix4 scale({
    double x = 1.0,
    double y = 1.0,
    double z = 1.0,
  }) {
    final matrix = Matrix4.identity();
    matrix.setEntry(0, 0, x);
    matrix.setEntry(1, 1, y);
    matrix.setEntry(2, 2, z);
    return matrix;
  }

  /// Creates a scale matrix with double values
  static Matrix4 scaleByDouble(double x, double y, double z) {
    final matrix = Matrix4.identity();
    matrix.setEntry(0, 0, x);
    matrix.setEntry(1, 1, y);
    matrix.setEntry(2, 2, z);
    return matrix;
  }

  /// Creates a rotation matrix around X axis
  static Matrix4 rotationX(double angle) {
    final sinA = sin(angle);
    final cosA = cos(angle);
    return Matrix4.identity()
      ..setEntry(1, 1, cosA)
      ..setEntry(1, 2, -sinA)
      ..setEntry(2, 1, sinA)
      ..setEntry(2, 2, cosA);
  }

  /// Creates a rotation matrix around Y axis
  static Matrix4 rotationY(double angle) {
    final sinA = sin(angle);
    final cosA = cos(angle);
    return Matrix4.identity()
      ..setEntry(0, 0, cosA)
      ..setEntry(0, 2, sinA)
      ..setEntry(2, 0, -sinA)
      ..setEntry(2, 2, cosA);
  }

  /// Creates a rotation matrix around Z axis
  static Matrix4 rotationZ(double angle) {
    final sinA = sin(angle);
    final cosA = cos(angle);
    return Matrix4.identity()
      ..setEntry(0, 0, cosA)
      ..setEntry(0, 1, -sinA)
      ..setEntry(1, 0, sinA)
      ..setEntry(1, 1, cosA);
  }

  /// Creates a 3D bounce transform (used in MultiBounce3DDropdownStrategy)
  static Matrix4 bounce3D({
    double depth = 5.0,
    double rotationAngle = 0.0,
    double scaleValue = 1.0,
    double perspective = 0.001,
  }) {
    final matrix = Matrix4.identity();
    matrix.setEntry(3, 2, perspective);
    _setTranslation(matrix, 0, 0, depth);
    matrix.multiply(rotationX(rotationAngle));
    matrix.multiply(scaleByDouble(scaleValue, scaleValue, scaleValue));
    return matrix;
  }

  /// Creates a staggered item transform (used in Staggered strategies)
  static Matrix4 staggerTransform({
    required double progress,
    double startY = 0.0,
    double endY = 20.0,
    double startScale = 0.0,
    double endScale = 1.0,
  }) {
    final t = progress.clamp(0.0, 1.0);
    final y = startY + (endY - startY) * t;
    final s = startScale + (endScale - startScale) * t;
    final matrix = Matrix4.identity();
    _setTranslation(matrix, 0, y, 0);
    matrix.multiply(scaleByDouble(s, s, 1.0));
    return matrix;
  }

  /// Creates a gravity well transform (used in GravityWellMultiDropdownStrategy)
  static Matrix4 gravityWell({
    required double progress,
    double startY = 30.0,
    double endY = 0.0,
    double startScale = 0.5,
    double endScale = 1.0,
  }) {
    final t = progress.clamp(0.0, 1.0);
    final y = startY + (endY - startY) * t;
    final s = startScale + (endScale - startScale) * t;
    final matrix = Matrix4.identity();
    _setTranslation(matrix, 0, y, 0);
    matrix.multiply(scaleByDouble(1.0, s, 1.0));
    return matrix;
  }

  /// Creates a fan spread transform (used in HolographicFanMultiDropdownStrategy)
  static Matrix4 fanSpread({
    required double progress,
    double startX = 10.0,
    double endX = 0.0,
    double startRotation = -0.5,
    double endRotation = 0.0,
  }) {
    final t = progress.clamp(0.0, 1.0);
    final x = startX + (endX - startX) * t;
    final rotation = startRotation + (endRotation - startRotation) * t;
    final matrix = Matrix4.identity();
    _setTranslation(matrix, x, 0, 0);
    matrix.multiply(rotationX(rotation));
    return matrix;
  }

  /// Creates a foldable transform (used in FoldableMultiDropdownStrategy)
  static Matrix4 foldable({
    required double progress,
    double startHeight = 0.0,
    double endHeight = 1.0,
  }) {
    final t = progress.clamp(0.0, 1.0);
    final height = startHeight + (endHeight - startHeight) * t;
    final matrix = Matrix4.identity();
    matrix.multiply(scaleByDouble(1.0, height, 1.0));
    return matrix;
  }

  /// Creates a fluid wave transform (used in FluidWaveMultiDropdownStrategy)
  static Matrix4 fluidWave({
    required double progress,
    double amplitude = 20.0,
    double frequency = 2.0,
  }) {
    final y = sin(progress * pi * frequency) * amplitude;
    final matrix = Matrix4.identity();
    _setTranslation(matrix, 0, y, 0);
    return matrix;
  }

  /// Creates a ripple transform
  static Matrix4 ripple({
    required double progress,
    double maxScale = 1.5,
  }) {
    final scale = 1.0 + (maxScale - 1.0) * progress;
    final matrix = Matrix4.identity();
    matrix.multiply(scaleByDouble(scale, scale, 1.0));
    return matrix;
  }

  /// Creates a morphing transform
  static Matrix4 morphing({
    required double progress,
    double startRadius = 12.0,
    double endRadius = 24.0,
  }) {
    final radius = startRadius + (endRadius - startRadius) * progress;
    final scale = radius / startRadius;
    return scaleByDouble(scale, scale, 1.0);
  }

  /// Creates a floating card transform
  static Matrix4 floatingCard({
    required double progress,
    double startOffset = 20.0,
    double endOffset = 0.0,
  }) {
    final offset = startOffset + (endOffset - startOffset) * progress;
    return translate(y: offset);
  }

  /// Creates a molecular bond transform
  static Matrix4 molecularBond({
    required double progress,
    double startOffset = 20.0,
    double endOffset = 0.0,
  }) {
    final offset = startOffset + (endOffset - startOffset) * progress;
    return translate(y: offset);
  }

  // Private helper method to set translation
  static void _setTranslation(Matrix4 matrix, double x, double y, double z) {
    matrix[12] = x;
    matrix[13] = y;
    matrix[14] = z;
  }
}

/// Extension methods for easier Matrix4 operations
extension Matrix4Extension on Matrix4 {
  /// Sets the translation component
  void setTranslation(double x, double y, double z) {
    this[12] = x;
    this[13] = y;
    this[14] = z;
  }

  /// Gets the translation X component
  double get translationX => this[12];

  /// Gets the translation Y component
  double get translationY => this[13];

  /// Gets the translation Z component
  double get translationZ => this[14];

  /// Sets the scale component
  void setScale(double x, double y, double z) {
    this[0] = x;
    this[5] = y;
    this[10] = z;
  }

  /// Gets the scale X component
  double get scaleX => this[0];

  /// Gets the scale Y component
  double get scaleY => this[5];

  /// Gets the scale Z component
  double get scaleZ => this[10];

  /// Applies translation to this matrix
  Matrix4 translateBy(double x, double y, double z) {
    return this * CustomMatrixUtils.translateByDouble(x, y, z);
  }

  /// Applies scale to this matrix
  Matrix4 scaleBy(double x, double y, double z) {
    return this * CustomMatrixUtils.scaleByDouble(x, y, z);
  }

  /// Applies rotation around X axis
  Matrix4 rotateByX(double angle) {
    return this * CustomMatrixUtils.rotationX(angle);
  }

  /// Applies rotation around Y axis
  Matrix4 rotateByY(double angle) {
    return this * CustomMatrixUtils.rotationY(angle);
  }

  /// Applies rotation around Z axis
  Matrix4 rotateByZ(double angle) {
    return this * CustomMatrixUtils.rotationZ(angle);
  }

  /// Returns a copy of this matrix
  Matrix4 clone() {
    return Matrix4.copy(this);
  }
}