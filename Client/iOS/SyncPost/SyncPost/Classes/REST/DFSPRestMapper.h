//
//  DFSPRestMapper.h
//  SyncPost
//
//  Created by Dmitry Feld on 6/18/17.
//  Copyright © 2017 Dmitry Feld. All rights reserved.
//

#import "DFSPRestResponse.h"

@interface DFSPRestMapper : NSObject
@property (readonly,strong,nonatomic) NSDictionary<NSString*,NSString*>* map;
@property (readonly,strong,nonatomic) NSError* mappingError;
- (instancetype) initWithMap:(NSDictionary<NSString*,NSString*>*) map NS_DESIGNATED_INITIALIZER;
- (DFSPRestResponse*) mapDictionaryToResponse:(NSDictionary*)dictionary;
@end
