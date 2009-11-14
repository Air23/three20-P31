//
//  TTLauncherViewController.h
//  Three20
//
//  Created by Rodrigo Mazzilli on 9/25/09.

#import "Three20/TTViewController.h"
#import "P31LauncherView.h"


@interface P31LauncherViewController : TTViewController <UINavigationControllerDelegate> {
	UIView *_overlayView;
	P31LauncherView *_launcherView;
	UINavigationController *_launcherNavigationController;
}
@property(nonatomic, retain) UINavigationController *launcherNavigationController;
@property(nonatomic, readonly) P31LauncherView *launcherView;

@end
