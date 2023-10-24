//
//  UIImage+BarCodeKit.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/17/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "UIImage+BarCodeKit.h"
#import "BCKCode.h"

@implementation UIImage (BarCodeKit)

+ (UIImage *)imageWithBarCode:(BCKCode *)barCode options:(NSDictionary *)options
{
    NSMutableDictionary *tmpOptions = [[NSMutableDictionary alloc] initWithDictionary:options];
    tmpOptions[BCKCodeDrawingFillEmptyQuietZonesOption] = @(YES);
    tmpOptions[BCKCodeDrawingBarScaleOption] = [NSNumber numberWithDouble:10];
    
    CGSize neededSize = [barCode sizeWithRenderOptions:tmpOptions];

    if (!neededSize.width || !neededSize.height)
    {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(neededSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [barCode renderInContext:context options:tmpOptions];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

