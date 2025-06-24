// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drink_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DrinkModel _$DrinkModelFromJson(Map<String, dynamic> json) {
  return _DrinkModel.fromJson(json);
}

/// @nodoc
mixin _$DrinkModel {
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _ingredientsFromJson)
  dynamic get ingredients => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  dynamic get id => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  /// Serializes this DrinkModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DrinkModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DrinkModelCopyWith<DrinkModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DrinkModelCopyWith<$Res> {
  factory $DrinkModelCopyWith(
    DrinkModel value,
    $Res Function(DrinkModel) then,
  ) = _$DrinkModelCopyWithImpl<$Res, DrinkModel>;
  @useResult
  $Res call({
    String title,
    String description,
    @JsonKey(fromJson: _ingredientsFromJson) dynamic ingredients,
    String image,
    dynamic id,
    double? price,
    String? type,
    bool isFavorite,
    int quantity,
  });
}

/// @nodoc
class _$DrinkModelCopyWithImpl<$Res, $Val extends DrinkModel>
    implements $DrinkModelCopyWith<$Res> {
  _$DrinkModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DrinkModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? ingredients = freezed,
    Object? image = null,
    Object? id = freezed,
    Object? price = freezed,
    Object? type = freezed,
    Object? isFavorite = null,
    Object? quantity = null,
  }) {
    return _then(
      _value.copyWith(
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            ingredients:
                freezed == ingredients
                    ? _value.ingredients
                    : ingredients // ignore: cast_nullable_to_non_nullable
                        as dynamic,
            image:
                null == image
                    ? _value.image
                    : image // ignore: cast_nullable_to_non_nullable
                        as String,
            id:
                freezed == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as dynamic,
            price:
                freezed == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as double?,
            type:
                freezed == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String?,
            isFavorite:
                null == isFavorite
                    ? _value.isFavorite
                    : isFavorite // ignore: cast_nullable_to_non_nullable
                        as bool,
            quantity:
                null == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DrinkModelImplCopyWith<$Res>
    implements $DrinkModelCopyWith<$Res> {
  factory _$$DrinkModelImplCopyWith(
    _$DrinkModelImpl value,
    $Res Function(_$DrinkModelImpl) then,
  ) = __$$DrinkModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String description,
    @JsonKey(fromJson: _ingredientsFromJson) dynamic ingredients,
    String image,
    dynamic id,
    double? price,
    String? type,
    bool isFavorite,
    int quantity,
  });
}

/// @nodoc
class __$$DrinkModelImplCopyWithImpl<$Res>
    extends _$DrinkModelCopyWithImpl<$Res, _$DrinkModelImpl>
    implements _$$DrinkModelImplCopyWith<$Res> {
  __$$DrinkModelImplCopyWithImpl(
    _$DrinkModelImpl _value,
    $Res Function(_$DrinkModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DrinkModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? ingredients = freezed,
    Object? image = null,
    Object? id = freezed,
    Object? price = freezed,
    Object? type = freezed,
    Object? isFavorite = null,
    Object? quantity = null,
  }) {
    return _then(
      _$DrinkModelImpl(
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        ingredients:
            freezed == ingredients
                ? _value.ingredients
                : ingredients // ignore: cast_nullable_to_non_nullable
                    as dynamic,
        image:
            null == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                    as String,
        id:
            freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as dynamic,
        price:
            freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as double?,
        type:
            freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String?,
        isFavorite:
            null == isFavorite
                ? _value.isFavorite
                : isFavorite // ignore: cast_nullable_to_non_nullable
                    as bool,
        quantity:
            null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DrinkModelImpl with DiagnosticableTreeMixin implements _DrinkModel {
  const _$DrinkModelImpl({
    required this.title,
    required this.description,
    @JsonKey(fromJson: _ingredientsFromJson) this.ingredients,
    required this.image,
    required this.id,
    this.price,
    this.type,
    this.isFavorite = false,
    this.quantity = 0,
  });

  factory _$DrinkModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DrinkModelImplFromJson(json);

  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey(fromJson: _ingredientsFromJson)
  final dynamic ingredients;
  @override
  final String image;
  @override
  final dynamic id;
  @override
  final double? price;
  @override
  final String? type;
  @override
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey()
  final int quantity;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DrinkModel(title: $title, description: $description, ingredients: $ingredients, image: $image, id: $id, price: $price, type: $type, isFavorite: $isFavorite, quantity: $quantity)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DrinkModel'))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('ingredients', ingredients))
      ..add(DiagnosticsProperty('image', image))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('price', price))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('isFavorite', isFavorite))
      ..add(DiagnosticsProperty('quantity', quantity));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DrinkModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other.ingredients,
              ingredients,
            ) &&
            (identical(other.image, image) || other.image == image) &&
            const DeepCollectionEquality().equals(other.id, id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    const DeepCollectionEquality().hash(ingredients),
    image,
    const DeepCollectionEquality().hash(id),
    price,
    type,
    isFavorite,
    quantity,
  );

  /// Create a copy of DrinkModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DrinkModelImplCopyWith<_$DrinkModelImpl> get copyWith =>
      __$$DrinkModelImplCopyWithImpl<_$DrinkModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DrinkModelImplToJson(this);
  }
}

abstract class _DrinkModel implements DrinkModel {
  const factory _DrinkModel({
    required final String title,
    required final String description,
    @JsonKey(fromJson: _ingredientsFromJson) final dynamic ingredients,
    required final String image,
    required final dynamic id,
    final double? price,
    final String? type,
    final bool isFavorite,
    final int quantity,
  }) = _$DrinkModelImpl;

  factory _DrinkModel.fromJson(Map<String, dynamic> json) =
      _$DrinkModelImpl.fromJson;

  @override
  String get title;
  @override
  String get description;
  @override
  @JsonKey(fromJson: _ingredientsFromJson)
  dynamic get ingredients;
  @override
  String get image;
  @override
  dynamic get id;
  @override
  double? get price;
  @override
  String? get type;
  @override
  bool get isFavorite;
  @override
  int get quantity;

  /// Create a copy of DrinkModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DrinkModelImplCopyWith<_$DrinkModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
