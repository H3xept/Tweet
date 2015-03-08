@interface TweetView : UIScrollView{
	
}
-(void)handleTweetTap:(UITapGestureRecognizer *)recognizer;
-(void)handleFaceTap:(UITapGestureRecognizer *)recognizer;
-(void)showAtIndex:(int)index;
-(int)page;
@end