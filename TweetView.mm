#import "TweetView.h"
#import <UIKit/UIKit.h>
#import <Social/Social.h>
#define BUNDLEPATH @"/Library/PreferenceBundles/TweetSettings.bundle"

@interface TweetView()
-(void)collapse;
@end

@implementation TweetView

-(instancetype)init{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collapse) name:@"Tweak-collapseStaticView" object:nil];
	self = [super initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width,130,[UIScreen mainScreen].bounds.size.width,100)];
	self.backgroundColor = [UIColor clearColor];
	self.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*2,100);
	self.pagingEnabled = YES;
	[self setShowsHorizontalScrollIndicator:NO];
	[self setShowsVerticalScrollIndicator:NO];

	UIImage* tweetImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:BUNDLEPATH] pathForResource:@"Tweet@2x" ofType:@"png"]];
	UIImageView* tweetImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,55,55)]; 
	tweetImageView.center = CGPointMake(self.frame.size.width/2,self.frame.size.height/2);
	tweetImageView.image = tweetImage;
	tweetImageView.userInteractionEnabled = YES;

	UIImage* faceImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:BUNDLEPATH] pathForResource:@"Face@2x" ofType:@"png"]];
	UIImageView* faceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,55,55)]; 
	faceImageView.center = CGPointMake(self.frame.size.width*2-(self.frame.size.width/2),self.frame.size.height/2);
	faceImageView.image = faceImage;
	faceImageView.userInteractionEnabled = YES;

	UITapGestureRecognizer* tweetTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTweetTap:)];
	tweetTouch.numberOfTapsRequired = 1;

	UITapGestureRecognizer* faceTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFaceTap:)];
	faceTouch.numberOfTapsRequired = 1;

	[tweetImageView addGestureRecognizer:tweetTouch];
	[faceImageView addGestureRecognizer:faceTouch];

	[self addSubview:tweetImageView];
	[self addSubview:faceImageView];

	return self;
}

-(instancetype)initWithFrame{
	self = [self init];
	return self;
}

-(void)handleTweetTap:(UITapGestureRecognizer *)recognizer{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){	
    	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),CFSTR("Tweet-stopIdleTimer"),NULL,NULL,YES);
		SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    	[tweetSheet setInitialText:@""];
    	tweetSheet.completionHandler = ^(SLComposeViewControllerResult){CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),CFSTR("Tweet-startIdleTimer"),NULL,NULL,YES);};
    	[(UIViewController *)[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:tweetSheet animated:YES completion:nil];
    }
}

-(void)handleFaceTap:(UITapGestureRecognizer *)recognizer{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
    	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),CFSTR("Tweet-stopIdleTimer"),NULL,NULL,YES);
		SLComposeViewController *faceSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    	[faceSheet setInitialText:@""];
    	faceSheet.completionHandler = ^(SLComposeViewControllerResult){CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),CFSTR("Tweet-startIdleTimer"),NULL,NULL,YES);};
    	[(UIViewController *)[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:faceSheet animated:YES completion:nil];
    }
}

-(void)collapse{
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
	    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
	} completion:^(BOOL finished){self.hidden = YES;}];
}

-(void)showAtIndex:(int)index{
	self.transform = CGAffineTransformMakeScale(0.01, 0.01);
	self.hidden = NO;
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
	    self.transform = CGAffineTransformIdentity;
	} completion:^(BOOL finished){}];
	[self setContentOffset:CGPointMake(self.frame.size.width*index,0) animated:NO];
}

-(int)page{
	int pageNumber = floor((self.contentOffset.x - [UIScreen mainScreen].bounds.size.width / 2) / [UIScreen mainScreen].bounds.size.width);
	return pageNumber+1;
}
@end










