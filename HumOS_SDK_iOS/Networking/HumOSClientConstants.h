//
//  HumOSClientConstants.h
//  HumOSClient
//
//  Created by Kvana Mac Pro 2 on 2/12/16.
//  Copyright © 2016 Narendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HumOSClientConstants : NSObject

#define HUMOS_CLASS_NAME_LENGTH 5u
typedef NS_ENUM(NSUInteger, HumOSClassName) {
    
    HumOSClassCards = 0u,
    HumOSClassMessages,
    HumOSClassMessageBlobs,
    HumOSClassPet,
    HumOSClassPetInfo,
    HumOSClassProvider,
    HumOSClassPatient,
    HumOSClassProfileImages
};

extern NSString *const HOQueryTypeEqual;
extern NSString *const HOQueryTypeNotEqual;
extern NSString *const HOQueryTypeIn;
extern NSString *const HOQueryTypeNotIn;
extern NSString *const HOQueryTypeWildCard;
extern NSString *const HOQueryTypeRange;
extern NSString *const HOQueryTypeRangeThanGreater;
extern NSString *const HOQueryTypeRangeGreaterThanEqual;
extern NSString *const HOQueryTypeRangeLessThan;
extern NSString *const HOQueryTypeRangeLessThanEqual;
extern NSString *const HOQueryGeoDistance;
extern NSString *const HOQueryTypeEqual;

extern NSString *const  HOValueTrue;
extern NSString *const  HOValueFalse;

extern NSString *const  HOValueAnd;
extern NSString *const  HOValueOr;

extern NSString *const  HOOrderASC;
extern NSString *const  HOOrderDESC;

extern NSString *const kHOQueryType;
extern NSString *const kHOQueryValue;
extern NSString *const kHOQueryCaseSensitive;
extern NSString *const kHOQueryFliter;
extern NSString *const kHOQueryFullDoc;
extern NSString *const kHOQueryFilterType;
extern NSString *const kHOQueryPage;
extern NSString *const kHOQueryPerPage;
extern NSString *const kHOQuerySort;

extern NSString *const kHOAuthorization;
extern NSString *const kHOTruvaultBaseURL;


@end
