//
//  BQCameraViewController.h
//  BurgerQuest
//
//  Created by Laurent MENU on 09/08/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BQCameraDelegate <NSObject>

@optional
- (void)didFinishPickingMediaWithInfo:(UIImage *)image;
- (void)didFinishWithPicker;

@end

@interface BQCameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    id <BQCameraDelegate> delegate;
    UIImagePickerController *libraryPicker;
    UIImage *picture;
    BOOL isTakingPicture;
}

@property (retain) id delegate;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (strong, nonatomic) IBOutlet UIView *maskTop;
@property (strong, nonatomic) IBOutlet UIView *maskBottom;
@property (strong, nonatomic) IBOutlet UIButton *takePictureButton;
@property (strong, nonatomic) IBOutlet UIButton *openLibraryButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageRotation;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *validButton;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;
- (void)rotateImage:(UIView *)view duration:(NSTimeInterval)duration curve:(int)curve degrees:(CGFloat)degrees;
- (void)resetView;

- (IBAction)takeThePicture:(id)sender;
- (IBAction)openLibraryAction:(id)sender;
- (IBAction)closeImagePicker:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)validAction:(id)sender;

@end
