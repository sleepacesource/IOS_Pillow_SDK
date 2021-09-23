//
//  Utils.h
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define LocalizedString(key) [Utils localizedString:key]
@interface Utils : NSObject

+ (NSString *)localizedString:(NSString *)key;
+ (UIEdgeInsets)areaInsets;
+ (void)addSubView:(UIView *)subView suitableTo:(UIView *)superView;

+ (void)setLableNormalAttributes:(UILabel *)label text:(NSString *)text font:(UIFont *)font;
@end
