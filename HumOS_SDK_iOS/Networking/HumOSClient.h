//
//  HumOSClient.h
//  HumOSClient
//
//  Created by Kvana Mac Pro 2 on 2/11/16.
//  Copyright © 2016 Narendra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HumOSClientConstants.h"
@interface HumOSClient : NSObject


+(void)save:(NSDictionary*)dict class:(HumOSClassName)className access_key:(NSString*)access_key completion:(void (^)(id, NSError *))completion;
+(void)update:(NSDictionary*)dict document_id:(NSString*)document_id access_key:(NSString*)access_key class:(HumOSClassName)className completion:(void (^)(id, NSError *))completion;

+(void)setBaseConfigWithCompletion:(void (^)(NSError *))completion;
+(BOOL)hasBaseConfig;
+(NSString*)getBlobURLForClass:(HumOSClassName)className blobId:(NSString*)blobId;
+(void)downloadBlobFromClass:(HumOSClassName)class blob_id:(NSString*)blob_id access_token:(NSString*)access_key completion:(void (^)(NSString *, NSError *))completion;
+(void)downloadFromURL:(NSString*)url access_token:(NSString*)access_key completion:(void (^)(NSString *, NSError *))completion;
@end
