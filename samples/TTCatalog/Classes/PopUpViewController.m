//
//  PopUpViewController.m
//  TTCatalog
//
//  Created by Mike on 10/31/09.
//  Copyright 2009 Prime31 Studios. All rights reserved.
//

#import "PopUpViewController.h"


//static NSString *title = @"The title here The title here The title here.  Longer titles suck ass.";
static NSString *title = @"Helluva Login";
//static NSString *message = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin arcu sapien, vehicula nec facilisis pulvinar, egestas quis tellus.";
static NSString *message = @"Enter some stuff";
static NSString *cancelButtonTitle = @"Cancel";
#define otherButtons @"Login", @"Do other Stuff", @"Maybe, maybe not", @"Yet another One", nil


@implementation PopUpViewController

- (id)init
{
	_otherButtons = [[NSArray arrayWithObjects:@"Some Button", nil] retain];
	
	[TTStyleSheet setGlobalStyleSheet:[[[P31StyleSheet alloc] init] autorelease]];
	
	return [super initWithNibName:@"Popup" bundle:[NSBundle mainBundle]];
}


////////
#pragma mark P31Alert Tests

- (IBAction)onTouchHUD
{
	static int counter = 0;
	
	if( ++counter % 2 == 0 )
	{
		P31AlertView *alert = [[[P31AlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtons] autorelease];
		[alert show];
	}
	else
	{
		P31AlertView *alert = [[[P31AlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil] autorelease];
		[alert addTextFieldWithValue:nil placeHolder:@"Enter your name"];
		[alert addTextFieldWithValue:nil placeHolder:@"password"];
		[alert textFieldAtIndex:1].secureTextEntry = YES;
		[alert show];
	}
}


- (IBAction)onTouchAppleAlert
{
	static int counter = 0;
	
	if( ++counter % 2 == 0 )
	{
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtons] autorelease];
		//[alert addTextFieldWithValue:nil label:@"Enter your name"];
		//[alert addTextFieldWithValue:nil label:@"password"];
		//[alert addTextFieldWithValue:nil label:@"asdfasdfadsfa"];
		[alert show];
	}
	else
	{
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil] autorelease];
		[alert addTextFieldWithValue:nil label:@"Enter your name"];
		[alert addTextFieldWithValue:nil label:@"password"];
		[alert show];
	}
}


////////
#pragma mark P31LoadingView Tests

- (IBAction)onTouchLoadingView
{
	static int counter = 0;
	
	if( ++counter % 2 == 0 )
	{
		P31LoadingView *loadingView = [P31LoadingView loadingViewShowWithLoadingMessage];
		[loadingView performSelector:@selector(hide) withObject:nil afterDelay:1.0];
	}
	else
	{
		P31LoadingView *loadingView = [P31LoadingView loadingViewShowWithMessage:@"Loading with a\nlot of text"];
		[loadingView performSelector:@selector(hideWithDoneImage) withObject:nil afterDelay:1.0];
	}
}


////////
#pragma mark P31PopupButtonView Tests

- (IBAction)onTouchButton:(UIButton*)sender
{
	CGPoint buttonCenter = [self.view.window convertPoint:sender.center fromView:self.view];
	CGFloat yOffset = sender.frame.size.height / 2;
	
	P31PopupButtonView *popupButtonView = [[P31PopupButtonView alloc] initWithDelegate:self originPoint:buttonCenter yOffset:yOffset buttonTitles:@"One Button", @"Two Buttons", nil];
	[popupButtonView show];
}


- (IBAction)onTouchOtherButton:(UIButton*)sender
{
	CGPoint buttonCenter = [self.view.window convertPoint:sender.center fromView:self.view];
	CGFloat yOffset = sender.frame.size.height / 2;
	
	P31PopupButtonView *popupButtonView = [[[P31PopupButtonView alloc] initWithDelegate:self originPoint:buttonCenter yOffset:yOffset buttonTitles:@"Longer titles go here", @"Short one here", @"Then one more long one", nil] autorelease];
	popupButtonView.shouldAutoHide = YES;
	[popupButtonView show];
}


- (IBAction)onTouchOtherOtherButton:(UIButton*)sender
{
	CGPoint buttonCenter = [self.view.window convertPoint:sender.center fromView:self.view];
	CGFloat yOffset = sender.frame.size.height / 2;
	
	P31PopupButtonView *popupButtonView = [[[P31PopupButtonView alloc] initWithDelegate:self originPoint:buttonCenter yOffset:yOffset buttonTitles:@"Longer titles go here", @"Short one here", @"Then one more long one", @"poopernator", nil] autorelease];
	[popupButtonView show];
}


////////
#pragma mark P31PopupButtonViewDelegate

- (void)popupView:(P31PopupButtonView*)popupView didTouchObjectAtIndex:(int)index withTitle:(NSString*)title
{
	NSLog( @"popupButton touched.  Index: %i, title: %@", index, title );
}


////////
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}


////////
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"UIAlertView clicked button at index: %i", buttonIndex);
}


///////
#pragma mark P31AlertViewDelegate

- (void)alertView:(P31AlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex withTitle:(NSString*)title
{
	NSLog(@"P31AlertView clicked button at index: %i with title: %@", buttonIndex, title);
	
	NSString *stuff = [alertView textForTextFieldAtIndex:0];
	if( stuff != nil )
		NSLog(@"the first textField had value: %@", stuff);
}

@end
