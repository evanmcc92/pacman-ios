//
//  ViewController.m
//  Pacman Maze Game
//
//  Created by Evan McCullough on 4/2/16.
//  Copyright © 2016 Evan McCullough. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] bringSubviewToFront:_pacman]; // pacman is always on top
    
    self.currentPoint  = CGPointMake(0, 144);
    
    // code used to animate the first ghost
    CGPoint origin1 = self.ghost1.center; // gets ghosts position
    CGPoint target1 = CGPointMake(self.ghost1.center.x, self.ghost1.center.y+124); // new position for ghost
    
    CABasicAnimation *bounce1 = [CABasicAnimation animationWithKeyPath:@"position.y"]; // create variable for moving ghost
    bounce1.fromValue = [NSNumber numberWithInt:origin1.y]; // say where ghost starts
    bounce1.toValue = [NSNumber numberWithInt:target1.y]; // say where ghost ends
    bounce1.duration = 2; // lasts for 2 seconds
    bounce1.autoreverses = YES; // will go backwards
    bounce1.repeatCount = HUGE_VALF; // repeat forever
    
    [self.ghost1.layer addAnimation:bounce1 forKey:@"position"];
    
    
    CGPoint origin2 = self.ghost2.center;
    CGPoint target2 = CGPointMake(self.ghost2.center.x, self.ghost2.center.y-124);
    CABasicAnimation *bounce2 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    bounce2.fromValue = [NSNumber numberWithInt:origin2.y];
    bounce2.toValue = [NSNumber numberWithInt:target2.y];
    bounce2.duration = 2;
    bounce2.repeatCount = HUGE_VALF;
    bounce2.autoreverses = YES;
    [self.ghost2.layer addAnimation:bounce2 forKey:@"position"];
    
    CGPoint origin3 = self.ghost3.center;
    CGPoint target3 = CGPointMake(self.ghost3.center.x, self.ghost3.center.y-100);
    CABasicAnimation *bounce3 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    bounce3.fromValue = [NSNumber numberWithInt:origin3.y];
    bounce3.toValue = [NSNumber numberWithInt:target3.y];
    bounce3.duration = 2;
    bounce3.repeatCount = HUGE_VALF;
    bounce3.autoreverses = YES;
    [self.ghost3.layer addAnimation:bounce3 forKey:@"position"];
    [self collisionWithGhosts]; // while moving check for this
    [self collisionWithExit];
}


- (void)touchesMoved:(NSSet *)set withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    if ([touch view] == self.pacman) {
        
        
        self.pacman.center = touchLocation;
        self.previousPoint = touchLocation;
        
        
        [self collisionWithExit]; // while moving check for this
        [self collisionWithGhosts]; // while moving check for this
        [self collsionWithWalls]; // while moving check for this
    }
}

- (void)collisionWithGhosts {
    
    CALayer *ghostLayer1 = [self.ghost1.layer presentationLayer];
    CALayer *ghostLayer2 = [self.ghost2.layer presentationLayer];
    CALayer *ghostLayer3 = [self.ghost3.layer presentationLayer];
    // if pacman interacts with any of these then end the game
    if (CGRectIntersectsRect(self.pacman.frame, ghostLayer1.frame)
        || CGRectIntersectsRect(self.pacman.frame, ghostLayer2.frame)
        || CGRectIntersectsRect(self.pacman.frame, ghostLayer3.frame) ) {
        
        
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Oops"
                                    message:@"You've lost"
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        // need to reset pacman
        self.pacman.center = CGPointMake(16, 164);
    }
}
- (void)collisionWithExit {
    CGRect pacmanframe = self.pacman.frame;
    CGRect exitlayer = self.exit.frame;
    //CALayer *exitlayer = [self.exit.layer presentationLayer];
    
    
    // if pacman interacts exit button then end game
    if (CGRectIntersectsRect(pacmanframe, exitlayer)) {
        
        UIAlertController *alert = [UIAlertController
         alertControllerWithTitle:@"Congratulations"
         message:@"You've won the game!"
         preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        // need to reset pacman
        self.pacman.center = CGPointMake(15, 175);
    }
}
- (void)collsionWithWalls {
    
    CGRect frame = self.pacman.frame;
    
//    frame.origin.x = self.currentPoint.x;
//    frame.origin.y = self.currentPoint.y;
    
    
    for (UIImageView *image in self.wall) {
        
        if (CGRectIntersectsRect(frame, image.frame)) {
            
            // Compute collision angle
            CGPoint pacmanCenter = CGPointMake(self.pacman.center.x + (frame.size.width / 2),
                                               self.pacman.center.y + (frame.size.height / 2));
            CGPoint imageCenter  = CGPointMake(image.center.x + (image.frame.size.width / 2),
                                               image.center.y + (image.frame.size.height / 2));
            CGFloat angleX = pacmanCenter.x - imageCenter.x;
            CGFloat angleY = pacmanCenter.y - imageCenter.y;
            
            if (fabs(angleX) > fabs(angleY)) {
//                _currentPoint.x = self.previousPoint.x;
                self.pacman.center = CGPointMake(self.previousPoint.x, self.pacman.center.y);
                //self.pacmanXVelocity = -(self.pacmanXVelocity / 2.0);
            } else {
//                _currentPoint.y = self.previousPoint.y;
                self.pacman.center = CGPointMake(self.pacman.center.x, self.previousPoint.y);
                //self.pacmanYVelocity = -(self.pacmanYVelocity / 2.0);
            }
            
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Be Careful"
                                        message:@"You've hit a wall! Be careful!"
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            // self.pacman.center = CGPointMake(self.pacman.center.x, self.pacman.center.y);
        }
        
    }
    [self collisionWithGhosts]; // while moving check for this
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
