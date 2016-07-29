//
//  ParametersEncoder.h
//  Humos
//
//  Created by Kvana Mac Pro 2 on 12/7/15.
//  Copyright © 2015 Kvana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParametersEncoder : NSObject
+(NSString *)getEncodedParameters:(NSDictionary *)queryDictionary;
+(NSData *)httpBodyForParamsDictionary:(NSDictionary *)paramDictionary;
@end
