//
//  mainViewController.m
//  codepath-canvas
//
//  Created by Mario C. Delgado Jr. on 6/29/14.
//  Copyright (c) 2014 Mario C. Delgado Jr. All rights reserved.
//

#import "mainViewController.h"

@interface mainViewController ()
@property (weak, nonatomic) IBOutlet UIView *canvasView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bldg1;
@property (weak, nonatomic) IBOutlet UIImageView *bldg2;
@property (weak, nonatomic) IBOutlet UIImageView *bldg3;
@property (weak, nonatomic) IBOutlet UIImageView *bldg4;
@property (weak, nonatomic) IBOutlet UIImageView *bldg5;
@property (weak, nonatomic) IBOutlet UIImageView *bldg6;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *edgeGesture;
- (IBAction)onEdgeGesture:(UIPanGestureRecognizer *)sender;
- (IBAction)onbldg1:(id)sender;
- (IBAction)onbldg2:(id)sender;
- (IBAction)onbldg3:(id)sender;
- (IBAction)onbldg4:(id)sender;
- (IBAction)onbldg5:(id)sender;
- (IBAction)onbldg6:(id)sender;

@property (assign, nonatomic) CGPoint offset;


@end

@implementation mainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollView.contentSize = CGSizeMake( 520 , self.scrollView.frame.size.height) ;
    self.scrollView.center = CGPointMake(self.scrollView.center.x, 600);
    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    


}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (BOOL) prefersStatusBarHidden
{
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onEdgeGesture:(UIPanGestureRecognizer *)sender {
    NSLog(@"I can grab the edge...");

        CGPoint point = [self.edgeGesture locationInView:self.view];



    
        if (sender.state == UIGestureRecognizerStateBegan) {
            self.offset = CGPointMake(point.x - self.scrollView.center.x, point.y - self.scrollView.center.y);
            
            NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
        } else if (sender.state == UIGestureRecognizerStateChanged) {
             self.scrollView.center = CGPointMake(160 , point.y - self.offset.y);
            if (self.scrollView.center.y < 522) {
                self.scrollView.center = CGPointMake(160, 522);
            }
            NSLog(@"Gesture changed: %@", NSStringFromCGPoint(point));
        } else if (sender.state == UIGestureRecognizerStateEnded) {
            
            
            [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.2 initialSpringVelocity:0 options:0 animations:^{
                if (self.scrollView.frame.origin.y >490) {
                    self.scrollView.center = CGPointMake(160, 608);
                } else {
                    self.scrollView.center = CGPointMake(160, 522);
                    self.edgeGesture.enabled = NO;


                }
            } completion:nil];
            
        }
    }


- (IBAction)onbldg1:(UIPanGestureRecognizer *)sender {
     UIImageView *originalImageView = (UIImageView *)sender.view;
    
    CGPoint point1 = [sender locationInView:self.view.superview];
    CGPoint translation = [sender translationInView:self.view.superview];

    
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:originalImageView.frame];
        imageView.image = originalImageView.image;
        [self.canvasView addSubview:imageView];



    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint newPoint1 = CGPointMake(point1.x - self.offset.x, point1.y -self.offset.y);
        imageView.center = newPoint1;
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
    }




    

       NSLog(@"Bldg 1");
    
    
}

- (IBAction)onbldg2:(id)sender {
}

- (IBAction)onbldg3:(id)sender {
}

- (IBAction)onbldg4:(id)sender {
}

- (IBAction)onbldg5:(id)sender {
}

- (IBAction)onbldg6:(id)sender {
}
@end