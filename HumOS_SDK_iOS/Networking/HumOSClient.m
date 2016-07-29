//
//  HumOSClient.m
//  HumOSClient
//
//  Created by Kvana Mac Pro 2 on 2/11/16.
//  Copyright © 2016 Narendra. All rights reserved.
//

#import "HumOSClient.h"
#import "HumOSNetworkManager.h"
#import "HumOSConfig.h"
#import "HumOSCloud.h"

@implementation HumOSClient

+(void)setBaseConfigWithCompletion:(void (^)(NSError *))completion{
    HumOSCloud *client = [[HumOSCloud alloc]init];
    [client getConfigWithCompletion:^(id response, NSError *error) {
        if (!error) {
            [[HumOSConfig config] setAppConfig:response];
            completion(nil);
        }else{ 
            completion(error);
        }
    }];
}


+(BOOL)hasBaseConfig{
    if ([HumOSConfig config].account_id != nil) {
        return YES;
    }else{
        return NO;
    }
}

+(void)save:(NSDictionary*)dict class:(HumOSClassName)className access_key:(NSString*)access_key completion:(void (^)(id, NSError *))completion{
    NSString *vaultId=[HumOSConfig getVaultIDFromClass:className];
    NSString *scemaID=[HumOSConfig getSchemaFromClass:className];
    HumOSNetworkManager *manager=[[HumOSNetworkManager alloc] init];
    [manager saveDocumentWithDictionary:dict access_key:access_key schema:scemaID vault:vaultId completion:completion];
}

+(void)update:(NSDictionary*)dict document_id:(NSString*)document_id access_key:(NSString*)access_key class:(HumOSClassName)className completion:(void (^)(id, NSError *))completion{
    NSString *vaultId=[HumOSConfig getVaultIDFromClass:className];
    NSString *scemaID=[HumOSConfig getSchemaFromClass:className];
    HumOSNetworkManager *manager=[[HumOSNetworkManager alloc] init];
    [manager updateDocumentWithID:document_id document:dict access_key:access_key vaultId:vaultId schema:scemaID completion:completion];

}

+(NSString*)getBlobURLForClass:(HumOSClassName)className blobId:(NSString*)blobId{
    return [NSString stringWithFormat:@"%@/v1/vaults/%@/blobs/%@",kHOTruvaultBaseURL,[HumOSConfig getVaultIDFromClass:className] ,blobId];
}

+(void)uploadFileToClass:(HumOSClassName)className data:(NSData*)data fileName:(NSString*)fileName mimeType:(NSString*)mimeType access_token:(NSString*)access_key completion:(void (^)(id, NSError *))completion{
    
    NSString *vaultId=[HumOSConfig getVaultIDFromClass:className];
    HumOSNetworkManager *manager=[[HumOSNetworkManager alloc] init];
    [manager performUploadOperationWithData:data fileName:fileName mimeType:mimeType access_token:access_key vaultID:vaultId completion:completion];
}

+(void)downloadFromURL:(NSString*)url access_token:(NSString*)access_key completion:(void (^)(NSString *, NSError *))completion{

    HumOSNetworkManager *manager=[[HumOSNetworkManager alloc] init];
    [manager downloadFileWithURL:url access_token:access_key completion:completion];
}

+(void)downloadBlobFromClass:(HumOSClassName)class blob_id:(NSString*)blob_id access_token:(NSString*)access_key completion:(void (^)(NSString *, NSError *))completion{
    NSString *url=[HumOSClient getBlobURLForClass:class blobId:blob_id];
    HumOSNetworkManager *manager=[[HumOSNetworkManager alloc] init];
    [manager downloadFileWithURL:url access_token:access_key completion:completion];
}



@end
