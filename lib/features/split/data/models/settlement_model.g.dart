// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettlementModelCollection on Isar {
  IsarCollection<SettlementModel> get settlementModels => this.collection();
}

const SettlementModelSchema = CollectionSchema(
  name: r'SettlementModel',
  id: -6970418572406353937,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'groupId': PropertySchema(
      id: 2,
      name: r'groupId',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 3,
      name: r'notes',
      type: IsarType.string,
    ),
    r'payerId': PropertySchema(
      id: 4,
      name: r'payerId',
      type: IsarType.long,
    ),
    r'receiverId': PropertySchema(
      id: 5,
      name: r'receiverId',
      type: IsarType.long,
    ),
    r'settlementDate': PropertySchema(
      id: 6,
      name: r'settlementDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _settlementModelEstimateSize,
  serialize: _settlementModelSerialize,
  deserialize: _settlementModelDeserialize,
  deserializeProp: _settlementModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'groupId': IndexSchema(
      id: -8523216633229774932,
      name: r'groupId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'groupId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'payerId': IndexSchema(
      id: -8052580446056216329,
      name: r'payerId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'payerId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'receiverId': IndexSchema(
      id: 6011257104462202512,
      name: r'receiverId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'receiverId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'settlementDate': IndexSchema(
      id: 1672819882985121621,
      name: r'settlementDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'settlementDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _settlementModelGetId,
  getLinks: _settlementModelGetLinks,
  attach: _settlementModelAttach,
  version: '3.1.0+1',
);

int _settlementModelEstimateSize(
  SettlementModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _settlementModelSerialize(
  SettlementModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.groupId);
  writer.writeString(offsets[3], object.notes);
  writer.writeLong(offsets[4], object.payerId);
  writer.writeLong(offsets[5], object.receiverId);
  writer.writeDateTime(offsets[6], object.settlementDate);
}

SettlementModel _settlementModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SettlementModel();
  object.amount = reader.readDouble(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.groupId = reader.readLong(offsets[2]);
  object.id = id;
  object.notes = reader.readStringOrNull(offsets[3]);
  object.payerId = reader.readLong(offsets[4]);
  object.receiverId = reader.readLong(offsets[5]);
  object.settlementDate = reader.readDateTime(offsets[6]);
  return object;
}

P _settlementModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _settlementModelGetId(SettlementModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _settlementModelGetLinks(SettlementModel object) {
  return [];
}

void _settlementModelAttach(
    IsarCollection<dynamic> col, Id id, SettlementModel object) {
  object.id = id;
}

extension SettlementModelQueryWhereSort
    on QueryBuilder<SettlementModel, SettlementModel, QWhere> {
  QueryBuilder<SettlementModel, SettlementModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhere> anyGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'groupId'),
      );
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhere> anyPayerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'payerId'),
      );
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhere> anyReceiverId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'receiverId'),
      );
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhere>
      anySettlementDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'settlementDate'),
      );
    });
  }
}

extension SettlementModelQueryWhere
    on QueryBuilder<SettlementModel, SettlementModel, QWhereClause> {
  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      groupIdEqualTo(int groupId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupId',
        value: [groupId],
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      groupIdNotEqualTo(int groupId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      groupIdGreaterThan(
    int groupId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupId',
        lower: [groupId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      groupIdLessThan(
    int groupId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupId',
        lower: [],
        upper: [groupId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      groupIdBetween(
    int lowerGroupId,
    int upperGroupId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupId',
        lower: [lowerGroupId],
        includeLower: includeLower,
        upper: [upperGroupId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      payerIdEqualTo(int payerId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'payerId',
        value: [payerId],
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      payerIdNotEqualTo(int payerId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'payerId',
              lower: [],
              upper: [payerId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'payerId',
              lower: [payerId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'payerId',
              lower: [payerId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'payerId',
              lower: [],
              upper: [payerId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      payerIdGreaterThan(
    int payerId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'payerId',
        lower: [payerId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      payerIdLessThan(
    int payerId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'payerId',
        lower: [],
        upper: [payerId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      payerIdBetween(
    int lowerPayerId,
    int upperPayerId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'payerId',
        lower: [lowerPayerId],
        includeLower: includeLower,
        upper: [upperPayerId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      receiverIdEqualTo(int receiverId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'receiverId',
        value: [receiverId],
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      receiverIdNotEqualTo(int receiverId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'receiverId',
              lower: [],
              upper: [receiverId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'receiverId',
              lower: [receiverId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'receiverId',
              lower: [receiverId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'receiverId',
              lower: [],
              upper: [receiverId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      receiverIdGreaterThan(
    int receiverId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'receiverId',
        lower: [receiverId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      receiverIdLessThan(
    int receiverId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'receiverId',
        lower: [],
        upper: [receiverId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      receiverIdBetween(
    int lowerReceiverId,
    int upperReceiverId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'receiverId',
        lower: [lowerReceiverId],
        includeLower: includeLower,
        upper: [upperReceiverId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      settlementDateEqualTo(DateTime settlementDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'settlementDate',
        value: [settlementDate],
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      settlementDateNotEqualTo(DateTime settlementDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'settlementDate',
              lower: [],
              upper: [settlementDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'settlementDate',
              lower: [settlementDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'settlementDate',
              lower: [settlementDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'settlementDate',
              lower: [],
              upper: [settlementDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      settlementDateGreaterThan(
    DateTime settlementDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'settlementDate',
        lower: [settlementDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      settlementDateLessThan(
    DateTime settlementDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'settlementDate',
        lower: [],
        upper: [settlementDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterWhereClause>
      settlementDateBetween(
    DateTime lowerSettlementDate,
    DateTime upperSettlementDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'settlementDate',
        lower: [lowerSettlementDate],
        includeLower: includeLower,
        upper: [upperSettlementDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SettlementModelQueryFilter
    on QueryBuilder<SettlementModel, SettlementModel, QFilterCondition> {
  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      groupIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      groupIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      groupIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      groupIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      payerIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payerId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      payerIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'payerId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      payerIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'payerId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      payerIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'payerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      receiverIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiverId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      receiverIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receiverId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      receiverIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receiverId',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      receiverIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receiverId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      settlementDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'settlementDate',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      settlementDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'settlementDate',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      settlementDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'settlementDate',
        value: value,
      ));
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterFilterCondition>
      settlementDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'settlementDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SettlementModelQueryObject
    on QueryBuilder<SettlementModel, SettlementModel, QFilterCondition> {}

extension SettlementModelQueryLinks
    on QueryBuilder<SettlementModel, SettlementModel, QFilterCondition> {}

extension SettlementModelQuerySortBy
    on QueryBuilder<SettlementModel, SettlementModel, QSortBy> {
  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy> sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy> sortByPayerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payerId', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      sortByPayerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payerId', Sort.desc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      sortByReceiverId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverId', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      sortByReceiverIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverId', Sort.desc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      sortBySettlementDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settlementDate', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      sortBySettlementDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settlementDate', Sort.desc);
    });
  }
}

extension SettlementModelQuerySortThenBy
    on QueryBuilder<SettlementModel, SettlementModel, QSortThenBy> {
  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy> thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy> thenByPayerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payerId', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      thenByPayerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payerId', Sort.desc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      thenByReceiverId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverId', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      thenByReceiverIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverId', Sort.desc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      thenBySettlementDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settlementDate', Sort.asc);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QAfterSortBy>
      thenBySettlementDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settlementDate', Sort.desc);
    });
  }
}

extension SettlementModelQueryWhereDistinct
    on QueryBuilder<SettlementModel, SettlementModel, QDistinct> {
  QueryBuilder<SettlementModel, SettlementModel, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QDistinct>
      distinctByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId');
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QDistinct>
      distinctByPayerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payerId');
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QDistinct>
      distinctByReceiverId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiverId');
    });
  }

  QueryBuilder<SettlementModel, SettlementModel, QDistinct>
      distinctBySettlementDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'settlementDate');
    });
  }
}

extension SettlementModelQueryProperty
    on QueryBuilder<SettlementModel, SettlementModel, QQueryProperty> {
  QueryBuilder<SettlementModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SettlementModel, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<SettlementModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<SettlementModel, int, QQueryOperations> groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<SettlementModel, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<SettlementModel, int, QQueryOperations> payerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payerId');
    });
  }

  QueryBuilder<SettlementModel, int, QQueryOperations> receiverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiverId');
    });
  }

  QueryBuilder<SettlementModel, DateTime, QQueryOperations>
      settlementDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'settlementDate');
    });
  }
}
