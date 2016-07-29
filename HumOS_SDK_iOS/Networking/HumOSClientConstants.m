//
//  HumOSClientConstants.m
//  HumOSClient
//
//  Created by Kvana Mac Pro 2 on 2/12/16.
//  Copyright © 2016 Narendra. All rights reserved.
//

#import "HumOSClientConstants.h"

@implementation HumOSClientConstants

NSString *const HOQueryTypeEqual = @"eq";
NSString *const HOQueryTypeNotEqual = @"not";
NSString *const HOQueryTypeIn = @"in";
NSString *const HOQueryTypeNotIn = @"not_in";
NSString *const HOQueryTypeWildCard = @"wildcard";
NSString *const HOQueryTypeRange = @"range";
NSString *const HOQueryTypeRangeThanGreater = @"gt";
NSString *const HOQueryTypeRangeGreaterThanEqual = @"gte";
NSString *const HOQueryTypeRangeLessThan = @"lt";
NSString *const HOQueryTypeRangeLessThanEqual = @"lte";
NSString *const HOQueryGeoDistance = @"geo_distance";

NSString *const HOValueTrue = @"true";
NSString *const HOValueFalse = @"false";

NSString *const HOValueAnd = @"and";
NSString *const HOValueOr = @"or";

NSString *const HOOrderASC = @"asc";
NSString *const HOOrderDESC = @"desc";


NSString *const kHOQueryType = @"type";
NSString *const kHOQueryValue = @"value";
NSString *const kHOQueryCaseSensitive = @"case_sensitive";
NSString *const kHOQueryFliter = @"filter";
NSString *const kHOQueryFullDoc = @"full_document";
NSString *const kHOQueryFilterType = @"filter_type";
NSString *const kHOQueryPage = @"page";
NSString *const kHOQueryPerPage = @"per_page";
NSString *const kHOQuerySort = @"sort";

NSString *const kHOAuthorization = @"Authorization";
NSString *const kHOTruvaultBaseURL = @"https://api.truevault.com";

@end
