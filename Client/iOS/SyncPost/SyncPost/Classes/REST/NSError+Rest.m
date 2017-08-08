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
        case kDFSPRestErrorInvalidRestTemplateParameter:
            result = @"Invalid REST Template Parameter";
            break;
        case kDFSPRestErrorInvalidRestTemplateContent:
            result = @"Invalid REST Template Content";
            break;
        case kDFSPRestErrorRestTemplateResponseMapping:
            result = @"Invalid REST Template Response Mapping";
            break;
        case kDFSPRestErrorInvalidRequestMapParameter:
            result = @"Invalid REST Request Map Parameter";
            break;
        case kDFSPRestErrorInvalidRequestMapConetent:
            result = @"Invalid REST Request Map Content";
            break;
        case kDFSPRestErrorRequestMapCanNotFindTemplate:
            result = @"REST Request Map Can not find template";
            break;
        case kDFSPRestErrorFailureToParseJSONE:
            result = @"REST Responce malformed JSON data";
            break;
        case kDFSPRestErrorInvalidRequestName:
            result = @"Invalid REST Request Name";
            break;
        case kDFSPRestErrorInvalidSimulatedDataPath:
            result = @"Invalid REST Simulated Data Path";
            break;
        case kDFSPRestErrorInvalidURLRequest:
            result = @"Invalid REST URL Request";
            break;
        case kDFSPRestErrorFailureToStartURLSession:
            result = @"Can not start URL Session";
            break;
        case kDFSPRestErrorRequestInvalidResponse:
            result = @"Invalid Response Object";
            break;
        case kDFSPRestErrorUnexpectedResponseObjectType:
            result = @"Unexpected Response Object Type";
            break;
        case kDFSPRestErrorInvalidRequest:
            result = @"Invalid Request format";
            break;
        case kDFSPRestErrorInvalidMemberName:
            result = @"Invalid Member Name";
            break;
        case kDFSPRestErrorInvalidCredentials:
            result = @"Invalid Credentials";
            break;
        case kDFSPRestErrorMemberNotFound:
            result = @"Member not found";
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
+ (NSError*) restErrorWithCode:(DFSPRestUnitErrorCodes)code andComment:(NSString*)comment {
    NSError* result = nil;
    NSString* message = [NSError restStringForCode:code];
    if (!comment.length) {
        comment = @"";
    }
    if (message.length) {
        NSDictionary* userInfo = @{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ - %@",message,comment]};
        result = [[NSError alloc] initWithDomain:(NSString*)kDFSPRestErrorDomain code:code userInfo:userInfo];
    }
    return result;
}

@end
