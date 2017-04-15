@interface NCLookHeaderContentView : UIView
@property (nonatomic, assign) BOOL isFromBanner;
-(UIButton *)iconButton;
@end

@interface NCNotificationContentView : UIView
@property (nonatomic, assign) BOOL isFromBanner;
-(UILabel*)_primaryLabel;
-(NSString *)secondaryText;
-(NSString *)primaryText;
-(void)setPrimaryText:(NSString *)arg1 ;
-(id)_secondaryLabel;
-(void)setPrimarySubtitleText:(NSString *)arg1 ;
-(NSString *)primarySubtitleText;
-(UIEdgeInsets)_contentInsetsForShortLook;
@end

@interface NCShortLookView : UIView
-(NCLookHeaderContentView*)_headerContentView;
-(UIView *)customContentView;
-(BOOL)isBanner;
@end

@interface NCNotificationShortLookView : NCShortLookView
-(NCNotificationContentView*)_notificationContentView;
@end

@interface PB : NSObject
@property (strong, nonatomic) NSRegularExpression *spacesRegex;
@property (strong, nonatomic) NSRegularExpression *lineRegex;
-(NSString*)fixSecondaryString:(NSString*)secondaryText;
@end