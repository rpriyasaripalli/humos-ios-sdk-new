//
//  HumOSQuery.m
//  HumOSClient
//
//  Created by Kvana Mac Pro 2 on 2/12/16.
//  Copyright © 2016 Narendra. All rights reserved.
//

#import "HumOSQuery.h"
#import "HumOSConfig.h"
@interface HumOSQuery ()
@property(nonatomic,strong) NSMutableDictionary *searchQueryDict;
@property(nonatomic,strong) NSMutableArray *sortArray;
@property(nonatomic,strong) NSString *vaultID;

@end

@implementation HumOSQuery

-(instancetype)initQueryWithClass:(HumOSClassName)className access_key:(NSString*)access_key{
    self = [super init];
    
    if (!self) return nil;
    self.limit=10;
    self.page=1;
    self.access_key=access_key;
    self.vaultID=[HumOSConfig getVaultIDFromClass:className];
    self.searchQueryDict=[[NSMutableDictionary alloc] init];
    self.sortArray=[[NSMutableArray alloc] init];
    return self;
}


-(void)where:(NSString*)key isEquals:(id)value case_sensitive:(BOOL)case_sensitive{
    [self addConstrinOnSearchQueryOfType:HOQueryTypeEqual key:key value:value case_sensitive:case_sensitive];
}

-(void)where:(NSString*)key isNotEquals:(id)value case_sensitive:(BOOL)case_sensitive{
    [self addConstrinOnSearchQueryOfType:HOQueryTypeNotEqual key:key value:value case_sensitive:case_sensitive];
}

-(void)where:(NSString*)key containsIn:(id)value case_sensitive:(BOOL)case_sensitive{
    [self addConstrinOnSearchQueryOfType:HOQueryTypeIn key:key value:value case_sensitive:case_sensitive];
}
-(void)where:(NSString*)key containsNotIn:(id)value case_sensitive:(BOOL)case_sensitive{
    [self addConstrinOnSearchQueryOfType:HOQueryTypeNotIn key:key value:value case_sensitive:case_sensitive];
}

// Key function to set constrian on filter

-(void)addConstrinOnSearchQueryOfType:(NSString*)type key:(NSString*)key value:(id)value case_sensitive:(BOOL)case_sensitive{
    if (type!=nil && value!=nil) {
        NSDictionary *contraint=[[NSDictionary alloc]initWithObjectsAndKeys: type,kHOQueryType, value,kHOQueryValue, case_sensitive,[NSNumber numberWithBool:case_sensitive], nil];
        [self.searchQueryDict setObject:contraint forKey:key];
    }
}

-(void)setLimit:(NSInteger)limit{
    NSAssert(limit<=0, @"Search limit should be an postive integer");
    self.limit=limit;
}

-(NSDictionary*)filterDict{
    
    NSMutableDictionary *filter=[[NSMutableDictionary alloc] init];
    
    
    
    return @{
        kHOQueryFliter :self.searchQueryDict,
        kHOQueryFullDoc : self.full_document,
        kHOQueryFilterType : [self filter_type],
        kHOQueryPage : [NSNumber numberWithInteger:self.page],
        kHOQueryPerPage : [NSNumber numberWithInteger:self.limit]//,
//        kHOQuerySort : @[
//                 @{
//                     @"first_name":HOOrderASC
//                 }
//                 ],
        };
}

-(NSString*)full_document{
    if (self.full_document==nil) {
        return HOValueTrue;
    }else{
        return self.full_document;
    }
}


-(NSString*)filter_type{
    if (self.filter_type==nil) {
        return HOValueOr;
    }else{
        return self.filter_type;
    }
}


-(HumOSNetworkManager*)findResultsInBackgroundWithCompletion:(void (^)(id response, NSError *))completion{
    HumOSNetworkManager *manager=[[HumOSNetworkManager alloc]init];
    [manager searchDocumentsWithFilter:[self filterDict] vault:self.vaultID access_key:self.access_key completion:completion];
    return manager;
}


@end
