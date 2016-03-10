//
//  JCSegmentMenu.m
//  JCSegmentMenu
//
//  Created by Jordan Coff on 3/8/16.
//  Copyright © 2016 JC. All rights reserved.
//

#import "JCSegmentMenu.h"

@implementation JCSegmentMenu {
    UIView* _buttonContainer;
    UIView* _bottomSepView;
    UIView* _topSepView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadDefaults];
        NSMutableArray* buttons = [NSMutableArray new];
        
        for (int i = 0; i < 5; i++) {
            [buttons addObject:[JCSegmentMenu defaultSegmentButtonWithOptions:@{@"type":@"numbered", @"index":@(i+1)}]];
        }
        [self setSegmentButtons:buttons];
        [self layoutStuff];
    }
    return self;
}

-(void) loadDefaults {
    if (_topSepHeight <= 0) _topSepHeight = TOP_SEP_HEIGHT;
    if (_bottomSepHeight <= 0) _bottomSepHeight = BOTTOM_SEP_HEIGHT;
    if (_pointerEdgeLength <= 0) _pointerEdgeLength = POINTER_EDGE_LENGTH;
    if (!_separatorColor) _separatorColor = [JCSegmentMenu defaultSepColor];
}

-(void)layoutStuff {
    [self layoutButtons];
    [self layoutSeps];
}

-(void) layoutSeps {
    _topSepView = nil;
    _bottomSepView = nil;
    
    _topSepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _topSepHeight)];
    _bottomSepView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - _bottomSepHeight, self.frame.size.width, _bottomSepHeight)];
    [_topSepView setBackgroundColor:_separatorColor];
    [_bottomSepView setBackgroundColor:_separatorColor];
    _topSepView.translatesAutoresizingMaskIntoConstraints = NO;
    _bottomSepView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:_topSepView];
    [self addSubview:_bottomSepView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_topSepView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_topSepView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bottomSepView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_bottomSepView)]];
    
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_topSepView(_topSepHeight)][_buttonContainer][_bottomSepView(_bottomSepHeight)]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"_topSepHeight":@(_topSepHeight), @"_bottomSepHeight":@(_bottomSepHeight)} views:NSDictionaryOfVariableBindings(_topSepView, _buttonContainer, _bottomSepView)]];
}

-(void) layoutButtons {
    _buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, _topSepHeight, self.frame.size.width, self.frame.size.height - _topSepHeight - _bottomSepHeight)];
    _buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_buttonContainer];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_buttonContainer]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_buttonContainer)]];
    
    [JCSegmentMenu spaceViews:_segmentButtons evenlyInContainer:_buttonContainer];
}

+(void)spaceViews:(NSArray*)views evenlyInContainer:(UIView*)container {
    
    UIView* lastSpacer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    lastSpacer.translatesAutoresizingMaskIntoConstraints = NO;
    [lastSpacer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastSpacer(10)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(lastSpacer)]];
    [container addSubview:lastSpacer];

    [container addConstraint:[NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastSpacer attribute:NSLayoutAttributeLeading multiplier:1.f constant:0]];
    
    
    for (int i = 0; i < [views count]; i++) {
        [container addSubview:views[i]];
        
        [container addConstraint:[NSLayoutConstraint constraintWithItem:lastSpacer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:views[i] attribute:NSLayoutAttributeLeading multiplier:1.f constant:0]];
        
        UIView* spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [spacerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[spacerView(10)]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(spacerView)]];
        
        
        spacerView.translatesAutoresizingMaskIntoConstraints = NO;
        [spacerView setBackgroundColor:[UIColor blueColor]];
        [container addSubview:spacerView];
        [container addConstraint:[NSLayoutConstraint constraintWithItem:spacerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:views[i] attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0]];
        
        [container addConstraint:[NSLayoutConstraint constraintWithItem:spacerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0]];
        
        [container addConstraint:[NSLayoutConstraint constraintWithItem:views[i] attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0]];
        
        if (lastSpacer) {
            [container addConstraint:[NSLayoutConstraint constraintWithItem:spacerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastSpacer attribute:NSLayoutAttributeWidth multiplier:1.f constant:0]];
        }
        lastSpacer = spacerView;
    }
    [container addConstraint:[NSLayoutConstraint constraintWithItem:lastSpacer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0]];
}

-(void)setSegmentButtons:(NSArray *)segmentButtons {
    //TODO: Implement custom stuff
    _segmentButtons = segmentButtons;
}

+(UIButton*)defaultSegmentButtonWithOptions:(NSDictionary*)options {
    CGFloat width = 40;
    CGFloat height = 20;
    UIButton* ret;
    
    if ([options[@"type"] isEqualToString:@"numbered"]) {
        ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [ret setTitle:[NSString stringWithFormat:@"%d", [options[@"index"] intValue]] forState:UIControlStateNormal];
    }
    ret.translatesAutoresizingMaskIntoConstraints = NO;
    [ret addConstraint:[NSLayoutConstraint constraintWithItem:ret attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:width]];
    [ret addConstraint:[NSLayoutConstraint constraintWithItem:ret attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:height]];
    ret.backgroundColor = [UIColor brownColor];
    return ret;
}

+(UIColor*)defaultSepColor {
    return [UIColor colorWithWhite:.5 alpha:.8];
}

+(UIView*)pointerViewWithEdgeLength:(CGFloat)eLen fillColor:(UIColor*)fill borderColor:(UIColor*)border {
    
    if (!fill) fill = [JCSegmentMenu defaultSepColor];
    if (!border) border = [JCSegmentMenu defaultSepColor];
    
    CGFloat diag = sqrtf(eLen*eLen*2.);
    int hDiag = (int)(diag / 2.);
    UIView* ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, hDiag*2., hDiag)];
    NSLog(@"ret frame: %@", NSStringFromCGRect(ret.frame));
    ret.clipsToBounds = YES;
    ret.backgroundColor = [UIColor clearColor];
    
    UIView* p = [[UIView alloc] initWithFrame:CGRectMake(0, 0, eLen, eLen)];
    p.backgroundColor = fill;
    p.transform = CGAffineTransformMakeRotation(M_PI_4);
    
    [ret addSubview:p];
    p.center = CGPointMake(ret.center.x, diag/2.);
    
    return ret;
}

@end
