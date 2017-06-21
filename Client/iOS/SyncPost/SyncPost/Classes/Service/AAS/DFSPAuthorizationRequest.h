//
//  DFSPAuthorizationRequest.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/20/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRestRequest.h"

@interface DFSPAuthorizationRequest : DFSPRestRequest
- (NSMutableURLRequest*) formURLRequest;
- (NSString*) simulatedFileName;
@end
