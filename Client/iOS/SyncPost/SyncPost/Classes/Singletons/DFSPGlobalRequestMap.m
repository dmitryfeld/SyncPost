//
//  DFSPGlobalRequestMap.m
//  SyncPost
//
//  Created by Dmitry Feld on 6/26/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPGlobalRequestMap.h"
#import "DFSPSingleton.h"
#import "DFSPSettings.h"

const static NSString *__kDFSPGlobalRequestMapTag = @"__kDFSPGlobalRequestMapTag";
@interface DFSPGlobalRequestMap()<DFSPTagged>
@end

@interface DFSPRequestMap(Error)
- (void) setError:(NSError*)error;
@end

@implementation DFSPGlobalRequestMap
- (id) tag {
    return __kDFSPGlobalRequestMapTag;
}
+ (DFSPGlobalRequestMap*) requestMapFromCurrentEnvironment {
    DFSPGlobalRequestMap* result = nil;
    DFSPEnvironment* environment = DFSPSettingsGet().environment;
    if (environment.isSimulated) {
        result = [DFSPGlobalRequestMap requestMapWithContentOfMainBundleFile:@"RequestMap"];
    } else {
        NSURL* url = [environment.accessURL URLByAppendingPathComponent:@"requestmap"];
        result = [DFSPGlobalRequestMap requestMapWithContentOfURL:url];
    }
    return result;
}
+ (DFSPGlobalRequestMap*) requestMapWithContentOfURL:(NSURL*)url {
    NSError* error = nil;
    DFSPGlobalRequestMap* result = nil;
    NSDictionary* dict = nil;
    NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    if (data.length) {
        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
    }
    result = [[DFSPGlobalRequestMap alloc] initWithDictionary:dict[@"content"]];
    if (error) {
        [result setError:error];
    }
    return result;
}
+ (DFSPGlobalRequestMap*) requestMapWithContentOfMainBundleFile:(NSString*)fileName {
    NSError* error = nil;
    DFSPGlobalRequestMap* result = nil;
    NSDictionary* dict = nil;
    NSData* data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    if (data.length) {
        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
    }
    result = [[DFSPGlobalRequestMap alloc] initWithDictionary:dict[@"content"]];
    if (error) {
        [result setError:error];
    }
    return result;
}
@end

DFSPGlobalRequestMap* DFSPGlobalRequestMapGet() {
    DFSPGlobalRequestMap* result = [DFSPSingleton objectForTag:__kDFSPGlobalRequestMapTag];
    if (!result) {
        result = [DFSPGlobalRequestMap requestMapFromCurrentEnvironment];
        [DFSPSingleton addObject:(DFSPGlobalRequestMap*)result];
    }
    return result;
}
