//
//  DFSPAuthorizationService.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/20/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRestMapper.h"

@interface DFSPAuthorizationService : DFSPRestMapper
- (void) requestAuthorizationWithCompletionHandle:(void(^)(NSError*,id<DFSPModel>))handle;
@end
