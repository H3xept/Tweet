@interface TweetFloatingView : UIImageView{
	UIImage* backgroundImage;
}
@property (nonatomic,readwrite) int viewType;
-(instancetype)initWithType:(int)type;
-(void)showWithType:(int)type;
-(void)switchSocial:(id)receiver;
-(int)viewType;
@end
