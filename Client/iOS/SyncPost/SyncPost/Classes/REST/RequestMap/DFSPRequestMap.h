//
//  DFSPRequestMap.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/21/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRequestTemplate.h"
#import "DFSPModel.h"

@interface DFSPRequestMap : NSObject
@property (readonly,nonatomic,strong) NSError* error;
@property (readonly,nonatomic,strong) id context;
@property (readonly,nonatomic,strong) NSArray<DFSPRequestTemplate*>* requestTemplates;
- (instancetype) initWithDictionary:(NSDictionary<NSString*,id>*)dictionary NS_DESIGNATED_INITIALIZER;
- (NSURLRequest*) prepareRequestWithName:(NSString*)name;
+ (DFSPRequestMap*) requestMapWithContentOfURL:(NSURL*)url;
+ (DFSPRequestMap*) requestMapWithContentOfMainBundleFile:(NSString*)fileName;
@end
