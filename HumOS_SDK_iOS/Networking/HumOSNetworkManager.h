//
//  HumOSNetworkManager.h
//  HumOSClient
//
//  Created by Kvana Mac Pro 2 on 2/12/16.
//  Copyright © 2016 Narendra. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HumOSNetworkManager : NSObject

//Truevault calls
-(void)searchDocumentsWithFilter:(NSDictionary*)filterDict vault:(NSString*)valultId access_key:(NSString*)access_key completion:(void (^)(id, NSError *))completion;
-(void)saveDocumentWithDictionary:(NSDictionary*)documentDict access_key:(NSString*)access_key schema:(NSString*)schemaId vault:(NSString*)valultId completion:(void (^)(id, NSError *))completion;
-(void)updateDocumentWithID:(NSString*)document_id document:(NSDictionary*)documentDict access_key:(NSString*)access_key vaultId:(NSString*)vaultId schema:(NSString*)schema completion:(void (^)(id, NSError *))completion;
-(void)performUploadOperationWithData:(NSData*)data fileName:(NSString*)fileName mimeType:(NSString*)mimeType access_token:(NSString*)access_key vaultID:(NSString*)vaultID completion:(void (^)(NSDictionary *, NSError *))completion;
-(void)downloadFileWithURL:(NSString*)url access_token:(NSString*)access_key completion:(void (^)(NSString *, NSError *))completion;
@end
