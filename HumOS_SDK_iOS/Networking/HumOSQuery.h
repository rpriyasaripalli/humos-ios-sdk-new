//
//  HumOSQuery.h
//  HumOSClient
//
//  Created by Kvana Mac Pro 2 on 2/12/16.
//  Copyright © 2016 Narendra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HumOSNetworkManager.h"

#import "HumOSClient.h"
@interface HumOSQuery : NSObject
@property(nonatomic,assign) NSInteger limit;
@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) NSString* filter_type;
@property(nonatomic,strong) NSString* full_document;
@property(nonatomic,strong) NSString* access_key;

-(instancetype)initQueryWithClass:(HumOSClassName)className access_key:(NSString*)access_key;

// Type = Equal(eq)
-(void)where:(NSString*)key isEquals:(NSString*)value case_sensitive:(BOOL)case_sensitive;

// Type = NotEqual(not)
-(void)where:(NSString*)key isNotEquals:(id)value case_sensitive:(BOOL)case_sensitive;

// Type = In Array(in)
-(void)where:(NSString*)key containsIn:(id)value case_sensitive:(BOOL)case_sensitive;

// Type = Not in Array(not_in)
-(void)where:(NSString*)key containsNotIn:(id)value case_sensitive:(BOOL)case_sensitive;

-(HumOSNetworkManager*)findResultsInBackgroundWithCompletion:(void (^)(id response, NSError *))completion;


@end
