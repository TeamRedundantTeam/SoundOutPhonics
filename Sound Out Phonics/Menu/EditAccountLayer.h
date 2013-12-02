//
//  EditAccountLayer.h
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-11-28.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "StateText.h"
#import "ManageAccountLayer.h"

@interface EditAccountLayer : CCLayerColor <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate> {
    CCLabelTTF *_layerName;                 // Keeps track of the layer name
    UITextField *_nameTextBox;              // Account name textbox
    UITextField *_passwordTextBox;          // Password textbox input field
    UITextField *_confirmPasswordTextBox;   // Confirm password textbox input field
    StateText *_updateAccountButton;        // Reference to account button
    StateText *_updatePictureButton;        // Reference to picture button
    CCLabelTTF *_errorMessage;              // Reference to the error message
    CCSprite *_exitButton;                  // Reference to the exit button
}

- (id)initWithColor:(ccColor4B)color withAccount:(Account *)account;

@property (retain, nonatomic) UITextField *nameTextBox;
@property (retain, nonatomic) UITextField *passwordTextBox;
@property (retain, nonatomic) UITextField *confirmPasswordTextBox;
@property (retain, nonatomic) Account *account;
@end
