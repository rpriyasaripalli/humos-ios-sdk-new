//
//  HumOSCloud.m
//  HumOSClient
//
//  Created by Kvana Mac Pro 2 on 2/16/16.
//  Copyright © 2016 Narendra. All rights reserved.
//

#import "HumOSCloud.h"
#import <AFNetworking/AFNetworking.h>
#import "HumOSConfig.h"
@interface HumOSCloud ()
@property(nonatomic,strong) AFHTTPRequestOperation *operation;
@end

@implementation HumOSCloud
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
#pragma mark - Cloud calls

-(void)getConfigWithCompletion:(void (^)(id, NSError *))completion{
    
    NSString *urlStr=[NSString stringWithFormat:@"%@/api/v1/users/vaults",[[HumOSConfig config] baseURL]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    self.operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *config=[[NSMutableDictionary alloc]initWithDictionary:responseObject[@"data"]];
        completion(config,nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
        completion(nil,error);
    }];
    [self.operation start];
}


+(void)processInviteRequestForDocument:(NSString*)documentID withSuccessHandler:(void (^)(BOOL))success andFailure:(void (^)(NSError *))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v1/send_invite_email_sms",[[HumOSConfig config] baseURL]];
    NSDictionary *params=@{@"document_id":documentID};
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject valueForKey:@"status"] isEqualToString:@"success"]) {
            success(YES);
        }else{
            success(NO);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error);
        NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
    }];
}




+(void)updateUser:(NSString*)user_id username:(NSString*)username password:(NSString*)password attributes:(NSString*)attributes withSuccessHandler:(void (^)(BOOL))success andFailure:(void (^)(NSError *))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v1/users",[[HumOSConfig config] baseURL]];
    
    //Exception check to be safe
    @try {
        NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithDictionary:@{@"user_id":user_id,@"username":username,@"attributes":attributes}];
        if (password) {
            [params setObject:password forKey:@"password"];
        }
        [manager PUT:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([[responseObject valueForKey:@"status"] isEqualToString:@"success"]) {
                success(YES);
            }else{
                success(NO);
            }
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            failure(error);
            NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"HumOSCloud Exception in updateUser :%@",exception);
        failure(nil);
        
    }
}

+(void)createProviderWithParams:(NSDictionary*)params withSuccessHandler:(void (^)(NSDictionary *, NSString *))success andFailure:(void (^)(NSError *))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v1/create_provider",[[HumOSConfig config] baseURL]];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject[@"status"] isEqualToString:@"EXIST"]){
            success(nil,responseObject[@"status"]);
        }else{
            success(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
        failure(error);
    }];
}

+(void)searchUserWithEmail:(NSString*)email phone:(NSString*)phone withSuccessHandler:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v1/is_user_exist",[[HumOSConfig config] baseURL]];
    //    NSDictionary *params=@{@"email":email,@"phone":phone};
    NSDictionary *params=@{@"phone":phone};
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject valueForKey:@"response"][@"data"][@"documents"] count]>0) {
            success([[responseObject valueForKey:@"response"][@"data"][@"documents"] firstObject]);
        }else{
            success(nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
        failure(error);
    }];
}


+(void)searchUserWithPhone:(NSString*)phone withSuccessHandler:(void (^)(id))success andFailure:(void (^)(NSError *))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v1/is_user_exist",[[HumOSConfig config] baseURL]];
    NSDictionary *params=@{@"phone":phone};
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject valueForKey:@"response"][@"data"][@"documents"] count]>0) {

            NSError *err=nil;
            if (err) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    failure(err);
                    
                });
                
                return;
            }
            
            success([[responseObject valueForKey:@"response"][@"data"][@"documents"] firstObject]);
        }else{
            success(nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
        failure(error);
    }];
}

+(void)createProvider:(NSDictionary*)params withSuccessHandler:(void (^)(id))success andFailure:(void (^)(NSError *))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v1/users",[[HumOSConfig config] baseURL]];
//    NSDictionary *params=[provider dictForCreateUser];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
        failure(error);
    }];
}
//
+(void)createPatient:(NSDictionary*)params withSuccessHandler:(void (^)(NSDictionary*,NSString *))success andFailure:(void (^)(NSError *))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v1/create_patient",[[HumOSConfig config] baseURL]];
//    NSDictionary *params=[patient dictionaryForPatient];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"EXIST"]) {
            success(nil,responseObject[@"status"]);
            return ;
        }
//        patient.documentId=responseObject[@"document_id"];
        success(responseObject,nil);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
        failure(error);
    }];
    
}
//
+(void)createPatientUser:(NSDictionary*)params withSuccessHandler:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v1/users",[[HumOSConfig config] baseURL]];
//    NSDictionary *params=[patient dictionaryForPatientUser];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error);
    }];
    
    
}

+(void)createVerificationCodeForPatientPhone:(NSString *)phone :(NSString *)emailId documentId:(NSString *)documentId withSuccessHandler:(void (^)(void))success andFailure:(void (^)(NSError *))failure{
    
    NSDictionary *params=@{@"vault_id":[HumOSConfig config].vault_patient,@"document_id":documentId,@"phone_number":phone ,@"email":emailId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v1/create_verification_code",[[HumOSConfig config] baseURL]];
    //    NSDictionary *params=[patient dictionaryForPatientUser];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error);
    }];

    
    
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[ NSString stringWithFormat:@"%@/api/v1/create_verification_code",[[HumOSConfig config] baseURL]]]];
//    request.HTTPMethod=@"POST";
//    
//    NSError *error=nil;
//    NSData *postData=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
//    //   NSData *postData=[params dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSString *str=[[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",str);
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    request.HTTPBody=postData;
//    
//    NSURLSessionDataTask *dataTask=[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSString *string=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",string);
//        if (error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                failure(error);
//            });
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                success();
//            });
//            
//        }
//    }];
//    
//    [dataTask resume];
    
}

+(void)verifyForPatient:(NSString *)code documentId:(NSString *)documentId withSuccessHandler:(void (^)(NSString*))success andFailure:(void (^)(NSError *))failure{
    
    NSDictionary *params=@{@"vault_id":[HumOSConfig config].vault_patient,@"document_id":documentId,@"verification_code":code};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v1/validate_verification_code",[[HumOSConfig config] baseURL]];
    //    NSDictionary *params=[patient dictionaryForPatientUser];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success([(NSDictionary *)responseObject objectForKey:@"status"]);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error);
    }];

    
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v1/validate_verification_code",[[ApplicationConfig config] baseURL]]]];
//    request.HTTPMethod=@"POST";
//    NSError *error=nil;
//    NSData *postData=[NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
//    request.HTTPBody=postData;
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    NSURLSessionDataTask *dataTask=[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                failure(error);
//            });
//        }else{
//            NSError *err=nil;
//            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
//            if (err) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    failure(err);
//                });
//                return;
//            }
//            if ([dic[@"status"] isEqualToString:@"SUCCESS"]) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    success();
//                });
//            }else{
//                NSError *customError=[TVUtilities errorForMessage:@"Verification Incorrect, please reenter"];
//                failure(customError);
//            }
//        }
//    }];
//    
//    [dataTask resume];
    
    
}


//+(void)listAllUsersWithSuccessHandler:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    NSString *url=[NSString stringWithFormat:@"%@/api/v1/users/all",[[HumOSConfig config] baseURL]];
//    
//    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (responseObject[@"result"]) {
//            success(responseObject[@"result"]);
//        }else{
//            failure(nil);
//        }
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        failure(error);
//    }];
//    
//}

//+(void)is_provider_registeredWithPhone:(NSString*)phone email:(NSString*)email success:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    NSString *url=[NSString stringWithFormat:@"%@/api/v1/is_provider_registered",[[HumOSConfig config] baseURL]];
//    NSDictionary *params=@{@"email":email,@"phone":phone};
//    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        success(responseObject);
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
//        failure(error);
//    }];
//    
//}


+(void)createUser:(NSDictionary*)params withSuccessHandler:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v2/users",[[HumOSConfig config] baseURL]];
    //NSDictionary *params=[patient dictionaryForPatientUser];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failure(error);
    }];
}


+(void)loginUser:(NSString*)userName password:(NSString*)password token:(NSString*)token usertype:(NSString *) type success:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v1/login",[[HumOSConfig config] baseURL]];
    NSDictionary *params=@{@"username":userName,@"password":password,@"user_type":type, @"type":@"ios",@"token":token};
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
        failure(error);
    }];
}

+(void)loginProvider:(NSString*)userName password:(NSString*)password token:(NSString*)token success:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v2/login",[[HumOSConfig config] baseURL]];
    NSDictionary *params=@{@"username":userName,@"password":password,@"user_type":@"provider",@"type":@"ios",@"token":token};
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
        failure(error);
    }];
    
}

+(void)sendPushMessageForUserID:(NSString*)userId message:(NSDictionary*)message success:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url;
    
#ifdef DEBUG
    
    url=[NSString stringWithFormat:@"%@/api/v1/dev_push_notification",[[HumOSConfig config] baseURL]];
#else
    
    url=[NSString stringWithFormat:@"%@/api/v1/push_notification",[[HumOSConfig config] baseURL]];
    
#endif
    
    NSDictionary *params=@{@"user_id":userId,@"message":message};
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
        failure(error);
    }];
    
}

+(void)signoutUserWithAccessToken:(NSString*)access_token deviceToken:(NSString*)deviceToken success:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v1/logout",[[HumOSConfig config] baseURL]];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    if (access_token) {
        [params setObject:access_token forKey:@"access_token"];
    }
    if (deviceToken) {
        [params setObject:deviceToken forKey:@"token"];
        
    }
    //@{@"access_token":access_token,@"token":deviceToken};
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
        failure(error);
    }];
    
}

+(void)getUserWithId:(NSString*)access_token userID: (NSString *)userId success:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v1/users",[[HumOSConfig config] baseURL]];
    NSMutableDictionary *params = [@{@"Authorization":access_token} mutableCopy];
    params[@{@"filter":
                 @{@"$tv.id":
                       @{@"type":@"in",@"value":userId,
                        }
                }
            }];
    params[@"full_document"]=@YES;
    params[@"filter_type"]=@"and";
    
    params[@"page"]=@1;
    params[@"per_page"]=@20;

    
    //@{@"access_token":access_token,@"token":deviceToken};
    [manager POST:@"https://api.truevault.com/v1/users/search" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
        failure(error);
    }];
    
}


+(NSURLSession *)setSession: (NSString *)token{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString *authString = [NSString stringWithFormat:@"%@:",token];
    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authHeader = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    
    [sessionConfig setHTTPAdditionalHeaders:@{@"Authorization": authHeader}];
    
    return [NSURLSession sessionWithConfiguration:sessionConfig];
    
}

+(void)searchForUserWithIds:(NSArray *)userId accessToken:(NSString *)token withSucessHandler:(void(^)(NSMutableArray *userDetails))success andFailure:(void(^)(NSError *error))failure{

    NSMutableDictionary *searchDic=[@{@"filter":@{
                                              @"$tv.id":@{
                                                      @"type":@"in",
                                                      @"value":userId,
                                                      }
                                              }
                                      } mutableCopy];
    searchDic[@"full_document"]=@YES;
    searchDic[@"filter_type"]=@"and";
    
    searchDic[@"page"]=@1;
    searchDic[@"per_page"]=@20;
    
    NSString *urlStr=@"https://api.truevault.com/v1/users/search";
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSError *error=nil;
    NSData *patientData=[NSJSONSerialization dataWithJSONObject:searchDic options:0 error:&error];
    
    NSString *baseEncodedString=[patientData base64EncodedStringWithOptions:0];
    
    NSString *postString=[NSString stringWithFormat:@"search_option=%@",baseEncodedString];
    request.HTTPMethod=@"POST";
    NSData *postData=[postString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody=postData;
    
    NSURLSessionDataTask *task=[[HumOSCloud setSession:token] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                failure(error);
                
            });
            NSLog(@"error %@",error.localizedDescription);
            return;
            
        }
        
        
        NSError *err=nil;
        
        
        NSDictionary *results=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                failure(err);
                
            });
            NSLog(@"error %@",error.localizedDescription);
            return;
            
        }
        NSMutableArray *usersArray=[[NSMutableArray alloc]init];
        
        NSDictionary *resultData=results[@"data"];
        if ([resultData[@"info"][@"total_result_count"] integerValue]>0) {
            NSArray *resultDocs=resultData[@"documents"];
            
            for (int i = 0; i < [resultDocs count]; i++){
                NSString *encodedString=[NSString stringWithFormat:@"%@",[resultDocs[i] valueForKey:@"attributes"]];
                
                NSData *docData=[[NSData alloc]initWithBase64EncodedString:encodedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
                err=nil;
                NSMutableDictionary *docDictionary=[[NSMutableDictionary alloc]init];
                
                [docDictionary addEntriesFromDictionary:[NSJSONSerialization JSONObjectWithData:docData options:NSJSONReadingAllowFragments error:&err]];
                [docDictionary setObject:[resultDocs[i] valueForKey:@"user_id"] forKey:@"user_id"];
                if (err) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        failure(err);
                        
                    });
                    NSLog(@"error %@",error.localizedDescription);
                    return;
                    
                }
                [usersArray addObject:docDictionary];
                
            }
        }
        if (usersArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(usersArray);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(nil);
            });
        }
        
    }];
    [task resume];
    
}


+(void)searchForMessagesWithChannelIds:(NSArray*)channesIds accessToken:(NSString *)token fromID:(NSString *)from toID:(NSString *)to success:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url=[NSString stringWithFormat:@"%@/api/v2/messages/search",[[HumOSConfig config] baseURL]];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"access_token"];
    [params setObject:from forKey:@"from_uid"];
    [params setObject:to forKey:@"to_uid"];

    NSMutableDictionary *searchDic=[@{@"filter":@{
                                              @"channel":@{
                                                      @"type":@"in",
                                                      @"value":channesIds,
                                                      @"case_sensitive":@NO
                                                      }
                                              }
                                      } mutableCopy];
    
    //NSArray *sortArray=[NSArray arrayWithObject:@{@"timestamp":@"asc"}];
    NSArray *sortArray=[NSArray arrayWithObject:@{@"timestamp":@"desc"}];
    
    searchDic[@"sort"]=sortArray;
    searchDic[@"full_document"]=@YES;
    searchDic[@"filter_type"]=@"and";
    searchDic[@"page"]=@1;
    searchDic[@"per_page"]=@500;
    [params setObject:searchDic forKey:@"search_option"];

    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%s: HumOSCloud error: %@", __FUNCTION__, error);
        failure(error);
    }];
    
}


@end
