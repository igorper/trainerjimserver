var links = angular.module('util.collections', []);

function toLookupById(itemsWithIds) {
  return toLookupByField(itemsWithIds, 'id');
}

function toLookupByField(itemsWithIds, fieldName) {
  return _.reduce(itemsWithIds, function (lookupById, item) {
    lookupById[item[fieldName]] = item;
    return lookupById;
  }, {});
}

function toLookupManyByField(items, fieldName) {
  return _.reduce(items, function (lookupById, item) {
    var key = item[fieldName];
    var list = lookupById[key];
    if (_.isUndefined(list)) {
      lookupById[key] = [item];
    } else {
      list.push(item);
    }
    return lookupById;
  }, {});
}