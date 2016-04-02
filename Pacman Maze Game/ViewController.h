//
//  ViewController.h
//  Pacman Maze Game
//
//  Created by Evan McCullough on 4/2/16.
//  Copyright © 2016 Evan McCullough. All rights reserved.
//

#import <UIKit/UIKit.h>
// importing coreanimation
#import <QuartzCore/CAAnimation.h>//

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *pacman;
@property (strong, nonatomic) IBOutlet UIImageView *ghost1;
@property (strong, nonatomic) IBOutlet UIImageView *ghost2;
@property (strong, nonatomic) IBOutlet UIImageView *ghost3;
@property (strong, nonatomic) IBOutlet UIImageView *exit;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *wall;

// current and previous point of pacman
@property (assign, nonatomic) CGPoint currentPoint;
@property (assign, nonatomic) CGPoint previousPoint;

@end

