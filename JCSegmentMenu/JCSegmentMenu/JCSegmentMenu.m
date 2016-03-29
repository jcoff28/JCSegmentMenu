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
    UIView* _pointer;
    
    NSInteger _selectedButtonIndex;
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
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self loadDefaults];
//        NSMutableArray* buttons = [NSMutableArray new];
//        
//        for (int i = 0; i < 5; i++) {
//            UIButton* b = [JCSegmentMenu defaultSegmentButtonWithOptions:@{@"type":@"numbered", @"index":@(i+1)}];
//            [b addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//            [buttons addObject:b];
//        }
//        [self setSegmentButtons:buttons];
//        [self layoutStuff];
    }
    return self;
}

-(void) loadDefaults {
    if (_topSepHeight <= 0) _topSepHeight = TOP_SEP_HEIGHT;
    if (_bottomSepHeight <= 0) _bottomSepHeight = BOTTOM_SEP_HEIGHT;
    if (_pointerHeight <= 0) _pointerHeight = POINTER_HEIGHT;
    if (!_separatorColor) _separatorColor = [JCSegmentMenu defaultSepColor];
    _selectedButtonIndex = 0;
}

-(void)layoutStuff {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self loadDefaults];
    [self layoutButtons];
    [self layoutSeps];
}

-(void) layoutSeps {
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [_buttonContainer removeFromSuperview];
    _buttonContainer = nil;
    
    _buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, _topSepHeight, self.frame.size.width, self.frame.size.height - _topSepHeight - _bottomSepHeight)];
    _buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_buttonContainer];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_buttonContainer]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_buttonContainer)]];
    
    [JCSegmentMenu spaceViews:_segmentButtons evenlyInContainer:_buttonContainer];
    
    //CGFloat spaceHeight = (self.frame.size.height - _topSepHeight - _bottomSepHeight - ((UIButton*)_segmentButtons[0]).frame.size.height) / 2.;
    [_pointer removeFromSuperview];
    _pointer = nil;
    _pointer = [JCSegmentMenu pointerViewWithHeight:_pointerHeight fillColor:nil borderColor:nil];
    [_buttonContainer addSubview:_pointer];
    
    [_buttonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pointer]|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(_pointer)]];
    
    [_pointer setCenter:CGPointMake(((UIView*)_segmentButtons[0]).center.x, _bottomSepView.frame.origin.y)];
}


-(void)updateConstraints {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super updateConstraints];
    [self updatePointerXWithAnimationDuration:0];
}

-(void)updatePointerXWithAnimationDuration:(CGFloat)dur {
    NSArray* constraints = _buttonContainer.constraints;
    for (NSLayoutConstraint* c in constraints) {
        if ([c.firstItem isEqual:_pointer] && c.firstAttribute == NSLayoutAttributeCenterX) {
            if ([c.secondItem isEqual:_segmentButtons[_selectedButtonIndex]]) {
                //it's already good yall
                return;
            }
            else {
                [_buttonContainer removeConstraint:c];
            }
        }
    }
    [UIView animateWithDuration:dur animations:^{
        [_pointer setCenter:CGPointMake(((UIButton*)_segmentButtons[_selectedButtonIndex]).center.x, _pointer.center.y)];
        [_buttonContainer addConstraint:[NSLayoutConstraint constraintWithItem:_pointer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_segmentButtons[_selectedButtonIndex] attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    } completion:^(BOOL finished) {
    }];
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
    for (UIButton* b in _segmentButtons) {
        [b addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self layoutStuff];
}

-(void)buttonPressed:(id) sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSInteger index = [_segmentButtons indexOfObject:sender];
    if (index == NSNotFound) return;
    
    [self setSelectedButtonIndex:index];
    if (_delegate && [_delegate respondsToSelector:@selector(button:pressedAtIndex:)]) {
        [_delegate button:sender pressedAtIndex:index];
    }
}

-(void)setSelectedButton:(UIButton*)button {
    NSInteger i = [_segmentButtons indexOfObject:button];
    if (i != NSNotFound) {
        [self setSelectedButtonIndex:i];
    }
}

-(void)setSelectedButtonIndex:(NSInteger) index {
    _selectedButtonIndex = index;
    [self updatePointerXWithAnimationDuration:.4];
}

-(UIButton*)defaultSegmentButtonWithOptions:(NSDictionary*)options {
    
    CGFloat width = options[@"width"] ? [options[@"width"] floatValue] : (self.frame.size.height - _topSepHeight - _bottomSepHeight)/2.;
    CGFloat height = options[@"height"] ? [options[@"height"] floatValue] : width;
    UIButton* ret;
    NSString* buttonType = options[@"type"];
    if (!buttonType) {
        buttonType = @"image";
    }
    
    if ([buttonType isEqualToString:@"numbered"]) {
        ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [ret setTitle:[NSString stringWithFormat:@"%d", [options[@"index"] intValue]] forState:UIControlStateNormal];
    }
    else if ([buttonType isEqualToString:@"image"]) {
        ret = [UIButton buttonWithType:UIButtonTypeCustom];
        [ret setFrame:CGRectMake(0, 0, width, height)];
        
        UIImage *bgImage = [[UIImage imageNamed: options[@"imageName"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [ret setImage:bgImage forState:UIControlStateNormal];
        
        //[ret setBackgroundColor:options[@"backgroundColor"]?options[@"backgroundColor"]: [UIColor colorWithRed:69./255. green:162./255. blue:212./255. alpha:1.f]];
        
        ret.tintColor = [UIColor colorWithRed:69./255. green:162./255. blue:212./255. alpha:1.f];
        ret.alpha = 1.0;
        ret.opaque = YES;
    }
    ret.translatesAutoresizingMaskIntoConstraints = NO;
    [ret addConstraint:[NSLayoutConstraint constraintWithItem:ret attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:width]];
    [ret addConstraint:[NSLayoutConstraint constraintWithItem:ret attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:height]];
    
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
    return [JCSegmentMenu pointerViewWithHeight:hDiag fillColor:fill borderColor:border];
    
    
//    UIView* ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, hDiag*2., hDiag)];
//    NSLog(@"ret frame: %@", NSStringFromCGRect(ret.frame));
//    ret.clipsToBounds = YES;
//    ret.backgroundColor = [UIColor clearColor];
//    
//    UIView* p = [[UIView alloc] initWithFrame:CGRectMake(0, 0, eLen, eLen)];
//    p.backgroundColor = fill;
//    p.transform = CGAffineTransformMakeRotation(M_PI_4);
//    
//    [ret addSubview:p];
//    p.center = CGPointMake(ret.center.x, diag/2.);
//    
//    return ret;
}

+(UIView*)pointerViewWithHeight:(CGFloat)height fillColor:(UIColor*)fill borderColor:(UIColor*)border {
    
    if (!fill) fill = [JCSegmentMenu defaultSepColor];
    if (!border) border = [JCSegmentMenu defaultSepColor];
    UIView* ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2*height, height)];
    ret.clipsToBounds = YES;
    ret.backgroundColor = [UIColor clearColor];
    
    CGFloat eLen = sqrtf((2*height*2*height) / 2.);
    UIView* p = [[UIView alloc] initWithFrame:CGRectMake(0, 0, eLen, eLen)];
    p.backgroundColor = fill;
    p.transform = CGAffineTransformMakeRotation(M_PI_4);
    [ret addSubview:p];
    p.center = CGPointMake(ret.center.x, height);
    
    ret.translatesAutoresizingMaskIntoConstraints = NO;
    [ret addConstraints:@[
        [NSLayoutConstraint constraintWithItem:ret attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:ret.frame.size.width],
        [NSLayoutConstraint constraintWithItem:ret attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:ret.frame.size.height]]];
    return ret;
}

@end







