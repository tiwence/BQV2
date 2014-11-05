//
//  BQCameraViewController.m
//  BurgerQuest
//
//  Created by Laurent MENU on 09/08/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import "BQCameraViewController.h"
#import "UIImage+Resize.h"

@implementation BQCameraViewController

@synthesize delegate;
@synthesize imagePicker;
@synthesize maskTop;
@synthesize maskBottom;
@synthesize takePictureButton;
@synthesize openLibraryButton;
@synthesize imageRotation;
@synthesize closeButton;
@synthesize cancelButton;
@synthesize validButton;

- (id)init
{
    if(self = [super init]) {
        // Init imagePicker
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        
        // Init views
        maskTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 101)];
        [maskTop setBackgroundColor:[UIColor blackColor]];
        [maskTop setAlpha:0.7];
        [self.view addSubview:maskTop];
        
        maskBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 310, 320, 127)];
        [maskBottom setBackgroundColor:[UIColor blackColor]];
        [maskBottom setAlpha:0.7];
        [self.view addSubview:maskBottom];
        
        imageRotation = [[UIImageView alloc] initWithFrame:CGRectMake(130, 27, 60, 47)];
        [imageRotation setImage:[UIImage imageNamed:@"ImageCameraRotation.png"]];
        [self.view addSubview:imageRotation];
        
        closeButton = [[UIButton alloc] initWithFrame:CGRectMake(275, 10, 45, 45)];
        [closeButton setImage:[UIImage imageNamed:@"ButtonCameraCloseOff.png"] forState:UIControlStateNormal];
        [closeButton setImage:[UIImage imageNamed:@"ButtonCameraCloseOn.png"] forState:UIControlStateHighlighted];
        [closeButton addTarget:self action:@selector(closeImagePicker:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:closeButton];
        
        UIView *toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 422, 320, 58)];
        [toolbarView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:toolbarView];
        
        UIImageView *toolbarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
        [toolbarBackground setImage:[UIImage imageNamed:@"BackgroundCameraToolbar.png"]];
        [toolbarView addSubview:toolbarBackground];
        
        openLibraryButton = [[UIButton alloc] initWithFrame:CGRectMake(258, 0, 56, 52)];
        [openLibraryButton setImage:[UIImage imageNamed:@"ButtonCameraOpenLibraryOff.png"] forState:UIControlStateNormal];
        [openLibraryButton setImage:[UIImage imageNamed:@"ButtonCameraOpenLibraryOn.png"] forState:UIControlStateHighlighted];
        [openLibraryButton addTarget:self action:@selector(openLibraryAction:) forControlEvents:UIControlEventTouchDown];
        [toolbarView addSubview:openLibraryButton];
        
        takePictureButton = [[UIButton alloc] initWithFrame:CGRectMake(137, 5, 47, 47)];
        [takePictureButton setImage:[UIImage imageNamed:@"ButtonCameraTakePictureOff.png"] forState:UIControlStateNormal];
        [takePictureButton setImage:[UIImage imageNamed:@"ButtonCameraTakePictureOn.png"] forState:UIControlStateHighlighted];
        [takePictureButton addTarget:self action:@selector(takeThePicture:) forControlEvents:UIControlEventTouchDown];
        [toolbarView addSubview:takePictureButton];
        
        cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(98, -3, 63, 63)];
        [cancelButton setImage:[UIImage imageNamed:@"ButtonCameraCancelOff.png"] forState:UIControlStateNormal];
        [cancelButton setImage:[UIImage imageNamed:@"ButtonCameraCancelOn.png"] forState:UIControlStateHighlighted];
        [cancelButton setAlpha:0.];
        [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchDown];
        [toolbarView addSubview:cancelButton];
        
        validButton = [[UIButton alloc] initWithFrame:CGRectMake(162, -3, 63, 63)];
        [validButton setImage:[UIImage imageNamed:@"ButtonCameraValidOff.png"] forState:UIControlStateNormal];
        [validButton setImage:[UIImage imageNamed:@"ButtonCameraValidOn.png"] forState:UIControlStateHighlighted];
        [validButton setAlpha:0.];
        [validButton addTarget:self action:@selector(validAction:) forControlEvents:UIControlEventTouchDown];
        [toolbarView addSubview:validButton];
    }
    
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    isTakingPicture = YES;
    
    // Detect le changement d'orientation
    UIDevice *device = [UIDevice currentDevice];
	[device beginGeneratingDeviceOrientationNotifications];
    
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:device];
}

- (void)viewDidUnload {
    [self setMaskTop:nil];
    [self setMaskBottom:nil];
    [self setTakePictureButton:nil];
    [self setImageRotation:nil];
    [self setCloseButton:nil];
    [self setCancelButton:nil];
    [self setValidButton:nil];
    [self setOpenLibraryButton:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self resetView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self resetView];
}

- (void)orientationChanged:(NSNotification *)note
{
    // On ne tourne les vues et autre que si l'utilisateur est en train de prendre une photo
    if (isTakingPicture == YES) {
        if ([[note object] orientation] == UIDeviceOrientationLandscapeLeft)
        {
            [self rotateImage:takePictureButton duration:0.3 curve:UIViewAnimationCurveEaseIn degrees:90];
            [self rotateImage:openLibraryButton duration:0.3 curve:UIViewAnimationCurveEaseIn degrees:90];
            [self rotateImage:cancelButton duration:0.3 curve:UIViewAnimationCurveEaseIn degrees:90];
            [self rotateImage:validButton duration:0.3 curve:UIViewAnimationCurveEaseIn degrees:90];
            
            [imageRotation setAlpha:0.];
            
            [UIView animateWithDuration:0.3 animations:^{
                [maskTop setFrame:CGRectMake(292, 0, 28, 480)];
                [maskBottom setFrame:CGRectMake(0, 0, 28, 480)];
                
                CGRect closeButtonFrame = closeButton.frame;
                closeButtonFrame.origin.x = 285;
                closeButtonFrame.origin.y = 5;
                closeButton.frame = closeButtonFrame;
            }];
        }
        else if ([[note object] orientation] == UIDeviceOrientationLandscapeRight)
        {
            [self rotateImage:takePictureButton duration:0.3 curve:UIViewAnimationCurveEaseIn degrees:-90];
            [self rotateImage:openLibraryButton duration:0.3 curve:UIViewAnimationCurveEaseIn degrees:-90];
            [self rotateImage:cancelButton duration:0.3 curve:UIViewAnimationCurveEaseIn degrees:-90];
            [self rotateImage:validButton duration:0.3 curve:UIViewAnimationCurveEaseIn degrees:-90];
            
            [imageRotation setAlpha:0.];
            
            [UIView animateWithDuration:0.3 animations:^{
                [maskTop setFrame:CGRectMake(292, 0, 28, 480)];
                [maskBottom setFrame:CGRectMake(0, 0, 28, 480)];
                
                CGRect closeButtonFrame = closeButton.frame;
                closeButtonFrame.origin.x = -8;
                closeButtonFrame.origin.y = 8;
                closeButton.frame = closeButtonFrame;
            }];
        }
        else {
            [self rotateImage:takePictureButton duration:0.3 curve:UIViewAnimationCurveEaseIn degrees:0];
            [self rotateImage:openLibraryButton duration:0.3 curve:UIViewAnimationCurveEaseIn degrees:0];
            [self rotateImage:cancelButton duration:0.3 curve:UIViewAnimationCurveEaseIn degrees:0];
            [self rotateImage:validButton duration:0.3 curve:UIViewAnimationCurveEaseIn degrees:0];
            
            [UIView animateWithDuration:0.3 animations:^{
                [maskTop setFrame:CGRectMake(0, 0, 320, 101)];
                [maskBottom setFrame:CGRectMake(0, 310, 320, 127)];
                
                CGRect closeButtonFrame = closeButton.frame;
                closeButtonFrame.origin.x = 275;
                closeButtonFrame.origin.y = 10;
                closeButton.frame = closeButtonFrame;
            } completion:^(BOOL finished) {
                [imageRotation setAlpha:1.];
            }];
        }
    }
}

- (void)rotateImage:(UIView *)view duration:(NSTimeInterval)duration curve:(int)curve degrees:(CGFloat)degrees
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeRotation(degrees / 180.0 * 3.14);
    view.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}

#pragma mark - Custom methods
- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePicker.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.showsCameraControls = NO;
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        
        // On vérifie si l'imagePicker n'a pas déjà l'overlay
        if ([[self.imagePicker.cameraOverlayView subviews] count] == 0)
        {
            CGRect overlayViewFrame = self.imagePicker.cameraOverlayView.frame;
            self.view.frame = overlayViewFrame;
            [self.imagePicker.cameraOverlayView addSubview:self.view];
        }
    }
}
     
- (void)resetView 
{
    [cancelButton setAlpha:0.];
    [validButton setAlpha:0.];
    
    [maskTop setAlpha:0.7];
    [maskBottom setAlpha:0.7];
    [takePictureButton setAlpha:1.];
    [openLibraryButton setAlpha:1.];
    [closeButton setAlpha:1.];
    [imageRotation setAlpha:1.];
    
    isTakingPicture = YES;
    
    [[self.view viewWithTag:1] removeFromSuperview];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{
    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera && libraryPicker == nil) 
    {
        isTakingPicture = NO;
        
        CGSize pictureSize;
        CGRect pictureFrame;
        
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
            pictureSize = CGSizeMake(422, 264);
            pictureFrame = CGRectMake(-51, 79, pictureSize.width, pictureSize.height);
        }
        else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
            pictureSize = CGSizeMake(422, 264);
            pictureFrame = CGRectMake(-51, 79, pictureSize.width, pictureSize.height);
        }
        else {
            pictureSize = CGSizeMake(320, 212);
            pictureFrame = CGRectMake(0, 101, pictureSize.width, pictureSize.height);
        }
        
        picture = [[info objectForKey:UIImagePickerControllerOriginalImage] imageByScalingAndCroppingForSize:pictureSize];
        UIImageView *pictureView = [[UIImageView alloc] initWithImage:picture];
        [pictureView setTag:1];
        [pictureView setFrame:pictureFrame];
        [self.view addSubview:pictureView];
        
        // Si on est en paysage, on tourne l'image
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
            CGAffineTransform transform = CGAffineTransformMakeRotation(90 / 180.0 * 3.14);
            pictureView.transform = transform;
        }
        else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
            CGAffineTransform transform = CGAffineTransformMakeRotation(-90 / 180.0 * 3.14);
            pictureView.transform = transform;
        }
        
        [maskTop setAlpha:1.];
        [maskBottom setAlpha:1.];
        [imageRotation setAlpha:0.];
        
        [closeButton setAlpha:0.];
        [openLibraryButton setAlpha:0.];
        [takePictureButton setAlpha:0.];
        
        [cancelButton setAlpha:1.];
        [validButton setAlpha:1.];
    }
    else 
    {
        // Si on est dans la bibliothèque, on supprime l'imagePicker
        if(delegate && [delegate respondsToSelector:@selector(didFinishPickingMediaWithInfo:)]) {
            [delegate didFinishPickingMediaWithInfo:[info objectForKey:UIImagePickerControllerOriginalImage]];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self dismissModalViewControllerAnimated:YES];
        libraryPicker = nil;
        
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
            [imageRotation setAlpha:1.];
        }
        else {
            [imageRotation setAlpha:0.];
        }
    }
    else {
        if(delegate && [delegate respondsToSelector:@selector(didFinishWithPicker)]) {
            [delegate didFinishWithPicker];
        }
    }
}

#pragma mark - Custom action
- (IBAction)takeThePicture:(id)sender
{
    [self.imagePicker takePicture];
}

- (IBAction)openLibraryAction:(id)sender
{    
    libraryPicker = [[UIImagePickerController alloc] init];
    [libraryPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [libraryPicker setDelegate:self];
    
    [self presentModalViewController:libraryPicker animated:YES];
}

- (IBAction)closeImagePicker:(id)sender
{
    if(delegate && [delegate respondsToSelector:@selector(didFinishWithPicker)]) {
        [delegate didFinishWithPicker];
    }
}

- (IBAction)cancelAction:(id)sender
{
    [self resetView];
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
        [imageRotation setAlpha:1.];
    }
    else {
        [imageRotation setAlpha:0.];
    }
}

- (IBAction)validAction:(id)sender
{
    if(delegate && [delegate respondsToSelector:@selector(didFinishPickingMediaWithInfo:)]) {
        [delegate didFinishPickingMediaWithInfo:picture];
    }
}

@end
