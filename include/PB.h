@interface PB : NSObject
@property (assign, nonatomic) int savedAnimationDuration;
@property (strong, nonatomic) NSRegularExpression *spacesRegex;
@property (strong, nonatomic) NSRegularExpression *lineRegex;
-(NSString*)fixSecondaryString:(NSString*)secondaryText;
+ (PB*)sharedInstance;
@end