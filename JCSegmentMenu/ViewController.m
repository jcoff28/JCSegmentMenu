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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)debugShowBigPointer {
    UIView* pointer = [JCSegmentMenu pointerViewWithEdgeLength:70 fillColor:nil borderColor:nil];
    [self.view addSubview:pointer];
    pointer.center = self.view.center;
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
