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
#define POINTER_HEIGHT 7.f

@protocol JCSegmentMenuDelegate <NSObject>

@optional

-(void)button:(UIButton*)sender pressedAtIndex:(NSInteger) index;

@end

@interface JCSegmentMenu : UIView
@property (nonatomic) id<JCSegmentMenuDelegate> delegate;
@property (nonatomic) CGFloat topSepHeight;
@property (nonatomic) CGFloat bottomSepHeight;
@property (nonatomic) CGFloat pointerHeight;
@property (nonatomic) UIColor* separatorColor;

@property (nonatomic) NSArray* segmentButtons;

+(UIView*)pointerViewWithEdgeLength:(CGFloat)eLen fillColor:(UIColor*)fill borderColor:(UIColor*)border;
+(void)spaceViews:(NSArray*)views evenlyInContainer:(UIView*)container;
+(UIView*)pointerViewWithHeight:(CGFloat)height fillColor:(UIColor*)fill borderColor:(UIColor*)border;

-(UIButton*)defaultSegmentButtonWithOptions:(NSDictionary*)options;

@end
