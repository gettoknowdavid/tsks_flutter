import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:tsks_flutter/domain/core/exceptions/value_exception.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_object.dart';

class ImageFile extends ValueObject<File?> {
  static ImageFile empty = ImageFile(null);

  static final _allowedExtensions = ['jpg', 'jpeg', 'png'];

  factory ImageFile(File? input) {
    final validationResult = _validateFile(input);
    return ImageFile._(validationResult);
  }

  const ImageFile._(super.input);

  static Either<ValueException<File?>, File?> _validateFile(File? input) {
    if (input == null) return const Right(null);

    final extension = input.path.split('.').last.toLowerCase();

    if (!_allowedExtensions.contains(extension)) {
      return Left(InvalidFileFormatException<File?>(input));
    }

    return Right(input);
  }
}
