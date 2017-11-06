//
//  PillowCollectionStatus.h
//  SDK
//
//  Created by Martin on 2017/8/10.
//  Copyright © 2017年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PillowCollectionStatus : NSObject
@property (nonatomic,assign) UInt8 collectionStatus;
@property (nonatomic,readonly) BOOL isCollecting;
@end
