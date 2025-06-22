part of 'collection_form_notifier.dart';

final class CollectionFormState with FormzMixin, EquatableMixin {
  const CollectionFormState() : this._();

  const CollectionFormState._({
    this.title = const CollectionTitle.pure(),
    this.isFavourite = false,
    this.color,
    this.iconMap,
    this.status = Status.initial,
    this.exception,
    this.initialCollection,
    this.newCollection,
  });

  final CollectionTitle title;
  final bool isFavourite;
  final Color? color;
  final Map<String, dynamic>? iconMap;
  final Status status;
  final TsksException? exception;
  final Collection? initialCollection;
  final Collection? newCollection;

  CollectionFormState withTitle(String title) {
    return CollectionFormState._(
      title: CollectionTitle.dirty(title),
      color: color,
      iconMap: iconMap,
      isFavourite: isFavourite,
      initialCollection: initialCollection,
    );
  }

  CollectionFormState withIsFavourite(bool? isFavouriteValue) {
    return CollectionFormState._(
      title: title,
      color: color,
      iconMap: iconMap,
      isFavourite: isFavouriteValue ?? isFavourite,
      initialCollection: initialCollection,
    );
  }

  CollectionFormState withColor(Color? colorValue) {
    return CollectionFormState._(
      title: title,
      color: colorValue,
      iconMap: iconMap,
      isFavourite: isFavourite,
      initialCollection: initialCollection,
    );
  }

  CollectionFormState withIcon(Map<String, dynamic> iconMapValue) {
    return CollectionFormState._(
      title: title,
      color: color,
      iconMap: iconMapValue,
      isFavourite: isFavourite,
      initialCollection: initialCollection,
    );
  }

  CollectionFormState withCollection(Collection collection) {
    return CollectionFormState._(
      title: CollectionTitle.dirty(collection.title),
      isFavourite: collection.isFavourite,
      color: collection.colorARGB?.toColor,
      iconMap: collection.iconMap,
      initialCollection: collection,
    );
  }

  CollectionFormState withSubmissionInProgress() {
    return CollectionFormState._(
      title: title,
      color: color,
      iconMap: iconMap,
      isFavourite: isFavourite,
      initialCollection: initialCollection,
      status: Status.inProgress,
    );
  }

  CollectionFormState withSubmissionFailure(TsksException exception) {
    return CollectionFormState._(
      title: title,
      color: color,
      iconMap: iconMap,
      isFavourite: isFavourite,
      initialCollection: initialCollection,
      status: Status.failure,
      exception: exception,
    );
  }

  CollectionFormState withSubmissionSuccess(Collection newCollection) {
    return CollectionFormState._(
      title: title,
      color: color,
      iconMap: iconMap,
      isFavourite: isFavourite,
      status: Status.success,
      initialCollection: initialCollection,
      newCollection: newCollection,
    );
  }

  bool get isEditing => initialCollection != null;

  bool get hasChanges {
    return initialCollection?.title != title.value ||
        initialCollection?.iconMap != iconMap ||
        initialCollection?.colorARGB != color?.toARGB32() ||
        initialCollection?.isFavourite != isFavourite;
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [title];

  @override
  List<Object?> get props => [
    title,
    isFavourite,
    color,
    iconMap,
    status,
    exception,
    initialCollection,
    newCollection,
  ];
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
