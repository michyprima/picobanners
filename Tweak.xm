#import "MarqueeLabel.h"
#import "Interfaces.h"
#import "PB.h"

%hook NCNotificationContentView

%property (nonatomic, assign) BOOL isFromBanner;

-(void)setFrame:(CGRect)arg1 {
	if(self.isFromBanner) {
		arg1.origin.y = -8;
		arg1.origin.x = 10;
	}
	
	%orig;
}

-(id)_newPrimaryLabel {
	UILabel *o = %orig;
	
	if(self.isFromBanner) {
		o = [[[MarqueeLabel alloc] initWithFrame:o.frame rate:85.0 andFadeLength:0.0f]retain];
		((MarqueeLabel*)o).trailingBuffer = 20;
	}
	
	return o;
}


-(void)setPrimaryText:(NSString *)arg1 {
	if(self.isFromBanner) {
		if(arg1 != nil)
			%orig;
		else
			arg1 = [self primaryText];
		
		UILabel * label = [self _primaryLabel];
		
		if (label) {
			@try {
				
				PB *pb = [PB sharedInstance];
				
				/*NSString* secondaryText = [self hintText];
				
				if(!secondaryText || secondaryText.length == 0)*/
				NSString* secondaryText = [self secondaryText];
				
				secondaryText = [pb fixSecondaryString:secondaryText];
				
				NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
				style.alignment = NSTextAlignmentLeft;
				//style.firstLineHeadIndent = 10.0f;
				//style.headIndent = 10.0f;
				
				NSMutableAttributedString *attrText;
				if(arg1 && arg1.length > 0 && secondaryText && secondaryText.length > 0) {
					attrText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@", arg1, secondaryText] attributes:@{ NSParagraphStyleAttributeName : style}];  
					
					[attrText beginEditing];
					[attrText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIText-Semibold" size:14] range:NSMakeRange(0,arg1.length)];
					[attrText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIText" size:14] range:NSMakeRange(arg1.length, secondaryText.length+2)];
					[attrText endEditing];
				} else if(secondaryText && secondaryText.length) {
					attrText = [[NSMutableAttributedString alloc] initWithString:secondaryText attributes:@{ NSParagraphStyleAttributeName : style}];  
					
					[attrText beginEditing];
					[attrText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIText" size:14] range:NSMakeRange(0, secondaryText.length)];
					[attrText endEditing];
				} else if(arg1 && arg1.length) {
					attrText = [[NSMutableAttributedString alloc] initWithString:arg1 attributes:@{ NSParagraphStyleAttributeName : style}];
					
					[attrText beginEditing];
					[attrText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@".SFUIText-Semibold" size:14] range:NSMakeRange(0,arg1.length)];
					[attrText endEditing];
				} else {
					attrText = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{ NSParagraphStyleAttributeName : style}];
				}
				
				label.numberOfLines = 1;
				label.adjustsFontSizeToFitWidth = NO;
				label.lineBreakMode = NSLineBreakByTruncatingTail;
				label.attributedText = attrText;
				
				if ([label isKindOfClass:[MarqueeLabel class]]) {
					MarqueeLabel *view3 = (MarqueeLabel*)label;
					pb.savedAnimationDuration = view3.animationDuration + view3.animationDelay + 1;
				}
			} @catch (NSException *exception) {
			#ifdef DEBUG
				NSLog(@"%@", exception.reason);
			#endif
			}
		}
	} else {
		%orig;
	}
}

-(void)setSecondaryText:(NSString *)arg1 {
	%orig;
	if(self.isFromBanner) {
		[self setPrimaryText:nil];
	}
}

-(void)setPrimarySubtitleText:(NSString *)arg1 {
	%orig;
	if(self.isFromBanner) {
		[self setPrimaryText:nil];
	}
}

-(id)_newSecondaryTextView {
	UILabel *l = %orig;
	
	if(self.isFromBanner && l) {
		l.hidden = YES;
	}
	
	return l;
}

-(id)_lazyPrimarySubtitleLabel {
	UILabel *l = %orig;
	
	if(self.isFromBanner && l) {
		l.hidden = YES;
	}
	
	return l;
}

%end

%hook NCNotificationShortLookView

%property (nonatomic, assign) BOOL isFromBanner;
%property (nonatomic, assign) BOOL isFromBannerWasSet;

%new -(BOOL) isBanner {
	if(!self.isFromBannerWasSet) {
		self.isFromBanner = [[NSThread callStackSymbols][9] rangeOfString:@"UserNotificationsUIKit"].location == NSNotFound;
		self.isFromBannerWasSet = YES;
	}
	return self.isFromBanner;
}

-(CGSize)sizeThatFitsContentWithSize:(CGSize)arg1 {
    CGSize s = %orig;
    
    if([self isBanner]) {
        s.height = 20;
    }
    
    return s;
}

-(void)_configureHeaderContentView {
	%orig;
	
	MTPlatterHeaderContentView* view = [self _headerContentView];
	
	if(view)
		view.isFromBanner = [self isBanner];
}

-(void)_configureHeaderOverlayViewIfNecessary {
	
}

-(void)_configureMainOverlayView {
	
}

-(void)_configureShadowViewIfNecessary {
	
}

-(id)_newNotificationContentView {
	NCNotificationContentView *view = %orig;
	
	if(view)
		view.isFromBanner = [self isBanner];
	
	return view;
}

-(double)cornerRadius {
	if([self isBanner])
		return %orig/2;
	
	return %orig;
}

-(BOOL)adjustsFontForContentSizeCategory {
    return [self isBanner] ? NO : %orig;
}

-(void)setThumbnail:(UIImage *)arg1 {
	if([self isBanner])
		%orig(nil);
	else
		%orig;
}

%end

%hook MTPlatterHeaderContentView

%property (nonatomic, assign) BOOL isFromBanner;

-(double)_headerHeightForWidth:(double)arg1 {
    return self.isFromBanner ? 20 : %orig;;
}

-(double)contentBaseline {
	return self.isFromBanner ? 0 : %orig;
}

-(void)setFrame:(CGRect)arg1 {
	if(self.isFromBanner) {
		arg1.origin.x = -10;
	}
	
	%orig;
}

-(id)_dateLabel {
	UILabel *l = %orig;
	
	if(self.isFromBanner && l) {
		l.hidden = YES;
	}
	
	return l;
}

-(id)_lazyTitleLabel {
		UILabel *l = %orig;
	
	if(self.isFromBanner && l) {
		l.hidden = YES;
	}
	
	return l;
}

-(id)_lazyOutgoingTitleLabel {
			UILabel *l = %orig;
	
	if(self.isFromBanner && l) {
		l.hidden = YES;
	}
	
	return l;
}

-(BOOL)adjustsFontForContentSizeCategory {
    if(self.isFromBanner)
        return NO;

    return %orig;
}

%end

%hook NCBannerPresentationController
+(CGRect)useableContainerViewFrameInContainerViewWithBounds:(CGRect)arg1 {
	arg1.origin.y=-8;
	arg1.origin.x = -4;
	arg1.size.width+=8;
	return %orig;
}
%end

%hook SBNotificationBannerDestination
-(id)_startTimerWithDelay:(unsigned long long)arg1 eventHandler:(id)arg2 {
	return %orig(MAX(arg1, [PB sharedInstance].savedAnimationDuration),arg2);
}
%end