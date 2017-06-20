//
//  DFSPRestResponse.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRestResponse.h"

@interface DFSPRestResponse() {
@private
    __strong NSError* _error;
    __strong id<DFSPModel> _model;
}
@end


@implementation DFSPRestResponse
@synthesize error = _error;
@synthesize model = _model;
- (instancetype) initWithError:(NSError*)error andModel:(id<DFSPModel>)model {
    if (self = [super init]) {
        _error = error;
        _model = model;
    }
    return self;
}
@end
