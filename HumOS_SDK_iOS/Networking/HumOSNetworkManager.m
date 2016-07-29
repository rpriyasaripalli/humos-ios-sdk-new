//
//  HumOSNetworkManager.m
//  HumOSClient
//
//  Created by Kvana Mac Pro 2 on 2/12/16.
//  Copyright © 2016 Narendra. All rights reserved.
//

#import "HumOSNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "ParametersEncoder.h"
#import "MF_Base64Additions.h"
#import "HumOSClientConstants.h"
#import "HumOSConfig.h"
@interface HumOSNetworkManager ()
@property(nonatomic,strong) AFHTTPRequestOperation *operation;
@end

@implementation HumOSNetworkManager
-(instancetype)init{
    self = [super init];
    if (!self) return nil;
    return self;
}

-(void)cancel{
    [self.operation cancel];
}
-(void)isExecuting{
    [self.operation isExecuting];
}

-(void)isFinished{
    [self.operation isFinished];
}

#pragma mark - Truvault calls

-(void)searchDocumentsWithFilter:(NSDictionary*)filterDict vault:(NSString*)valultId access_key:(NSString*)access_key completion:(void (^)(id, NSError *))completion{
    
    NSString *requestURL=[NSString stringWithFormat:@"%@/v1/vaults/%@/search",kHOTruvaultBaseURL, valultId];
    NSError *error=nil;
    NSData *filterData=[NSJSONSerialization dataWithJSONObject:filterDict options:0 error:&error];
    NSString *baseEncodedString=[filterData base64EncodedStringWithOptions:0];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init ];
    [params setValue:baseEncodedString forKey:@"search_option"];
    NSString *paramsString=[ParametersEncoder getEncodedParameters:params];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"Basic %@", [[NSString stringWithFormat:@"%@:",access_key] base64String]] forHTTPHeaderField:kHOAuthorization];
    [request setHTTPBody: [paramsString dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    self.operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completion(responseObject,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
        completion(nil,error);
    }];
    [self.operation start];
}

-(void)saveDocumentWithDictionary:(NSDictionary*)documentDict access_key:(NSString*)access_key schema:(NSString*)schemaId vault:(NSString*)valultId completion:(void (^)(id, NSError *))completion{
    
    NSString *requestURL=[NSString stringWithFormat:@"%@/v1/vaults/%@/documents",kHOTruvaultBaseURL, valultId];
    NSError *error=nil;
    NSData *patientData=[NSJSONSerialization dataWithJSONObject:documentDict options:0 error:&error];
    NSString *baseEncodedString=[patientData base64EncodedStringWithOptions:0];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:baseEncodedString,@"document",nil];
    
    if (schemaId!=nil) {
        [params setObject:schemaId forKey:@"schema_id"];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request setValue:[NSString stringWithFormat:@"Basic %@", [[NSString stringWithFormat:@"%@:",access_key] base64String]] forHTTPHeaderField:kHOAuthorization];
    [request setHTTPMethod:@"POST"];
    NSString *paramsString=[ParametersEncoder getEncodedParameters:params];
    [request setHTTPBody: [paramsString dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    self.operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
        completion(nil,error);
    }];
    [self.operation start];
}

-(void)updateDocumentWithID:(NSString*)document_id document:(NSDictionary*)documentDict access_key:(NSString*)access_key vaultId:(NSString*)vaultId schema:(NSString*)schema completion:(void (^)(id, NSError *))completion{
    
    NSString *requestURL=[NSString stringWithFormat:@"%@/v1/vaults/%@/documents/%@",kHOTruvaultBaseURL, vaultId,document_id];
    NSError *error=nil;
    NSData *patientData=[NSJSONSerialization dataWithJSONObject:documentDict options:0 error:&error];
    NSString *baseEncodedString=[patientData base64EncodedStringWithOptions:0];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:baseEncodedString,@"document",nil];
    
    if (schema!=nil) {
        [params setObject:schema forKey:@"schema_id"];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request setValue:[NSString stringWithFormat:@"Basic %@", [[NSString stringWithFormat:@"%@:",access_key] base64String]] forHTTPHeaderField:kHOAuthorization];
    [request setHTTPMethod:@"PUT"];
    NSString *paramsString=[ParametersEncoder getEncodedParameters:params];
    [request setHTTPBody: [paramsString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    self.operation  = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    self.operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
        completion(nil,error);
    }];
    [self.operation start];
}

-(void)performUploadOperationWithData:(NSData*)data fileName:(NSString*)fileName mimeType:(NSString*)mimeType access_token:(NSString*)access_key vaultID:(NSString*)vaultID completion:(void (^)(NSDictionary *, NSError *))completion{
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kHOTruvaultBaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", [[NSString stringWithFormat:@"%@:",access_key] base64String]] forHTTPHeaderField:@"Authorization"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    AFHTTPRequestOperation *op = [manager POST:[NSString stringWithFormat:@"/v1/vaults/%@/blobs",vaultID] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:mimeType];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        completion(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
        completion(nil,error);
    }];
    
    [op start];
    
    
}

-(void)downloadFileWithURL:(NSString*)url access_token:(NSString*)access_key completion:(void (^)(NSString *, NSError *))completion{
    
    NSString *path =[NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.mp4"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", [[NSString stringWithFormat:@"%@:",access_key] base64String]] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/octet-stream",nil];
    self.operation = [manager GET:url
                                   parameters:nil
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSLog(@"successful download to %@", path);
                                          completion(path,nil);
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
                                          completion(nil,error);
                                      }];
    self.operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
}

@end
