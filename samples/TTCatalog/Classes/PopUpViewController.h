//
//  PopUpViewController.h
//  TTCatalog
//
//  Created by Mike on 10/31/09.
//  Copyright 2009 Prime31 Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>


@interface PopUpViewController : UIViewController <P31PopupButtonViewDelegate>
{
	NSArray *_otherButtons;
}

- (IBAction)onTouchHUD;
- (IBAction)onTouchAppleAlert;

- (IBAction)onTouchLoadingView;

- (IBAction)onTouchButton:(UIButton*)sender;
- (IBAction)onTouchOtherButton:(UIButton*)sender;
- (IBAction)onTouchOtherOtherButton:(UIButton*)sender;


@end
