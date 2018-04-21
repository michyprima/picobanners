@interface NCNotificationContentView : UIView
@property (nonatomic, assign) BOOL isFromBanner;
-(UILabel*)_primaryLabel;
-(NSString *)secondaryText;
-(NSString *)primaryText;
-(void)setPrimaryText:(NSString *)arg1 ;
@end

@interface MTPlatterHeaderContentView
@property (nonatomic, assign) BOOL isFromBanner;
@end

@interface NCNotificationShortLookView : UIView
-(NCNotificationContentView*)_notificationContentView;
-(MTPlatterHeaderContentView*)_headerContentView;
@property (nonatomic, assign) BOOL isFromBanner;
@end
