//
//  EditAccountLayer.h
//  Sound Out Phonics
//
//  Purpose: An overlay that allows to edit accounts
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/EditAccountLayer.h
//
//  Style: The source code will follow the general apple coding standard described
//         here: https://tinyurl.com/n8jtvj3
//         Furthermore, the source code will be self descriptive and the formating
//         will be consistent through the project. Long methods will be broken down
//         and will have description of what the method does. The variable names and
//         methods will follow the lower camel style (ex: selectedGraphemePosition),
//         the classes will follow the upper camel style (ex: GameLayer) and the
//         files will use the Cocos2d-iphone file name convention (ex: Lvl1-Apple-
//         Sprite.png). Finally, the code will have comments throughout various non
//         trivial operations.
//
//  Created on 2013-12-1.
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
