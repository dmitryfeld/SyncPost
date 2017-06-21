
//
//  DFSPGlobalMapper.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/20/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPGlobalMapper.h"
#import "DFSPSingleton.h"

const static NSString *__kDFSPGlobalMapperTag = @"__kDFSPGlobalMapperTag";

@interface DFSPGlobalMapper()<DFSPTagged> {
    
}

@end


@implementation DFSPGlobalMapper
- (id) tag {
    return __kDFSPGlobalMapperTag;
}
@end
DFSPGlobalMapper* DFSPGlobalMapperGet() {
    DFSPGlobalMapper* result = [DFSPSingleton objectForTag:__kDFSPGlobalMapperTag];
    if (!result) {
        result = [[DFSPGlobalMapper alloc] initWithMap:@{@"getAuthorization":@"DFSPAuthorization"}];
        [DFSPSingleton addObject:result];
    }
    return result;
}
