//
//  DFSPSingleton.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DFSPTagged<NSObject>
@required
- (id) tag;
@end

@interface DFSPSingleton : NSObject
+ (id<DFSPTagged>) objectForTag:(id)tag;
+ (void) addObject:(id<DFSPTagged>)object;
+ (void) removeObject:(id<DFSPTagged>)object;
@end
