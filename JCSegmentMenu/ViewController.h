//
//  ViewController.h
//  JCSegmentMenu
//
//  Created by Jordan Coff on 3/8/16.
//  Copyright © 2016 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCSegmentMenu.h"
@interface ViewController : UIViewController <JCSegmentMenuDelegate>

@property (strong, nonatomic) IBOutlet JCSegmentMenu *segmentMenu;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

