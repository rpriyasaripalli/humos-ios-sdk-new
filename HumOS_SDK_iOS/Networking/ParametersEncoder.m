//
//  ParametersEncoder.m
//  Humos
//
//  Created by Kvana Mac Pro 2 on 12/7/15.
//  Copyright © 2015 Kvana. All rights reserved.
//

#import "ParametersEncoder.h"

@implementation ParametersEncoder
+(NSString *)getEncodedParameters:(NSDictionary *)queryDictionary
{
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (NSString *key in queryDictionary) {
        [mutablePairs addObject:[NSString stringWithFormat:@"%@=%@", CTPercentEscapedQueryStringKeyFromStringWithEncoding(key, NSUTF8StringEncoding), CTPercentEscapedQueryStringValueFromStringWithEncoding(queryDictionary[key], NSUTF8StringEncoding)]];
    }
    
    return [[NSString alloc]initWithFormat:@"%@",[mutablePairs componentsJoinedByString:@"&"]];
}

static NSString * const kCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

static NSString * CTPercentEscapedQueryStringKeyFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";
    
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kCharactersToLeaveUnescapedInQueryStringPairKey, (__bridge CFStringRef)kCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

static NSString * CTPercentEscapedQueryStringValueFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}





+(NSData *)httpBodyForParamsDictionary:(NSDictionary *)paramDictionary
{
    
    NSString *string=[self getEncodedParameters:paramDictionary];    
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}
+ (NSString *)percentEscapeString:(NSString *)string
{
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, (CFStringRef)@" ", (CFStringRef)@":/?@!$&'()*+,;=", kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}


@end
