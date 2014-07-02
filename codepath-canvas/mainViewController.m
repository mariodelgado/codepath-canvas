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
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
- (IBAction)onEdgeGesture:(UIPanGestureRecognizer *)sender;
- (IBAction)onbldg1:(id)sender;
- (IBAction)cameraTap:(id)sender;
@property (assign, nonatomic) CGPoint offset;
@property (nonatomic, strong) UIImageView * createdImageView;
@property CGPoint translation;
@property CGFloat lastScale;
@property CGFloat lastRotation;
@property CGSize size1;

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
    _scrollView.contentSize = CGSizeMake( 580 , self.scrollView.frame.size.height) ;
    self.scrollView.center = CGPointMake(self.scrollView.center.x, 600);
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.canvasView.alpha = 0.5;

    //throw error if you're running it on a sim
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"No Camera Available"
                                                              message:@"You can't use the camera on a simulator."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
        
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
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
                    self.scrollView.center = CGPointMake(160, 600);
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
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imgDidPan:)]];
        self.createdImageView = imageView;
          [self.createdImageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(imgDidPinch:)]];
         [self.createdImageView addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)]];
        self.createdImageView.center = point1;
        CGAffineTransform currentTransform = self.createdImageView.transform;
            //double canvas item size to make it easier to pinch
        CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 1.5, 1.5);
        [self.createdImageView setTransform:newTransform];
        [self.canvasView addSubview:imageView];

    } else if (sender.state == UIGestureRecognizerStateChanged) {
    self.offset = CGPointMake(point1.x - self.createdImageView.center.x, point1.y - self.createdImageView.center.y);
        self.createdImageView.center = point1;
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (point1.y <470){
            self.createdImageView.center = point1;
        } else {
            [self.createdImageView removeFromSuperview];
        }
    }
       NSLog(@"New image created.");
}


- (IBAction)cameraTap:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.photoImage.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



- (void)imgDidPan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];

    if(sender.state == UIGestureRecognizerStateChanged) {
        //NSLog(@"Location (%f,%f) Translation (%f, %f)", location.x, location.y, translation.x, translation.y);
        sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
    } if (sender.state == UIGestureRecognizerStateEnded) {
    }
}


- (void)imgDidPinch:(UIPinchGestureRecognizer *)sender {
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = self.createdImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [self.createdImageView setTransform:newTransform];
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
}


-(void)rotate:(UIRotationGestureRecognizer *)sender {
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        _lastRotation = 0.0;
        return;
    }
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    CGAffineTransform currentTransform = self.createdImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    [self.createdImageView setTransform:newTransform];
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}

@end
