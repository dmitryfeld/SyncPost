//
//  NSError+Rest.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "NSError+Rest.h"

const NSString* kTPMGRestErrorDomain = @"kTPMGRestErrorDomain";

@implementation NSError(Rest)
+ (NSString*) restStringForCode:(TPMGRestUnitErrorCodes)code {
    NSString* result = nil;
    
    switch (code) {
        case kTPMGRestErrorCodeOK:
            result = @"No Error";
            break;
        case kTPMGRestErrorGeneralFailure:
            result = @"General Failure";
            break;
        case kTPMGRestErrorCodeNoData:
            result = @"No Data Returned";
            break;
        case kTPMGRestErrorFailureToParseJSONError:
            result = @"Unparsable Data Dictionary";
            break;
        case kTPMGRestErrorInvalidResponseObject:
            result = @"Invalid Response Object";
            break;
        default:
            break;
    }
    return result;
}


+ (NSError*) restErrorWithCode:(TPMGRestUnitErrorCodes)code {
    NSError* result = nil;
    NSString* message = [NSError restStringForCode:code];
    if (message.length) {
        NSDictionary* userInfo = @{NSLocalizedDescriptionKey:message};
        result = [[NSError alloc] initWithDomain:(NSString*)kTPMGRestErrorDomain code:code userInfo:userInfo];
    }
    return result;
}
+ (NSError*) restErrorWithCode:(TPMGRestUnitErrorCodes)code andMessage:(NSString*)message {
    NSError* result = nil;
    if (!message.length) {
        if (!(message = [NSError restStringForCode:code])) {
            message = @"";
        }
    }
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey:message};
    result = [[NSError alloc] initWithDomain:(NSString*)kTPMGRestErrorDomain code:code userInfo:userInfo];
    return result;
}
@end
