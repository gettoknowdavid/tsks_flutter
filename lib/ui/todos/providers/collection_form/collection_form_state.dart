part of 'collection_form.dart';

final class CollectionFormState with EquatableMixin {
  CollectionFormState()
    : this._(
        title: SingleLineString(''),
        isFavourite: false,
        createdAt: DateTime.now(),
      );

  const CollectionFormState._({
    required this.title,
    required this.createdAt,
    this.isFavourite = false,
    this.colorARGB,
    this.iconMap,
    this.status = CollectionFormStatus.initial,
    this.exception,
  });

  final SingleLineString title;
  final bool isFavourite;
  final int? colorARGB;
  final Map<String, dynamic>? iconMap;
  final DateTime createdAt;
  final CollectionFormStatus status;
  final TsksException? exception;

  CollectionFormState withTitle(String title) {
    return CollectionFormState._(
      title: SingleLineString(title),
      colorARGB: colorARGB,
      iconMap: iconMap,
      isFavourite: isFavourite,
      createdAt: createdAt,
    );
  }

  CollectionFormState withIsFavourite(bool? isFavouriteValue) {
    return CollectionFormState._(
      title: title,
      colorARGB: colorARGB,
      iconMap: iconMap,
      isFavourite: isFavouriteValue ?? isFavourite,
      createdAt: createdAt,
    );
  }

  CollectionFormState withColor(int colorARGBValue) {
    return CollectionFormState._(
      title: title,
      colorARGB: colorARGBValue,
      iconMap: iconMap,
      isFavourite: isFavourite,
      createdAt: createdAt,
    );
  }

  CollectionFormState withIcon(Map<String, String> iconMapValue) {
    return CollectionFormState._(
      title: title,
      colorARGB: colorARGB,
      iconMap: iconMapValue,
      isFavourite: isFavourite,
      createdAt: createdAt,
    );
  }

  CollectionFormState withSubmissionInProgress() {
    return CollectionFormState._(
      title: title,
      colorARGB: colorARGB,
      iconMap: iconMap,
      isFavourite: isFavourite,
      createdAt: createdAt,
      status: CollectionFormStatus.loading,
    );
  }

  CollectionFormState withSubmissionFailure(TsksException exception) {
    return CollectionFormState._(
      title: title,
      colorARGB: colorARGB,
      iconMap: iconMap,
      isFavourite: isFavourite,
      createdAt: createdAt,
      status: CollectionFormStatus.failure,
      exception: exception,
    );
  }

  CollectionFormState withSubmissionSuccess(dynamic unit) {
    return CollectionFormState._(
      title: title,
      colorARGB: colorARGB,
      iconMap: iconMap,
      isFavourite: isFavourite,
      createdAt: createdAt,
      status: CollectionFormStatus.success,
    );
  }

  bool get isFormValid => title.isValid;

  @override
  List<Object?> get props => [
    title,
    isFavourite,
    colorARGB,
    iconMap,
    createdAt,
    status,
    exception,
  ];
}

enum CollectionFormStatus { initial, loading, success, failure }

extension CollectionFormStatusX on CollectionFormStatus {
  bool get isInitial => this == CollectionFormStatus.initial;
  bool get isLoading => this == CollectionFormStatus.loading;
  bool get isSuccess => this == CollectionFormStatus.success;
  bool get isFailure => this == CollectionFormStatus.failure;
}
