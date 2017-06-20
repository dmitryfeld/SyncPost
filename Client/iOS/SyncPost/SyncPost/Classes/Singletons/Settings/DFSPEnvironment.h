//
//  DFSPEnvironment.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/15/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFSPEnvironment : NSObject
@property (readonly,nonatomic) NSString* name;
@property (readonly,nonatomic) NSURL* accessURL;
@property (readonly,nonatomic) BOOL isSimulated;
- (instancetype) initWithDictionary:(NSDictionary*)dictionary NS_DESIGNATED_INITIALIZER;
+ (NSMutableArray<DFSPEnvironment*>*) listWithArrayOfDictionaries:(NSArray<NSDictionary<NSString*,NSString*>*>*)array;
@end
