#import <Preferences/Preferences.h>
#define BUNDLEPATH @"/Library/PreferenceBundles/TweetSettings.bundle"
#define TWEETPLISTLOCATION @"/User/Library/Preferences/com.h3xept.tweetsettings.plist"

@interface PSTableCell ()
-(id)initWithSpecifier:(PSSpecifier *)specifier;
-(id)initWithStyle:(UITableViewCellStyle)x reuseIdentifier:(id)y specifier:(id)z;
@end

@interface TweetSettingsListController: PSListController {
}
-(void)showTutorial:(id)arg;
-(void)openWebsite:(id)arg;
-(void)openTwitter:(id)arg;
@end

@implementation TweetSettingsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"TweetSettings" target:self] retain];
	}
	return _specifiers;
}


-(id) readPreferenceValue:(PSSpecifier*)specifier {
	NSDictionary *exampleTweakSettings = [NSDictionary dictionaryWithContentsOfFile:TWEETPLISTLOCATION];
	if (!exampleTweakSettings[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
	return exampleTweakSettings[specifier.properties[@"key"]];
}
 
-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:TWEETPLISTLOCATION]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:TWEETPLISTLOCATION atomically:YES];
	CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
	if(toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

-(void)openTwitter:(id)arg{
	//twitter
	if(![[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://H3xept?screen_name=plungeint"]])
	{
    	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/H3xept"]];
	}
	
}

-(void)openWebsite:(id)arg{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.h3xept.com/"]];
}

-(void)showTutorial:(id)arg{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.h3xept.com/tweaks/tweet_tutorial.php"]];
}
@end

@interface HeaderCellTweet : PSTableCell{
	UIImageView *_bgImage;
}
@end

@implementation HeaderCellTweet

-(id)initWithSpecifier:(PSSpecifier *)specifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell" specifier:specifier];
    if (self) {
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:BUNDLEPATH] pathForResource:@"TweetHeader@2x" ofType:@"png"]];
		_bgImage = [[UIImageView alloc] initWithImage:image];
		[self addSubview:_bgImage];
    }

    return self;
}

-(float)preferredHeightForWidth:(float)arg1{
    return 100;
}

@end