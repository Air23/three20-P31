//
//  P31LauncherView.m
//  Three20
//
//  Created by Mike on 11/5/09.
//  Copyright 2009 Prime31 Studios. All rights reserved.
//

#import "P31LauncherView.h"
#import <Three20/TTLauncherItem.h>
#import <Three20/TTLauncherButton.h>

@implementation P31LauncherView

- (void)wobble
{
	static BOOL wobblesLeft = NO;
	
	if( _editing )
	{
		CGFloat rotation = (1.5 * M_PI) / 180.0;
		CGAffineTransform wobbleLeft = CGAffineTransformMakeRotation(rotation);
		CGAffineTransform wobbleRight = CGAffineTransformMakeRotation(-rotation);
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.07];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(wobble)];
		
		NSInteger i = 0;
		NSInteger j = 0;
		for( NSArray* buttonPage in _buttons )
		{
			for( TTLauncherButton* button in buttonPage )
			{
				if( button != _dragButton )
				{
					++j;
					if( i % 2 )
						button.transform = wobblesLeft ? wobbleRight : wobbleLeft;
					else
						button.transform = wobblesLeft ? wobbleLeft : wobbleRight;
				}
				++i;
			}
		}
		
		// Only commit the animation if we have more than 1 item to animate!!!
		if( j >= 1 )
		{
			[UIView commitAnimations];
			wobblesLeft = !wobblesLeft;	
		}
		else
		{
			[NSObject cancelPreviousPerformRequestsWithTarget:self];
			[self performSelector:@selector(wobble) withObject:nil afterDelay:0.1];
		}
	}
}

@end
