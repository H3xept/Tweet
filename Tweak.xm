#import "TweetView.h"
#import "TweetDeclarations.mm"
#import "TweetHelper.h"
#import "TweetFloatingView.h"

#import <Social/Social.h>

#define t_twitterView 0
#define t_facebookView 1

//G VARS
BOOL shouldSleep = 1;
BOOL isActive;
TweetFloatingView* mainFloatingView;
TweetView* mainView;
// END

//C HELPERS
SBLockScreenScrollView* getScroller();
void stopIdleTimer();
void startIdleTimer();
void preferencesChanged();
// END

//INTERFACES
@interface SBBacklightController
+(id)sharedInstance;
-(void)resetLockScreenIdleTimer;
@end

@interface SBUIController : NSObject
@end
//END 

//CREATE SCROLL VIEW
%hook SBLockScreenViewController
-(void)viewWillAppear:(BOOL)arg1{
	if([[TweetHelper sharedInstance] isActive] && !mainView){
	mainView = [[TweetView alloc] init];
	[getScroller() addSubview:mainView];
	}	
	%orig;
}
%end
//END

//PREVENT SLEEPING WHILE INTERACTING WITH SOCIAL PANE
%hook SBBacklightController

-(void)_animateBacklightToFactor:(float)factor duration:(double)duration source:(int)source silently:(BOOL)silently completion:(id)completion{
	if(shouldSleep)
		%orig;
	else
		return;
}
%end
//END

//HANDLE EVENTS TO ANIMATE BADGES
%hook SBLockScreenViewController

-(void)notificationListBecomingVisible:(BOOL)arg1{
	%orig;
	if([[TweetHelper sharedInstance] isActive]){
	if(arg1){
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Tweak-collapseStaticView" object:nil];
	if(!mainFloatingView){
		mainFloatingView = [[TweetFloatingView alloc] initWithType:[mainView page]];
		mainFloatingView.hidden = YES;
		[getScroller() addSubview:mainFloatingView];
		[mainFloatingView showWithType:[mainView page]];

	}else{[mainFloatingView showWithType:[mainView page]];}
	}
	if(!arg1){
		[[NSNotificationCenter defaultCenter] postNotificationName:@"Tweak-collapseDynamicView" object:nil];
		[mainView showAtIndex:[mainFloatingView viewType]];
	}
	}
}
%end

%hook SBLockScreenManager

-(void)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2{
	%orig;
	mainFloatingView = nil;
	mainView = nil;
}

%end
//END

%hook SpringBoard
-(void)_handleMenuButtonEvent{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){	

    	UIWindow* tweetWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    	tweetWindow.windowLevel = UIWindowLevelAlert+1;
    	tweetWindow.backgroundColor = [UIColor clearColor];

		SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    	[tweetSheet setInitialText:@""];
    	tweetSheet.completionHandler = ^(SLComposeViewControllerResult){CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),CFSTR("Tweet-startIdleTimer"),NULL,NULL,YES); [tweetWindow release];};

    	tweetWindow.rootViewController = tweetSheet;
    	[tweetWindow makeKeyAndVisible];

    }
    %orig;
}
%end

//HELPERS
SBLockScreenScrollView* getScroller(){
	SBLockScreenViewController* lockScreenViewController = MSHookIvar<SBLockScreenViewController*>([%c(SBLockScreenManager) sharedInstance], "_lockScreenViewController");
	SBLockScreenView* lockScreenView = MSHookIvar<SBLockScreenView*>(lockScreenViewController, "_view");
	SBLockScreenScrollView* lockScreenScroller = MSHookIvar<SBLockScreenScrollView*>(lockScreenView, "_foregroundScrollView");
	return lockScreenScroller;
}

void stopIdleTimer(){
	shouldSleep = 0;
}

void startIdleTimer(){
	shouldSleep = 1;
	[[%c(SBBacklightController) sharedInstance] resetLockScreenIdleTimer];

}

void preferencesChanged(){
	[[TweetHelper sharedInstance] reloadPrefs];
}
//END

%ctor{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)stopIdleTimer, CFSTR("Tweet-stopIdleTimer"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)startIdleTimer, CFSTR("Tweet-startIdleTimer"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("com.h3xept.tweet-tweetPreferencesChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    preferencesChanged();
}
