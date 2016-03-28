//
//  ViewController.m
//  JCSegmentMenu
//
//  Created by Jordan Coff on 3/8/16.
//  Copyright © 2016 JC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *container;

@end

@implementation ViewController {
    NSArray* _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_segmentMenu setDelegate:self];
    _segmentMenu.topSepHeight = 5;
    _segmentMenu.bottomSepHeight = 5;
    
    UIButton* b1 = [_segmentMenu defaultSegmentButtonWithOptions:@{@"type":@"image", @"imageName":@"note_icon.png"}];
    UIButton* b2 = [_segmentMenu defaultSegmentButtonWithOptions:@{@"type":@"image", @"imageName":@"contact_icon.png"}];
    UIButton* b3 = [_segmentMenu defaultSegmentButtonWithOptions:@{@"type":@"image", @"imageName":@"file_icon.png"}];
    UIButton* b4 = [_segmentMenu defaultSegmentButtonWithOptions:@{@"type":@"image", @"imageName":@"chat_icon.png"}];
    
    [_segmentMenu setSegmentButtons:@[b1, b2, b3, b4]];
    
    _images = @[ [UIImage imageNamed:@"compiling.png"],
                 [UIImage imageNamed:@"cryptography.png"],
                 [UIImage imageNamed:@"in_ur_reality.png"],
                 [UIImage imageNamed:@"sandwich.png"]];
}

-(void)button:(UIButton *)sender pressedAtIndex:(NSInteger)index {
    [_imageView setImage:_images[index%[_images count]]];
}

-(void)debugShowBigPointer {
    UIView* pointer =
    [JCSegmentMenu pointerViewWithHeight:30 fillColor:nil borderColor:nil];
    //[JCSegmentMenu pointerViewWithEdgeLength:70 fillColor:nil borderColor:nil];
    [self.view addSubview:pointer];
    pointer.center = CGPointMake(self.view.center.x, self.view.center.y - 300);
}
    
-(void)debugShowSpacedViews {
    NSMutableArray* labels = [NSMutableArray new];
    for (int i = 0; i < 5; i++) {
        UILabel* l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 10)];
        l.text = [NSString stringWithFormat:@"%d", i];
        l.translatesAutoresizingMaskIntoConstraints = NO;
        [l addConstraint:[NSLayoutConstraint constraintWithItem:l attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:30.f]];
        [l addConstraint:[NSLayoutConstraint constraintWithItem:l attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:10.f]];
        
        [labels addObject:l];
    }
    [JCSegmentMenu spaceViews:labels evenlyInContainer:_container];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
