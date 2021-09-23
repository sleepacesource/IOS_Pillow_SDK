//
//  Utils.m
//  Binatone-demo
//
//  Created by Martin on 23/8/18.
//  Copyright © 2018年 Martin. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)localizedString:(NSString *)key {
    NSString *string = NSLocalizedString(key, nil);
    return string;
}

+ (UIEdgeInsets)areaInsets {
    UIEdgeInsets areaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        areaInsets = mainWindow.safeAreaInsets;
    }
    return areaInsets;
}

+ (void)addSubView:(UIView *)subView suitableTo:(UIView *)superView{
    if (!subView || !superView){
        return;
    }
    
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [superView addSubview:subView];
    NSDictionary *subViews = NSDictionaryOfVariableBindings(subView,superView);
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|" options:0 metrics:nil views:subViews]];
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|" options:0 metrics:nil views:subViews]];
}

+ (void)setLableNormalAttributes:(UILabel *)label text:(NSString *)text font:(UIFont *)font {
    if (!label || !text) {
        return;
    }
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange rang = NSMakeRange(0, text.length);
    [attributedStr addAttributes:[self attributesWithFont:font] range:rang];
    [label setAttributedText:attributedStr];
}

+ (NSDictionary *)attributesWithFont:(UIFont *)font {
    if (!font) {
        return nil;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.minimumLineHeight = font.pointSize + 6;
    paragraphStyle.maximumLineHeight = paragraphStyle.minimumLineHeight;
    paragraphStyle.hyphenationFactor = 0.97;
    NSDictionary *attributes = @{ NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName:paragraphStyle};
    return attributes;
}
@end
