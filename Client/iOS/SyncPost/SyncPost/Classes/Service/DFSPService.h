//
//  DFSPService.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/26/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPModel.h"

@interface DFSPService : NSObject
@property (readonly,nonatomic) BOOL isInProgress;
- (instancetype) init NS_DESIGNATED_INITIALIZER;
- (void) requestWithName:(NSString*)name andCompletionHandler:(void(^)(NSError*,id<DFSPModel>))handler;
@end
