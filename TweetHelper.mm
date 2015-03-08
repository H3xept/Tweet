#import "TweetHelper.h"
#define TWEETPLISTLOCATION @"/User/Library/Preferences/com.h3xept.tweetsettings.plist"

@implementation TweetHelper

-(instancetype)initPrivate{
	self = [super init];
	return self;
}

+(instancetype)sharedInstance{
	static TweetHelper *privateHelper = nil;
	if(!privateHelper){
		privateHelper = [[TweetHelper alloc] initPrivate];
	}
	return privateHelper;
}

-(void)reloadPrefs{
    TweetSettings = [NSMutableDictionary dictionaryWithContentsOfFile:TWEETPLISTLOCATION];

    isActiveKey = TweetSettings[@"isActive"];
    _isActive = isActiveKey ? [isActiveKey boolValue] : 1;

}
@end