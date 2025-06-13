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
    this.color,
    this.iconMap,
    this.status = CollectionFormStatus.initial,
    this.exception,
  });

  final SingleLineString title;
  final bool isFavourite;
  final Color? color;
  final Map<String, dynamic>? iconMap;
  final DateTime createdAt;
  final CollectionFormStatus status;
  final TsksException? exception;

  CollectionFormState withTitle(String title) {
    return CollectionFormState._(
      title: SingleLineString(title),
      color: color,
      iconMap: iconMap,
      isFavourite: isFavourite,
      createdAt: createdAt,
    );
  }

  CollectionFormState withIsFavourite(bool? isFavouriteValue) {
    return CollectionFormState._(
      title: title,
      color: color,
      iconMap: iconMap,
      isFavourite: isFavouriteValue ?? isFavourite,
      createdAt: createdAt,
    );
  }

  CollectionFormState withColor(Color? colorValue) {
    return CollectionFormState._(
      title: title,
      color: colorValue,
      iconMap: iconMap,
      isFavourite: isFavourite,
      createdAt: createdAt,
    );
  }

  CollectionFormState withIcon(Map<String, dynamic> iconMapValue) {
    return CollectionFormState._(
      title: title,
      color: color,
      iconMap: iconMapValue,
      isFavourite: isFavourite,
      createdAt: createdAt,
    );
  }

  CollectionFormState withSubmissionInProgress() {
    return CollectionFormState._(
      title: title,
      color: color,
      iconMap: iconMap,
      isFavourite: isFavourite,
      createdAt: createdAt,
      status: CollectionFormStatus.loading,
    );
  }

  CollectionFormState withSubmissionFailure(TsksException exception) {
    return CollectionFormState._(
      title: title,
      color: color,
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
      color: color,
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
    color,
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

const List<Color> collectionColors = [
  Color(0xFFA5A5A5),
  Color(0xFFFC76A1),
  Color(0xFFDBBE56),
  Color(0xFFE39264),
  Color(0xFFD25A61),
  Color(0xFFAE68E6),
  Color(0xFF70C4BF),
  Color(0xFF9E7F72),
  Color(0xFF145DA0),
  Color(0xFFFC2E20),
  Color(0xFF1D741B),
  Color(0xFFFF8882),
  Color(0xFF9C2D41),
  Color(0xFFED760E),
  Color(0xFF642424),
  Color(0xFF6D6552),
  Color(0xFF924E7D),
  Color(0xFFCB2821),
  Color(0xFF2271B3),
  Color(0xFFffdc00),
];
