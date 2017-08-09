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
    kDFSPRestErrorInvalidRestTemplateParameter = 3,
    kDFSPRestErrorInvalidRestTemplateContent = 4,
    kDFSPRestErrorRestTemplateResponseMapping = 5,
    
    //Request Map composition errors
    kDFSPRestErrorInvalidRequestMapParameter = 6,
    kDFSPRestErrorInvalidRequestMapConetent = 7,
    kDFSPRestErrorRequestMapCanNotFindTemplate = 8,
    
    //REST API process related
    kDFSPRestErrorFailureToParseJSONE = 9,
    kDFSPRestErrorInvalidRequestName = 10,
    kDFSPRestErrorInvalidSimulatedDataPath = 11,
    kDFSPRestErrorInvalidURLRequest = 12,
    kDFSPRestErrorFailureToStartURLSession = 13,
    
    //Response related
    kDFSPRestErrorRequestInvalidResponse = 14,
    kDFSPRestErrorUnexpectedResponseObjectType = 15,
    
    // Errors from server
    kDFSPRestErrorInvalidRequest = 3000,
    
    // Errors from Services
    kDFSPRestErrorInvalidMemberName = 3001,
    kDFSPRestErrorInvalidCredentials = 3002,
    kDFSPRestErrorMemberNotFound = 3003,
    kDFSPRestErrorUnauthorizedMember = 3004
    
} DFSPRestUnitErrorCodes;

@interface NSError (Rest)
+ (NSError*) restErrorWithCode:(DFSPRestUnitErrorCodes)code;
+ (NSError*) restErrorWithCode:(DFSPRestUnitErrorCodes)code andMessage:(NSString*)message;
+ (NSError*) restErrorWithCode:(DFSPRestUnitErrorCodes)code andComment:(NSString*)comment;
@end
