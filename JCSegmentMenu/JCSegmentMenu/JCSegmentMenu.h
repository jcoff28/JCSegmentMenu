//
//  JCSegmentMenu.h
//  JCSegmentMenu
//
//  Created by Jordan Coff on 3/8/16.
//  Copyright © 2016 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

//Defaults
#define TOP_SEP_HEIGHT 7.f
#define BOTTOM_SEP_HEIGHT 7.f
#define POINTER_EDGE_LENGTH 7.f

@interface JCSegmentMenu : UIView

@property (nonatomic) CGFloat topSepHeight;
@property (nonatomic) CGFloat bottomSepHeight;
@property (nonatomic) CGFloat pointerEdgeLength;
@property (nonatomic) UIColor* separatorColor;

@property (nonatomic) NSArray* segmentButtons;

+(UIView*)pointerViewWithEdgeLength:(CGFloat)eLen fillColor:(UIColor*)fill borderColor:(UIColor*)border;
+(void)spaceViews:(NSArray*)views evenlyInContainer:(UIView*)container;

@end
