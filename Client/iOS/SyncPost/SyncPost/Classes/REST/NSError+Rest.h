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
    // Internal errors cathegory
    kDFSPRestErrorCodeOK = 0,
    kDFSPRestErrorGeneralFailure = 1,
    kDFSPRestErrorNoData = 2,
    
    //Template errors
    kDFSPRestErrorInvalidRestTemplateParameter,
    kDFSPRestErrorInvalidRestTemplateContent,
    kDFSPRestErrorRestTemplateResponseMapping,
    
    //Request Map composition errors
    kDFSPRestErrorInvalidRequestMapParameter,
    kDFSPRestErrorInvalidRequestMapConetent,
    kDFSPRestErrorRequestMapCanNotFindTemplate,
    
    //REST API process related
    kDFSPRestErrorFailureToParseJSONE,
    kDFSPRestErrorInvalidRequestName,
    kDFSPRestErrorInvalidSimulatedDataPath,
    kDFSPRestErrorInvalidURLRequest,
    kDFSPRestErrorFailureToStartURLSession,
    
    //Response related
    kDFSPRestErrorRequestInvalidResponse,
    kDFSPRestErrorUnexpectedResponseObjectType,
    
    // Errors from server
    kDFSPRestErrorUnauthorized
} DFSPRestUnitErrorCodes;

@interface NSError (Rest)
+ (NSError*) restErrorWithCode:(DFSPRestUnitErrorCodes)code;
+ (NSError*) restErrorWithCode:(DFSPRestUnitErrorCodes)code andMessage:(NSString*)message;
+ (NSError*) restErrorWithCode:(DFSPRestUnitErrorCodes)code andComment:(NSString*)comment;
@end
