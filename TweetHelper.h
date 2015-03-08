#import "TweetDeclarations.mm"

@interface TweetHelper : NSObject{
	NSNumber* isActiveKey;
	NSMutableDictionary* TweetSettings;
}

@property (nonatomic) BOOL isActive;

+(instancetype)sharedInstance;
-(instancetype)initPrivate;
-(void)reloadPrefs;
@end
