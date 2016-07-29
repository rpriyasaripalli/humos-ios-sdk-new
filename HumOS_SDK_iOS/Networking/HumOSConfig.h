//
//  ApplicationConfig.h
//  Humos
//
//  Created by Kvana Mac Pro 2 on 12/17/15.
//  Copyright © 2015 Kvana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HumOSClientConstants.h"
@interface HumOSConfig : NSObject

//extern NSString *const kTV_ACCOUNT_ID;
//extern NSString *const kTV_VAULT_ID_PROVIDER;
//extern NSString *const kTV_VAULT_ID_PATIENT;
//extern NSString *const kTV_VAULT_ID_PROFILE_IMAGES;
//extern NSString *const kTV_VAULT_ID_MESSAGE;
//extern NSString *const kTV_VAULT_ID_FAVORITES;
//extern NSString *const kTV_VAULT_ID_MESSAGE_BLOBS;
//extern NSString *const kTV_VAULT_ID_CARDS;
//extern NSString *const kTV_VAULT_ID_PROVIDERS_GPS;
//extern NSString *const kTV_SCHEMA_PATIENT_REG;
//extern NSString *const kTV_SCHEMA_MESSAGE;
//extern NSString *const kTV_SCHEMA_CARD;
//extern NSString *const kTV_SCHEMA_PROVIDERS_GPS;
//extern NSString *const kTV_SCHEMA_VET;
//extern NSString *const kTV_VAULT_ID_VET_INFO;
//extern NSString *const kTV_VAULT_ID_VET_DISEASE;
//extern NSString *const kTV_VAULT_ID_INVITES;
//extern NSString *const kTV_VAULT_ID_HUMANAPI;
//extern NSString *const kTV_SCHEMA_HUMANAPI;

//Vaults
@property(nonatomic,strong) NSString* account_id;
@property(nonatomic,strong) NSString* vault_provider;
@property(nonatomic,strong) NSString* vault_patient;
@property(nonatomic,strong) NSString* vault_profile_image;
@property(nonatomic,strong) NSString* vault_favotite;
@property(nonatomic,strong) NSString* vault_message;
@property(nonatomic,strong) NSString* vault_message_blobs;
@property(nonatomic,strong) NSString* vault_cards;
@property(nonatomic,strong) NSString* vault_provider_gps;
@property(nonatomic,strong) NSString* vault_vet_info;
@property(nonatomic,strong) NSString* vault_vet_disease;
@property(nonatomic,strong) NSString* vault_invite;
@property(nonatomic,strong) NSString* vault_human_api;


//Schema
@property(nonatomic,strong) NSString* schema_patient_reg;
@property(nonatomic,strong) NSString* schema_message;
@property(nonatomic,strong) NSString* schema_card;
@property(nonatomic,strong) NSString* schema_provider_gps;
@property(nonatomic,strong) NSString* schema_vet;
@property(nonatomic,strong) NSString* schema_human_api;

typedef NS_ENUM (NSUInteger, Environment) {
    Testing,
    Production
};


+ (instancetype)config;
+ (instancetype)sharedInstance;
-(void)setAppConfig:(NSDictionary*)appConfig;
-(NSString*)baseURL;
+(NSString*)getSchemaFromClass:(HumOSClassName)className;
+(NSString*)getVaultIDFromClass:(HumOSClassName)className;
-(void) setBaseURL:(NSInteger)serverEnvironment;

@end
