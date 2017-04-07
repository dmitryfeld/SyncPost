//
//  NSString+Service.m
//  SyncPost
//
//  Created by Dmitry Feld on 4/6/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "NSString+Service.h"

@implementation NSString(Service)
+ (NSString*) stringWithDeviceID:(NSData*)deviceId {
    NSString *result = nil;
    if (deviceId.length) {
        result = [NSString stringWithFormat:@"%@",deviceId];
        result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"<" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@">" withString:@""];
    }
    return result;
}


@end
