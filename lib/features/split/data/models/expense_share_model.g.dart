// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_share_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetExpenseShareModelCollection on Isar {
  IsarCollection<ExpenseShareModel> get expenseShareModels => this.collection();
}

const ExpenseShareModelSchema = CollectionSchema(
  name: r'ExpenseShareModel',
  id: -8536409415595335593,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'expenseId': PropertySchema(
      id: 1,
      name: r'expenseId',
      type: IsarType.long,
    ),
    r'memberId': PropertySchema(
      id: 2,
      name: r'memberId',
      type: IsarType.long,
    ),
    r'percentage': PropertySchema(
      id: 3,
      name: r'percentage',
      type: IsarType.double,
    ),
    r'settledAmount': PropertySchema(
      id: 4,
      name: r'settledAmount',
      type: IsarType.double,
    ),
    r'syncStatus': PropertySchema(
      id: 5,
      name: r'syncStatus',
      type: IsarType.string,
      enumMap: _ExpenseShareModelsyncStatusEnumValueMap,
    )
  },
  estimateSize: _expenseShareModelEstimateSize,
  serialize: _expenseShareModelSerialize,
  deserialize: _expenseShareModelDeserialize,
  deserializeProp: _expenseShareModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'expenseId': IndexSchema(
      id: -8289172275633362361,
      name: r'expenseId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'expenseId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'memberId': IndexSchema(
      id: 5707689632932325803,
      name: r'memberId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'memberId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _expenseShareModelGetId,
  getLinks: _expenseShareModelGetLinks,
  attach: _expenseShareModelAttach,
  version: '3.1.0+1',
);

int _expenseShareModelEstimateSize(
  ExpenseShareModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.syncStatus.name.length * 3;
  return bytesCount;
}

void _expenseShareModelSerialize(
  ExpenseShareModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeLong(offsets[1], object.expenseId);
  writer.writeLong(offsets[2], object.memberId);
  writer.writeDouble(offsets[3], object.percentage);
  writer.writeDouble(offsets[4], object.settledAmount);
  writer.writeString(offsets[5], object.syncStatus.name);
}

ExpenseShareModel _expenseShareModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ExpenseShareModel();
  object.amount = reader.readDouble(offsets[0]);
  object.expenseId = reader.readLong(offsets[1]);
  object.id = id;
  object.memberId = reader.readLong(offsets[2]);
  object.percentage = reader.readDouble(offsets[3]);
  object.settledAmount = reader.readDouble(offsets[4]);
  object.syncStatus = _ExpenseShareModelsyncStatusValueEnumMap[
          reader.readStringOrNull(offsets[5])] ??
      SyncStatus.localOnly;
  return object;
}

P _expenseShareModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (_ExpenseShareModelsyncStatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SyncStatus.localOnly) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ExpenseShareModelsyncStatusEnumValueMap = {
  r'localOnly': r'localOnly',
  r'syncPending': r'syncPending',
  r'synced': r'synced',
  r'conflict': r'conflict',
  r'deleted': r'deleted',
};
const _ExpenseShareModelsyncStatusValueEnumMap = {
  r'localOnly': SyncStatus.localOnly,
  r'syncPending': SyncStatus.syncPending,
  r'synced': SyncStatus.synced,
  r'conflict': SyncStatus.conflict,
  r'deleted': SyncStatus.deleted,
};

Id _expenseShareModelGetId(ExpenseShareModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _expenseShareModelGetLinks(
    ExpenseShareModel object) {
  return [];
}

void _expenseShareModelAttach(
    IsarCollection<dynamic> col, Id id, ExpenseShareModel object) {
  object.id = id;
}

extension ExpenseShareModelQueryWhereSort
    on QueryBuilder<ExpenseShareModel, ExpenseShareModel, QWhere> {
  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhere>
      anyExpenseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'expenseId'),
      );
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhere>
      anyMemberId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'memberId'),
      );
    });
  }
}

extension ExpenseShareModelQueryWhere
    on QueryBuilder<ExpenseShareModel, ExpenseShareModel, QWhereClause> {
  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
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

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
      expenseIdEqualTo(int expenseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'expenseId',
        value: [expenseId],
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
      expenseIdNotEqualTo(int expenseId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expenseId',
              lower: [],
              upper: [expenseId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expenseId',
              lower: [expenseId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expenseId',
              lower: [expenseId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'expenseId',
              lower: [],
              upper: [expenseId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
      expenseIdGreaterThan(
    int expenseId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expenseId',
        lower: [expenseId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
      expenseIdLessThan(
    int expenseId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expenseId',
        lower: [],
        upper: [expenseId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
      expenseIdBetween(
    int lowerExpenseId,
    int upperExpenseId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'expenseId',
        lower: [lowerExpenseId],
        includeLower: includeLower,
        upper: [upperExpenseId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
      memberIdEqualTo(int memberId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'memberId',
        value: [memberId],
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
      memberIdNotEqualTo(int memberId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'memberId',
              lower: [],
              upper: [memberId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'memberId',
              lower: [memberId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'memberId',
              lower: [memberId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'memberId',
              lower: [],
              upper: [memberId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
      memberIdGreaterThan(
    int memberId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'memberId',
        lower: [memberId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
      memberIdLessThan(
    int memberId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'memberId',
        lower: [],
        upper: [memberId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterWhereClause>
      memberIdBetween(
    int lowerMemberId,
    int upperMemberId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'memberId',
        lower: [lowerMemberId],
        includeLower: includeLower,
        upper: [upperMemberId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ExpenseShareModelQueryFilter
    on QueryBuilder<ExpenseShareModel, ExpenseShareModel, QFilterCondition> {
  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
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

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
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

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
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

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
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

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      expenseIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expenseId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      expenseIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expenseId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      expenseIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expenseId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      expenseIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expenseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
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

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
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

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
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

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      memberIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'memberId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      memberIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'memberId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      memberIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'memberId',
        value: value,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      memberIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'memberId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      percentageEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'percentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      percentageGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'percentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      percentageLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'percentage',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      percentageBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'percentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      settledAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'settledAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      settledAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'settledAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      settledAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'settledAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      settledAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'settledAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      syncStatusEqualTo(
    SyncStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      syncStatusGreaterThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      syncStatusLessThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      syncStatusBetween(
    SyncStatus lower,
    SyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      syncStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      syncStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      syncStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      syncStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      syncStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterFilterCondition>
      syncStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncStatus',
        value: '',
      ));
    });
  }
}

extension ExpenseShareModelQueryObject
    on QueryBuilder<ExpenseShareModel, ExpenseShareModel, QFilterCondition> {}

extension ExpenseShareModelQueryLinks
    on QueryBuilder<ExpenseShareModel, ExpenseShareModel, QFilterCondition> {}

extension ExpenseShareModelQuerySortBy
    on QueryBuilder<ExpenseShareModel, ExpenseShareModel, QSortBy> {
  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      sortByExpenseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseId', Sort.asc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      sortByExpenseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseId', Sort.desc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      sortByMemberId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberId', Sort.asc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      sortByMemberIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberId', Sort.desc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      sortByPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentage', Sort.asc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      sortByPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentage', Sort.desc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      sortBySettledAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settledAmount', Sort.asc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      sortBySettledAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settledAmount', Sort.desc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }
}

extension ExpenseShareModelQuerySortThenBy
    on QueryBuilder<ExpenseShareModel, ExpenseShareModel, QSortThenBy> {
  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      thenByExpenseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseId', Sort.asc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      thenByExpenseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseId', Sort.desc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      thenByMemberId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberId', Sort.asc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      thenByMemberIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberId', Sort.desc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      thenByPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentage', Sort.asc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      thenByPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'percentage', Sort.desc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      thenBySettledAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settledAmount', Sort.asc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      thenBySettledAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'settledAmount', Sort.desc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }
}

extension ExpenseShareModelQueryWhereDistinct
    on QueryBuilder<ExpenseShareModel, ExpenseShareModel, QDistinct> {
  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QDistinct>
      distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QDistinct>
      distinctByExpenseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expenseId');
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QDistinct>
      distinctByMemberId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'memberId');
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QDistinct>
      distinctByPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'percentage');
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QDistinct>
      distinctBySettledAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'settledAmount');
    });
  }

  QueryBuilder<ExpenseShareModel, ExpenseShareModel, QDistinct>
      distinctBySyncStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }
}

extension ExpenseShareModelQueryProperty
    on QueryBuilder<ExpenseShareModel, ExpenseShareModel, QQueryProperty> {
  QueryBuilder<ExpenseShareModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ExpenseShareModel, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<ExpenseShareModel, int, QQueryOperations> expenseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expenseId');
    });
  }

  QueryBuilder<ExpenseShareModel, int, QQueryOperations> memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'memberId');
    });
  }

  QueryBuilder<ExpenseShareModel, double, QQueryOperations>
      percentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'percentage');
    });
  }

  QueryBuilder<ExpenseShareModel, double, QQueryOperations>
      settledAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'settledAmount');
    });
  }

  QueryBuilder<ExpenseShareModel, SyncStatus, QQueryOperations>
      syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }
}
