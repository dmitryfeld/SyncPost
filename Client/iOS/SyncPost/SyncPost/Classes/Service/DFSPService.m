//
//  DFSPService.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/26/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPService.h"
#import "DFSPRestAPI.h"
#import "DFSPGlobalRequestMap.h"
#import "NSError+Rest.h"

@interface DFSPService() {
    __strong DFSPRestAPI* _rest;
}

@end

@implementation DFSPService
@dynamic isInProgress;
- (instancetype) init {
    if (self = [super init]) {
        _rest = [[DFSPRestAPI alloc] initWithRequestMap:DFSPGlobalRequestMapGet()];
    }
    return self;
}
- (void) requestWithName:(NSString*)name andCompletionHandler:(void(^)(NSError*,id<DFSPModel>))handler {
    if (!_rest.isInProcess) {
        if ([name isEqualToString:@"authorization"]) {
            [_rest startWithRequestName:name andCompletionHandler:handler];
        } else {
            [_rest startWithRequestName:name andCompletionHandler:^(NSError *error_, id<DFSPModel>model_) {
                if (error_) {
                    if (error_.code == kDFSPRestErrorUnauthorized) {
                        [self requestWithName:@"authorization" andCompletionHandler:^(NSError *error_, id<DFSPModel>model_) {
                            if (error_) {
                                [self processHandler:handler withError:error_ andResponse:model_];
                            } else {
                                [self requestWithName:name andCompletionHandler:handler];
                            }
                        }];
                    } else {
                        [self processHandler:handler withError:error_ andResponse:model_];
                    }
                } else {
                    [self processHandler:handler withError:error_ andResponse:model_];
                }
            }];
        }
    }
}
- (void) processHandler:(void(^)(NSError*,id<DFSPModel>))handler withError:(NSError*)error andResponse:(id<DFSPModel>)response {
    if (handler) {
        if ([NSThread isMainThread]) {
            handler(error,response);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(error,response);
            });
        }
    }
}
- (BOOL) isInProgress {
    return _rest.isInProcess;
}
@end
