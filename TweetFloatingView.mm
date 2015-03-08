#import <Social/Social.h>
#import "TweetFloatingView.h"

#define t_twitterView 0
#define t_facebookView 1
#define BUNDLEPATH @"/Library/PreferenceBundles/TweetSettings.bundle"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//IMAGES
UIImage* twitterImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:BUNDLEPATH] pathForResource:@"Tweet@2x" ofType:@"png"]];
UIImage* facebookImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:BUNDLEPATH] pathForResource:@"Face@2x" ofType:@"png"]];
//END 

@interface TweetFloatingView()

-(void)dragged:(UIPanGestureRecognizer *)sender;
-(void)snapToLeft;
-(void)snapToRight;
-(void)snapToBottom;
-(void)snapToTop;
-(void)collapse;
@end

@implementation TweetFloatingView
-(instancetype)init{
	self = [self initWithType:t_twitterView];
	return self;
}

-(instancetype)initWithType:(int)type{
	self = [super initWithFrame:CGRectMake(ScreenWidth,270,55,55)];
	_viewType = type;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collapse) name:@"Tweak-collapseDynamicView" object:nil];

	backgroundImage = type ? facebookImage : twitterImage;
	self.image = backgroundImage;
	self.userInteractionEnabled = YES;

    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:panRecognizer];
    [panRecognizer release];

    UITapGestureRecognizer* doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchSocial:)];
    [doubleTapRecognizer setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTapRecognizer];
    [doubleTapRecognizer release];

    UITapGestureRecognizer* singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSocialModel:)];
    [singleTapRecognizer setNumberOfTapsRequired:1];
    [self addGestureRecognizer:singleTapRecognizer];
    [singleTapRecognizer release];
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];

    return self;

}

-(void)dragged:(UIPanGestureRecognizer *)sender{

    if (sender.state == UIGestureRecognizerStateEnded){

        if(sender.view.center.y > [[UIScreen mainScreen] bounds].size.height-100){
            [self snapToBottom];
        }
        else if(sender.view.center.y < 100){
            [self snapToTop];
        }
        else{
        if(sender.view.center.x < [[UIScreen mainScreen] bounds].size.width+([[UIScreen mainScreen] bounds].size.width/2)){
            [self snapToLeft];
        }
        else if(sender.view.center.x >= [[UIScreen mainScreen] bounds].size.width+([[UIScreen mainScreen] bounds].size.width/2)){
            [self snapToRight]; 
        }
    }}
    if (sender.state == UIGestureRecognizerStateChanged){

    CGPoint translation = [sender translationInView:sender.view];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
    [sender setTranslation:CGPointMake(0, 0) inView:sender.view];

    }

}

-(void)snapToLeft{
    [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationCurveEaseIn animations:^{
                     self.frame = CGRectMake(ScreenWidth+5,self.frame.origin.y,[self bounds].size.width,[self bounds].size.height);
                 } completion:^(BOOL finished){}];
}

-(void)snapToRight{
    [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationCurveEaseIn animations:^{
                     self.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width*2-[self bounds].size.width-5,self.frame.origin.y,[self bounds].size.width,[self bounds].size.height);
                 } completion:^(BOOL finished){}];
}

-(void)snapToBottom{
    [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationCurveEaseIn animations:^{
                     self.frame = CGRectMake(self.frame.origin.x,[[UIScreen mainScreen] bounds].size.height-[self bounds].size.height-5,[self bounds].size.width,[self bounds].size.height);
                 } completion:^(BOOL finished){}];
}

-(void)snapToTop{
    [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationCurveEaseIn animations:^{
                     self.frame = CGRectMake(self.frame.origin.x,5,[self bounds].size.width,[self bounds].size.height);
                 } completion:^(BOOL finished){}];
}

-(void)collapse{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){self.hidden = YES;}];
}

-(void)showWithType:(int)type{

    switch(type){
        case t_twitterView:
            self.image = twitterImage;
            break;
        case t_facebookView:
            self.image = facebookImage;
            break;
    }

    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.hidden = NO;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){}];
}

-(void)switchSocial:(id)receiver{
    if(_viewType == t_twitterView){
        _viewType = t_facebookView;
    }
    else{
        _viewType = t_twitterView;
    }
    switch(_viewType){
        case t_twitterView:
            self.image = twitterImage;
            break;
        case t_facebookView:
            self.image = facebookImage;
            break;
    }
}

-(void)showSocialModel:(id)receiver{
    switch(_viewType){
        case t_twitterView:
            [self showTwitterModel];
            break;
        case t_facebookView:
            [self showFacebookModel];
            break;
    }
}

-(void)showTwitterModel{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){   
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),CFSTR("Tweet-stopIdleTimer"),NULL,NULL,YES);
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@""];
        tweetSheet.completionHandler = ^(SLComposeViewControllerResult){CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),CFSTR("Tweet-startIdleTimer"),NULL,NULL,YES);};
        [(UIViewController *)[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:tweetSheet animated:YES completion:nil];
    }
}

-(void)showFacebookModel{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),CFSTR("Tweet-stopIdleTimer"),NULL,NULL,YES);
        SLComposeViewController *faceSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [faceSheet setInitialText:@""];
        faceSheet.completionHandler = ^(SLComposeViewControllerResult){CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),CFSTR("Tweet-startIdleTimer"),NULL,NULL,YES);};
        [(UIViewController *)[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:faceSheet animated:YES completion:nil];
    }
}

@end



























