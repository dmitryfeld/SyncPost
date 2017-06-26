//
//  NSError+Rest.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString* kDFSPRestErrorDomain;
typedef enum __DFSPRestUnitErrorCodes__:NSUInteger {
    // Internal errors
    kDFSPRestErrorCodeOK = 0,
    kDFSPRestErrorGeneralFailure = 1,
    kDFSPRestErrorNoData = 2,
    kDFSPRestErrorInvalidTemplate = 3,
    kDFSPRestErrorInvalidTemplateContext = 4,
    kDFSPRestErrorInvalidTemplateList = 5,
    kDFSPRestErrorFailureToParseJSONError = 6,
    kDFSPRestErrorInvalidResponseObject = 7,
    
    // Errors from server
    kDFSPRestErrorUnauthorized
} DFSPRestUnitErrorCodes;

@interface NSError (Rest)
+ (NSError*) restErrorWithCode:(DFSPRestUnitErrorCodes)code;
+ (NSError*) restErrorWithCode:(DFSPRestUnitErrorCodes)code andMessage:(NSString*)message;
@end
