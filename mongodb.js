/*
  Useful MongoDB queries
  Mainly FIND Operations
*/


// Find Document by ID
db.service.find({"_id": ObjectId("63xxxxxxxxxxxxxxxxxxxxbcb7")});

// Find String Contains

db.payments.find({"textHolder": {$regex: "63100xxxxxxxxxxxxxxxxbb3"}})
  .sort({_id: -1})
  .limit(100);

// Find Records with Specified Status and Date Range
db.service.find({
  "status": {"$nin": ['draft']},
  "created": {
    $gte: ISODate("2021-10-20T00:00:00.000Z"),
    $lt: ISODate("2021-11-16T00:00:00.000Z")
  }
})
.sort({_id: -1})
.limit(100);

// Find Records with a column exists
db.service.find({
  "rating.service": {"$exists": true}
})
.sort({_id: -1})
.limit(100);

// Find Documents without _id and in a Date Range
db.service.find({
  "_id": { $exists: false },
  "created": {
    $gte: ISODate("2021-10-21T00:00:00.000Z"),
    $lt: ISODate("2021-10-23T00:00:00.000Z")
  }
})
.sort({_id: -1})
.limit(100);

// Find Records with specific conditions using $or
db.service.find({
  "$or": [
    {
      "_id": {
        $gte: ISODate("2022-01-01T00:00:00.000Z"),
        $lt: ISODate("2022-03-02T00:00:00.000Z")
      },
      "status": {"$nin": ['draft']}
    },
    {
      "modified": {
        $gte: ISODate("2022-01-01T00:00:00.000Z"),
        $lt: ISODate("2022-03-02T00:00:00.000Z")
      },
      "status": {"$nin": ['draft']}
    }
  ]
}).count();

// find Minimum value
db.service.find().sort({created: 1}).limit(1);

db.claims.find({"created": {"$exists": true}}).sort({created: 1}).limit(1);

db.invoices.find().sort({created: 1}).limit(1);

// Find number of records in a period of time
db.taxes.find({
  "created": {
    $gte: ISODate("2023-05-11T00:00:00.000Z"),
    $lt: ISODate("2023-05-12T00:00:00.000Z")
  },
  "cars": {"$exists": true}
});

// Distinct query
db.purchases.distinct("name");
db.purchases.distinct("name.fr");
db.purchases.distinct("name.*");

// Count documents matching a query
db.purchases.find({"status": {"$ne": "draft"}, "created": {$gte: ISODate("2020-01-01T00:00:00.000Z")}}).count();

// More complex query
db.service.find({
  "$and": [
    {"status": {"$nin": ['draft']}, "created": {$gte: ISODate("2022-01-01T00:00:00.000Z")}},
    {"$or": [
      {"discount": {"$exists": true}},
      {"exampleField.nestedField": {"$in": ['1', '2', '3', '4']}},
      {"$and": [
        {"textField.name": {"$in": ['exampleText']}},
        {"anotherField": {"$exists": false}}
      ]}
    ]}
  ]
}).count();

// More complex and aggregated query
db.service.find({
  "$and": [
    {"status": {"$nin": ['draft']}, "created": {$gte: ISODate("2022-01-01T00:00:00.000Z")}},
    {"$or": [
      {"thisField": {"$exists": true}},
      {"exampleField.nestedField": {"$in": ['1', '2', '3', '4']}},
      {"$and": [
        {"textField.name": {"$in": ['exampleText']}},
        {"anotherField": {"$exists": false}}
      ]},
      {"thisGoInOr": {"$in": ['text', 'text2']}}
    ]}
  ]
}).count();


// Miscellaneous
db.service.stats();

db.purchases.find({
  "bread": {
    $exists: true,
    $elemMatch: { $ne: null }
  },
  "_id": { $nin: [
    ObjectId("62e336xxxxxxxxxxxxxx9a01"),
    ObjectId("645caaxxxxxxxxxxxxxxbbf0"),
    // ... (and so on)
  ] }
});
