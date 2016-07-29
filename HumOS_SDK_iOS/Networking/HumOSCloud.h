//
//  HumOSCloud.h
//  HumOSClient
//
//  Created by Kvana Mac Pro 2 on 2/16/16.
//  Copyright © 2016 Narendra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HumOSCloud : NSObject
-(void)getConfigWithCompletion:(void (^)(id, NSError *))completion;
+(void)updateUser:(NSString*)user_id username:(NSString*)username password:(NSString*)password attributes:(NSString*)attributes withSuccessHandler:(void (^)(BOOL))success andFailure:(void (^)(NSError *))failure;
+(void)processInviteRequestForDocument:(NSString*)documentID withSuccessHandler:(void (^)(BOOL))success andFailure:(void (^)(NSError *))failure;
+(void)createProviderWithParams:(NSDictionary*)params withSuccessHandler:(void (^)(NSDictionary *, NSString *))success andFailure:(void (^)(NSError *))failure;
+(void)searchUserWithEmail:(NSString*)email phone:(NSString*)phone withSuccessHandler:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure;
+(void)searchUserWithPhone:(NSString*)phone withSuccessHandler:(void (^)(id))success andFailure:(void (^)(NSError *))failure;
//+(void)createProvider:(NSDictionary*)dict withSuccessHandler:(void (^)(id))success andFailure:(void (^)(NSError *))failure;
+(void)createPatient:(NSDictionary*)dict withSuccessHandler:(void (^)(NSDictionary*,NSString *))success andFailure:(void (^)(NSError *))failure;
//+(void)createPatientUser:(NSDictionary*)patient withSuccessHandler:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure;
//+(void)listAllUsersWithSuccessHandler:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure;
//+(void)is_provider_registeredWithPhone:(NSString*)phone email:(NSString*)email success:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure;
+(void)loginPatient:(NSString*)userName password:(NSString*)password token:(NSString*)token success:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure;
+(void)loginProvider:(NSString*)userName password:(NSString*)password token:(NSString*)token success:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure;
+(void)sendPushMessageForUserID:(NSString*)userId message:(NSDictionary*)message success:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure;
+(void)signoutUserWithAccessToken:(NSString*)access_token deviceToken:(NSString*)deviceToken success:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure;
+(void)createVerificationCodeForPatientPhone:(NSString *)phone :(NSString *)emailId documentId:(NSString *)documentId withSuccessHandler:(void (^)(void))success andFailure:(void (^)(NSError *))failure;
+(void)verifyForPatient:(NSString *)code documentId:(NSString *)documentId withSuccessHandler:(void (^)(NSString*))success andFailure:(void (^)(NSError *))failure;
+(void)createUser:(NSDictionary *)params withSuccessHandler:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure;
+(void)loginUser:(NSString*)userName password:(NSString*)password token:(NSString*)token usertype:(NSString *) type success:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure;
+(void)searchForUserWithIds:(NSArray *)userId accessToken:(NSString *)token withSucessHandler:(void(^)(NSMutableArray *userDetails))success andFailure:(void(^)(NSError *error))failure;
+(void)searchForMessagesWithChannelIds:(NSArray *)channesIds accessToken:(NSString *)token fromID:(NSString *)from toID:(NSString *)to success:(void (^)(NSDictionary*))success andFailure:(void (^)(NSError *))failure;


@end
