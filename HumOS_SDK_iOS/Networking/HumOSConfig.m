//
//  ApplicationConfig.m
//  Humos
//
//  Created by Kvana Mac Pro 2 on 12/17/15.
//  Copyright © 2015 Kvana. All rights reserved.
//

#import "HumOSConfig.h"

@implementation HumOSConfig
NSString *const kTV_ACCOUNT_ID=@"TV_ACCOUNT_ID";
NSString *const kTV_VAULT_ID_PROVIDER= @"TV_VAULT_ID_PROVIDER";
NSString *const kTV_VAULT_ID_PATIENT= @"TV_VAULT_ID_PATIENT";
NSString *const kTV_VAULT_ID_PROFILE_IMAGES =@"TV_VAULT_ID_PROFILE_IMAGES";
NSString *const kTV_VAULT_ID_MESSAGE =@"TV_VAULT_ID_MESSAGE";
NSString *const kTV_VAULT_ID_FAVORITES= @"TV_VAULT_ID_FAVORITES";
NSString *const kTV_VAULT_ID_MESSAGE_BLOBS =@"TV_VAULT_ID_MESSAGE_BLOBS";
NSString *const kTV_VAULT_ID_CARDS =@"TV_VAULT_ID_CARDS";
NSString *const kTV_VAULT_ID_PROVIDERS_GPS =@"TV_VAULT_ID_PROVIDERS_GPS";
NSString *const kTV_SCHEMA_PATIENT_REG = @"TV_SCHEMA_PATIENT_REG";
NSString *const kTV_SCHEMA_MESSAGE = @"TV_SCHEMA_MESSAGE";
NSString *const kTV_SCHEMA_CARD = @"TV_SCHEMA_CARD";
NSString *const kTV_SCHEMA_PROVIDERS_GPS =@"TV_SCHEMA_PROVIDERS_GPS";
NSString *const kTV_SCHEMA_VET = @"TV_SCHEMA_VET";
NSString *const kTV_VAULT_ID_VET_INFO =@"TV_VAULT_ID_VET_INFO";
NSString *const kTV_VAULT_ID_VET_DISEASE =@"TV_VAULT_ID_VET_DISEASE";
NSString *const kTV_VAULT_ID_INVITES = @"TV_VAULT_ID_INVITES";
NSString *const kTV_VAULT_ID_HUMANAPI =@"TV_VAULT_ID_HUMANAPI";
NSString *const kTV_SCHEMA_HUMANAPI =@"TV_SCHEMA_HUMANAPI";


NSString *const CF_PRODUCTION_BASE_URL=@"https://sikkacfprovider.mybluemix.net";
NSString *const CF_UAT_BASE_URL=@"https://humos-staging.mybluemix.net";
NSString *const HEROKU_BASE_URL=@"https://humos.herokuapp.com";
static NSString *baseURL;



+ (instancetype)config {
    static HumOSConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}

+ (instancetype)sharedInstance {
    static HumOSConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}


-(NSString*)baseURL{
    return baseURL;
}

-(void) setBaseURL:(NSInteger)serverEnvironment {
    switch ((Environment)serverEnvironment) {
        case Testing:
            baseURL = CF_UAT_BASE_URL;
            break;
            
        case Production:
            baseURL = CF_PRODUCTION_BASE_URL;
            break;
            
        default:
            break;
    }
}

-(void)setAppConfig:(NSDictionary*)appConfig{
    self.account_id=appConfig[kTV_ACCOUNT_ID];
    self.vault_cards=appConfig[kTV_VAULT_ID_CARDS];
    self.vault_favotite=appConfig[kTV_VAULT_ID_FAVORITES];
    self.vault_human_api=appConfig[kTV_VAULT_ID_HUMANAPI];
    self.vault_invite=appConfig[kTV_VAULT_ID_INVITES];
    self.vault_message=appConfig[kTV_VAULT_ID_MESSAGE];
    self.vault_message_blobs=appConfig[kTV_VAULT_ID_MESSAGE_BLOBS];
    self.vault_patient=appConfig[kTV_VAULT_ID_PATIENT];
    self.vault_profile_image=appConfig[kTV_VAULT_ID_PROFILE_IMAGES];
    self.vault_provider=appConfig[kTV_VAULT_ID_PROVIDER];
    self.vault_provider_gps=appConfig[kTV_VAULT_ID_PROVIDERS_GPS];
    self.vault_vet_disease=appConfig[kTV_VAULT_ID_VET_DISEASE];
    self.vault_vet_info=appConfig[kTV_VAULT_ID_VET_INFO];
    self.schema_card=appConfig[kTV_SCHEMA_CARD];
    self.schema_human_api=appConfig[kTV_SCHEMA_HUMANAPI];
    self.schema_message=appConfig[kTV_SCHEMA_MESSAGE];
    self.schema_patient_reg=appConfig[kTV_SCHEMA_PATIENT_REG];
    self.schema_provider_gps=appConfig[kTV_SCHEMA_PROVIDERS_GPS];
    self.schema_vet=appConfig[kTV_SCHEMA_VET];
    
}


-(void)setAccount_id:(NSString *)account_id{
    [self setValue:account_id forKey:kTV_ACCOUNT_ID];
}

-(void)setVault_cards:(NSString *)vault_cards{
    [self setValue:vault_cards forKey:kTV_VAULT_ID_CARDS];
}

-(void)setVault_favotite:(NSString *)vault_favotite{
    [self setValue:vault_favotite forKey:kTV_VAULT_ID_FAVORITES];
}

-(void)setVault_human_api:(NSString *)vault_human_api{
    [self setValue:vault_human_api forKey:kTV_VAULT_ID_HUMANAPI];

}

-(void)setVault_invite:(NSString *)vault_invite{
    [self setValue:vault_invite forKey:kTV_VAULT_ID_INVITES];

}
-(void)setVault_message:(NSString *)vault_message{
    [self setValue:vault_message forKey:kTV_VAULT_ID_MESSAGE];
}
-(void)setVault_message_blobs:(NSString *)vault_message_blobs{
    [self setValue:vault_message_blobs forKey:kTV_VAULT_ID_MESSAGE_BLOBS];

}
-(void)setVault_patient:(NSString *)vault_patient{
    [self setValue:vault_patient forKey:kTV_VAULT_ID_PATIENT];

}

-(void)setVault_profile_image:(NSString *)vault_profile_image{
    [self setValue:vault_profile_image forKey:kTV_VAULT_ID_PROFILE_IMAGES];

}

-(void)setVault_provider:(NSString *)vault_provider{
    [self setValue:vault_provider forKey:kTV_VAULT_ID_PROVIDER];

}

-(void)setVault_provider_gps:(NSString *)vault_provider_gps{
    [self setValue:vault_provider_gps forKey:kTV_VAULT_ID_PROVIDERS_GPS];

}

-(void)setVault_vet_disease:(NSString *)vault_vet_disease{
    [self setValue:vault_vet_disease forKey:kTV_VAULT_ID_VET_DISEASE];

}

-(void)setVault_vet_info:(NSString *)vault_vet_info{
    [self setValue:vault_vet_info forKey:kTV_VAULT_ID_VET_INFO];

}
-(void)setSchema_card:(NSString *)schema_card{
    [self setValue:schema_card forKey:kTV_SCHEMA_CARD];

}

-(void)setSchema_human_api:(NSString *)schema_human_api{
    [self setValue:schema_human_api forKey:kTV_SCHEMA_HUMANAPI];

}
-(void)setSchema_message:(NSString *)schema_message{
    [self setValue:schema_message forKey:kTV_SCHEMA_MESSAGE];

}
-(void)setSchema_patient_reg:(NSString *)schema_patient_reg{
    [self setValue:schema_patient_reg forKey:kTV_SCHEMA_PATIENT_REG];

}
-(void)setSchema_provider_gps:(NSString *)schema_provider_gps{
    [self setValue:schema_provider_gps forKey:kTV_SCHEMA_PROVIDERS_GPS];

}
-(void)setSchema_vet:(NSString *)schema_vet{
    [self setValue:schema_vet forKey:kTV_SCHEMA_VET];

}

-(NSString *)account_id{
    return [self valueForKey:kTV_ACCOUNT_ID];
}

-(NSString*)vault_cards{
    return [self valueForKey:kTV_VAULT_ID_CARDS];
}

-(NSString*)vault_favotite{
    return [self valueForKey:kTV_VAULT_ID_FAVORITES];

}
-(NSString*)vault_human_api{
    return [self valueForKey:kTV_VAULT_ID_HUMANAPI];

}

-(NSString*)vault_invite{
    return [self valueForKey:kTV_VAULT_ID_INVITES];

}
-(NSString*)vault_message{
    return [self valueForKey:kTV_VAULT_ID_MESSAGE];
}
-(NSString*)vault_message_blobs{
    return [self valueForKey:kTV_VAULT_ID_MESSAGE_BLOBS];
}

-(NSString*)vault_patient{
    return [self valueForKey:kTV_VAULT_ID_PATIENT];
}

-(NSString*)vault_profile_image{
    return [self valueForKey:kTV_VAULT_ID_PROFILE_IMAGES];

}

-(NSString*)vault_provider{
    return [self valueForKey:kTV_VAULT_ID_PROVIDER];

}

-(NSString*)vault_provider_gps{
    return [self valueForKey:kTV_VAULT_ID_PROVIDERS_GPS];

}

-(NSString*)vault_vet_disease{
    return [self valueForKey:kTV_VAULT_ID_VET_DISEASE];

}

-(NSString*)vault_vet_info{
    return [self valueForKey:kTV_VAULT_ID_VET_INFO];

}

-(NSString*)schema_card{
    return [self valueForKey:kTV_SCHEMA_CARD];

}

-(NSString*)schema_human_api{
    return [self valueForKey:kTV_SCHEMA_HUMANAPI];

}
-(NSString*)schema_message{
    return [self valueForKey:kTV_SCHEMA_MESSAGE];

}
-(NSString*)schema_patient_reg{
    return [self valueForKey:kTV_SCHEMA_PATIENT_REG];

}
-(NSString*)schema_provider_gps{
    return [self valueForKey:kTV_SCHEMA_PROVIDERS_GPS];

}
-(NSString*)schema_vet{
    return [self valueForKey:kTV_SCHEMA_VET];

}

-(void)setValue:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)removeValueForKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(id)valueForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}
+(NSString*)getSchemaFromClass:(HumOSClassName)className{
    NSString *scemaID;
    
    switch (className) {
        case HumOSClassCards:
            scemaID = [HumOSConfig config].schema_card;
            break;
        case HumOSClassMessages:
            scemaID = [HumOSConfig config].schema_message;
            break;
        case HumOSClassPet:
            scemaID = [HumOSConfig config].schema_vet;
            break;
        case HumOSClassProvider:
            scemaID = [HumOSConfig config].schema_provider_gps;
            break;
        case HumOSClassPatient:
            scemaID = [HumOSConfig config].schema_patient_reg;
            break;
        case HumOSClassPetInfo:
            break;
        case HumOSClassProfileImages:
            break;
        default:
            break;
    }
    return scemaID;
}
+(NSString*)getVaultIDFromClass:(HumOSClassName)className{
    NSString *vaultId;
    switch (className) {
        case HumOSClassCards:
            vaultId = [HumOSConfig config].vault_cards;
            break;
        case HumOSClassMessages:
            vaultId = [HumOSConfig config].vault_message;
            break;
        case HumOSClassPet:
            vaultId = [HumOSConfig config].vault_vet_disease;
            break;
        case HumOSClassProvider:
            vaultId = [HumOSConfig config].vault_provider_gps;
            break;
        case HumOSClassPatient:
            vaultId = [HumOSConfig config].vault_patient;
            break;
        case HumOSClassPetInfo:
            vaultId = [HumOSConfig config].vault_vet_info;
            break;
        case HumOSClassProfileImages:
            vaultId = [HumOSConfig config].vault_profile_image;
            break;
        case HumOSClassMessageBlobs:
            vaultId = [HumOSConfig config].vault_message_blobs;
            break;
        default:
            break;
    }
    return vaultId;
}


@end
