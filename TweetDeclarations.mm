#import <SpringBoard/SpringBoard.h>
#import <UIKit/UIKit.h>

@interface SBLockScreenManager
+(id)sharedInstance;
@end

@interface SBLockScreenViewController : UIViewController
-(UIViewController*)_notificationController;
@end

@interface SBLockScreenView
@end

@interface SBLockScreenScrollView : UIScrollView
@end

@interface SBLockScreenNotificationListView : UIView
-(void)_updateTotalContentHeight;
@end