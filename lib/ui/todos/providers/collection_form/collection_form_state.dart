part of 'collection_form_notifier.dart';

final class CollectionFormState with EquatableMixin {
  CollectionFormState()
    : this._(
        id: Id.fromString(const Uuid().v4()),
        title: SingleLineString(''),
        isFavourite: false,
        createdAt: DateTime.now(),
      );

  const CollectionFormState._({
    required this.id,
    required this.title,
    this.isFavourite = false,
    this.colorARGB,
    this.iconMap,
    this.createdAt,
    this.status = CollectionFormStatus.initial,
    this.exception,
  });

  final Id id;
  final SingleLineString title;
  final bool isFavourite;
  final int? colorARGB;
  final Map<String, dynamic>? iconMap;
  final DateTime? createdAt;
  final CollectionFormStatus status;
  final TsksException? exception;

  CollectionFormState withTitle(String title) {
    return CollectionFormState._(
      id: id,
      title: SingleLineString(title),
      colorARGB: colorARGB,
      iconMap: iconMap,
      isFavourite: isFavourite,
      createdAt: createdAt,
    );
  }

  CollectionFormState withIsFavourite(bool isFavouriteValue) {
    return CollectionFormState._(
      id: id,
      title: title,
      colorARGB: colorARGB,
      iconMap: iconMap,
      isFavourite: isFavouriteValue,
      createdAt: createdAt,
    );
  }

  CollectionFormState withColor(int colorARGBValue) {
    return CollectionFormState._(
      id: id,
      title: title,
      colorARGB: colorARGBValue,
      iconMap: iconMap,
      isFavourite: isFavourite,
      createdAt: createdAt,
    );
  }

  CollectionFormState withIcon(Map<String, String> iconMapValue) {
    return CollectionFormState._(
      id: id,
      title: title,
      colorARGB: colorARGB,
      iconMap: iconMapValue,
      isFavourite: isFavourite,
      createdAt: createdAt,
    );
  }

  CollectionFormState withSubmissionInProgress() {
    return CollectionFormState._(
      id: id,
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
      id: id,
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
      id: id,
      title: title,
      colorARGB: colorARGB,
      iconMap: iconMap,
      isFavourite: isFavourite,
      createdAt: createdAt,
      status: CollectionFormStatus.success,
    );
  }

  bool get isFormValid => id.isValid && title.isValid;

  @override
  List<Object?> get props => [
    id,
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
