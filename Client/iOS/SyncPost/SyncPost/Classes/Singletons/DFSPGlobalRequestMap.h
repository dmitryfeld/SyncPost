//
//  DFSPGlobalRequestMap.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/26/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRequestMap.h"

@interface DFSPGlobalRequestMap : DFSPRequestMap
+ (DFSPGlobalRequestMap*) requestMapFromCurrentEnvironment;
+ (DFSPGlobalRequestMap*) requestMapWithContentOfURL:(NSURL*)url;
+ (DFSPGlobalRequestMap*) requestMapWithContentOfMainBundleFile:(NSString*)fileName;
@end


DFSPGlobalRequestMap* DFSPGlobalRequestMapGet();
