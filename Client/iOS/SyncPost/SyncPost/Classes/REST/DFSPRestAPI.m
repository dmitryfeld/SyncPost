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
        _error = nil;
        _completionHandler = handler;
        if (!requestName.length) {
            _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRequestName];
        }
        if (!_error) {
            if (!_requestMap) {
                _error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRequestMapConetent];
            }
        }
        if (!_error) {
            if (_requestMap.isSimulated) {
                [self processSimulatedWithRequestName:(NSString*)requestName];
            } else {
                [self startAPICall];
            }
        } else {
            _isInProcess = NO;
            [self processHandleWithError:_error andResponse:nil];
        }
    }
}

- (void) processSimulatedWithRequestName:(NSString*)requestName {
    id<DFSPModel> response = nil;
    NSString *simulatedDataName = [_requestMap simulatedDataPathWithName:requestName];
    NSURLRequest* request = [_requestMap prepareRequestWithName:requestName];
    [self debugRequest:request];
    if (_requestMap.error) {
        _error = _requestMap.error;
        [self processHandleWithError:_error andResponse:response];
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:simulatedDataName ofType:@"json"];
        if (path) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
            [self debugResponse:data];
            if (data.length) {
                NSError* error = nil;
                NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
                if (error) {
                    _error = error;
                } else if (!jsonDictionary) {
                    _error = [NSError restErrorWithCode:kDFSPRestErrorFailureToParseJSONE];
                } else {
                    response = [_requestMap processResponse:jsonDictionary];
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
    id<DFSPModel> response = nil;
    if (_requestMap.error) {
        _error = _requestMap.error;
        [self processHandleWithError:_error andResponse:response];
    } else {
    }
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
- (void) debugRequest:(NSURLRequest*)request {
    NSData* data = request.HTTPBody;
    NSString* body = @"";
    if (data) {
        body = [[NSString alloc] initWithBytes: data.bytes length:data.length encoding:NSUTF8StringEncoding];
    }
    NSLog(@"REST REQUEST:\n>>>>%@<<<<<", request.URL.description);
    NSLog(@"REST  METHOD:\n>>>>%@<<<<<", request.HTTPMethod);
    NSLog(@"REST    BODY:\n>>>>%@<<<<<", body);
    NSLog(@"REST HEADERS:\n>>>>%@<<<<<", request.allHTTPHeaderFields);
}
- (void) debugResponse:(NSData*)response {
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)response.length);
    NSString __unused *json = [[NSString alloc] initWithBytes: response.bytes length:response.length encoding:NSUTF8StringEncoding];
    NSLog(@">>>>>%@<<<<<<", json);
}
@end
