//
//  DFSPRestAPI.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRestAPI.h"
#import "DFSPSettings.h"
#import "NSError+Rest.h"

@interface DFSPRestAPI() {
@private
    __strong DFSPRequestMap* _requestMap;
    __strong void (^_completionHandler)(NSError*,id<DFSPModel>);
    __strong NSError* _error;
    BOOL _isInProcess;
}
@end

@implementation DFSPRestAPI
@synthesize requestMap = _requestMap;
@synthesize isInProcess = _isInProcess;
@synthesize error = _error;
- (instancetype) init {
    if (self = [self initWithRequestMap:nil]) {
        [NSException raise:@"DFSPRestAPI Init" format:@"Invalid Arguments"];
    }
    return self;
}
- (instancetype) initWithRequestMap:(DFSPRequestMap*)requestMap {
    if (self = [super init]) {
        _requestMap = requestMap;
    }
    return self;
}
- (void) startWithRequestName:(NSString*)requestName andCompletionHandler:(void(^)(NSError*,id<DFSPModel>))handler {
    if (!_isInProcess) {
        _isInProcess = YES;
        if (requestName.length) {
            _completionHandler = handler;
            _error = nil;
            if (_requestMap.isSimulated) {
                [self processSimulatedWithRequestName:(NSString*)requestName];
            } else {
                [self startAPICall];
            }
        } else {
            _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRequestName];
        }
    }
}

- (void) processSimulatedWithRequestName:(NSString*)requestName {
    id<DFSPModel> response = nil;
    NSString *simulatedDataName = [_requestMap simulatedDataPathWithName:requestName];
    if (_requestMap.error) {
        _error = _requestMap.error;
        [self processHandleWithError:_error andResponse:response];
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:simulatedDataName ofType:@"json"];
        if (path) {
            NSData *_data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
            if (_data.length) {
                NSError* error = nil;
                NSDictionary* _jsonDictionary = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
                if (error) {
                    _error = error;
                } else if (!_jsonDictionary) {
                    _error = [NSError restErrorWithCode:kDFSPRestErrorFailureToParseJSONE];
                } else {
                    response = [_requestMap processResponse:_jsonDictionary];
                    if (!response) {
                        _error = _requestMap.error;
                    }
                }
            } else {
                _error = [NSError restErrorWithCode:kDFSPRestErrorNoData];
            }
            [self processHandleWithError:_error andResponse:response];
        } else {
            _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidSimulatedDataPath];
        }
    }
    _isInProcess = NO;
}

- (void) startAPICall {
    _isInProcess = NO;
}
- (void) processHandleWithError:(NSError*)error andResponse:(id<DFSPModel>)response {
    if ([NSThread isMainThread]) {
        _completionHandler(error,response);
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            _completionHandler(error,response);
        });
    }
}
@end
