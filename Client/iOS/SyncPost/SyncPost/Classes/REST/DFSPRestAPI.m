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
#import "DFSPRestProcessor.h"

@interface DFSPRestAPI() {
@private
    __strong DFSPRequestMap* _requestMap;
    __strong void (^_completionHandler)(NSError*,id<DFSPModel>);
    BOOL _isInProcess;
}
@end

@implementation DFSPRestAPI
@synthesize requestMap = _requestMap;
@synthesize isInProcess = _isInProcess;
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
        NSError* error = nil;
        _isInProcess = YES;
        _completionHandler = handler;
        if (!requestName.length) {
            error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRequestName];
        }
        if (!error) {
            if (!_requestMap) {
                error = [NSError restErrorWithCode:kDFSPRestErrorInvalidRequestMapConetent];
            }
        }
        if (!error) {
            if (_requestMap.isSimulated) {
                [self processSimulatedWithRequestName:requestName];
            } else {
                [self startAPICallWithRequestName:requestName];
            }
        } else {
            _isInProcess = NO;
            [self processHandleWithError:error andResponse:nil];
        }
    }
}

- (void) processSimulatedWithRequestName:(NSString*)requestName {
    id<DFSPModel> response = nil;
    NSError* error = nil;
    NSString *simulatedDataName = [_requestMap simulatedDataPathWithName:requestName];
    NSURLRequest* request = [_requestMap prepareRequestWithName:requestName];
    [self debugRequest:request];
    if (_requestMap.error) {
        error = _requestMap.error;
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:simulatedDataName ofType:@"json"];
        if (path) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
            [self debugResponse:data];
            if (data.length) {
                NSError* error = nil;
                NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
                if (error) {
                    error = error;
                } else if (!jsonDictionary) {
                    error = [NSError restErrorWithCode:kDFSPRestErrorFailureToParseJSONE];
                } else {
                    response = [_requestMap processResponse:jsonDictionary withError:&error];
                }
            } else {
                error = [NSError restErrorWithCode:kDFSPRestErrorNoData];
            }
            
        } else {
            error = [NSError restErrorWithCode:kDFSPRestErrorInvalidSimulatedDataPath];
        }
    }
    [self processHandleWithError:error andResponse:response];
    _isInProcess = NO;
}

- (void) startAPICallWithRequestName:(NSString*)requestName {
    id<DFSPModel> response = nil;
    if (_requestMap.error) {
        [self processHandleWithError:_requestMap.error andResponse:response];
        _isInProcess = NO;
    } else {
        NSError* error = nil;
        NSURLRequest* request = [_requestMap prepareRequestWithName:requestName];
        [self debugRequest:request];
        if (request) {
            DFSPRestProcessor* processor = [[DFSPRestProcessor alloc] initWithRequest:request andCompletionHandler:^(NSError *error_, NSData *data_) {
                NSError* error = nil;
                id<DFSPModel> response = nil;
                [self debugResponse:data_];
                if (error_) {
                    error = error_;
                } else {
                    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data_ options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
                    if (!error) {
                        response = [_requestMap processResponse:jsonDictionary withError:&error];
                    }
                }
                [self processHandleWithError:error andResponse:response];
                _isInProcess = NO;
            }];
            [processor start];
        } else {
            error = [NSError restErrorWithCode:kDFSPRestErrorInvalidURLRequest];
            [self processHandleWithError:error andResponse:response];
            _isInProcess = NO;
        }
    }
    
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
