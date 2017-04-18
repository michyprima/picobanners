@interface PB : NSObject
@property (strong, nonatomic) NSRegularExpression *spacesRegex;
@property (strong, nonatomic) NSRegularExpression *lineRegex;
-(NSString*)fixSecondaryString:(NSString*)secondaryText;
+ (PB*)sharedInstance;
@end