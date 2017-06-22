//
//  NSError+Rest.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString* kTPMGRestErrorDomain;
typedef enum __TPMGRestUnitErrorCodes__:NSUInteger {
    kTPMGRestErrorCodeOK = 0,
    kTPMGRestErrorGeneralFailure = 1,
    kTPMGRestErrorNoData = 2,
    kTPMGRestErrorInvalidTemplate = 3,
    kTPMGRestErrorInvalidTemplateContext = 4,
    kTPMGRestErrorInvalidTemplateList = 5,
    kTPMGRestErrorFailureToParseJSONError = 6,
    kTPMGRestErrorInvalidResponseObject = 7
} TPMGRestUnitErrorCodes;

@interface NSError (Rest)
+ (NSError*) restErrorWithCode:(TPMGRestUnitErrorCodes)code;
+ (NSError*) restErrorWithCode:(TPMGRestUnitErrorCodes)code andMessage:(NSString*)message;
@end
