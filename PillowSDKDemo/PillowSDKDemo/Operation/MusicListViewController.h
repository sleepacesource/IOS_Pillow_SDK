//
//  MusicListViewController.h
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FromMode) {
    FromMode_SleepAid,
    FromMode_Alarm,
};

typedef void(^SelectMusicBlock)(NSInteger musicID);

@interface MusicListViewController : UIViewController

@property (nonatomic, assign) UInt16 musicID;

@property (nonatomic, assign) UInt8 volume;

@property (nonatomic, copy) NSArray *musicList;

@property (nonatomic, copy) SelectMusicBlock musicBlock;

@property (nonatomic, assign) FromMode mode;

@end

NS_ASSUME_NONNULL_END
