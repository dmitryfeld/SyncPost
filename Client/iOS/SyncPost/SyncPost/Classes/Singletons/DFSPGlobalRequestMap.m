//
//  DFSPGlobalRequestMap.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/26/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPGlobalRequestMap.h"
#import "DFSPSingleton.h"

const static NSString *__kDFSPGlobalRequestMapTag = @"__kDFSPGlobalRequestMapTag";


@interface DFSPGlobalRequestMap()<DFSPTagged>

@end

@implementation DFSPGlobalRequestMap
- (id) tag {
    return __kDFSPGlobalRequestMapTag;
}
+ (DFSPGlobalRequestMap*) requestMapWithContentOfURL:(NSURL*)url {
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfURL:url];
    DFSPGlobalRequestMap* result = nil;
    if (dict) {
        return [[DFSPGlobalRequestMap alloc] initWithDictionary:dict];
    }
    return result;
}
+ (DFSPGlobalRequestMap*) requestMapWithContentOfMainBundleFile:(NSString*)fileName {
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]];
    DFSPGlobalRequestMap* result = nil;
    if (dict) {
        return [[DFSPGlobalRequestMap alloc] initWithDictionary:dict];
    }
    return result;
}
@end

DFSPGlobalRequestMap* DFSPGlobalRequestMapGet() {
    DFSPGlobalRequestMap* result = [DFSPSingleton objectForTag:__kDFSPGlobalRequestMapTag];
    if (!result) {
        result = [DFSPGlobalRequestMap requestMapWithContentOfMainBundleFile:@"RequestMap"];
        [DFSPSingleton addObject:(DFSPGlobalRequestMap*)result];
    }
    return result;
}
