//
//  NSError+Rest.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "NSError+Rest.h"

const NSString* kDFSPRestErrorDomain = @"kDFSPRestErrorDomain";


@implementation NSError(Rest)
+ (NSString*) restStringForCode:(DFSPRestUnitErrorCodes)code {
    NSString* result = nil;
    
    switch (code) {
        case kDFSPRestErrorCodeOK:
            result = @"No Error";
            break;
        case kDFSPRestErrorGeneralFailure:
            result = @"General Failure";
            break;
        case kDFSPRestErrorNoData:
            result = @"No Data Returned";
            break;
        case kDFSPRestErrorInvalidTemplate:
            result = @"Invalid Template";
            break;
        case kDFSPRestErrorInvalidTemplateContext:
            result = @"Invalid Template Context";
            break;
        case kDFSPRestErrorInvalidTemplateList:
            result = @"Invalid Template List";
            break;
        case kDFSPRestErrorFailureToParseJSONError:
            result = @"Unparsable Data Dictionary";
            break;
        case kDFSPRestErrorInvalidResponseObject:
            result = @"Invalid Response Object";
            break;
        case kDFSPRestErrorUnauthorized:
            result = @"Unauthorizaed Request";
            break;
        default:
            break;
    }
    return result;
}


+ (NSError*) restErrorWithCode:(DFSPRestUnitErrorCodes)code {
    NSError* result = nil;
    NSString* message = [NSError restStringForCode:code];
    if (message.length) {
        NSDictionary* userInfo = @{NSLocalizedDescriptionKey:message};
        result = [[NSError alloc] initWithDomain:(NSString*)kDFSPRestErrorDomain code:code userInfo:userInfo];
    }
    return result;
}
+ (NSError*) restErrorWithCode:(DFSPRestUnitErrorCodes)code andMessage:(NSString*)message {
    NSError* result = nil;
    if (!message.length) {
        if (!(message = [NSError restStringForCode:code])) {
            message = @"";
        }
    }
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey:message};
    result = [[NSError alloc] initWithDomain:(NSString*)kDFSPRestErrorDomain code:code userInfo:userInfo];
    return result;
}
@end
