#import "MarqueeLabel.h"
#import "Interfaces.h"
#import "PB.h"

%group main

%hook NCLookHeaderContentView

%property (nonatomic, assign) BOOL isFromBanner;

-(double)_headerHeight {
	if(self.isFromBanner)
		return 0;
	else
		return %orig;
}

-(void)setTitle:(NSString *)arg1 {
	if(self.isFromBanner)
		%orig(@"");
	else
		%orig;
}

-(void)_configureDateLabelIfNecessary {
	if(!self.isFromBanner)
		%orig;
}

-(void)setFrame:(CGRect)arg1 {
	if(self.isFromBanner) {
		arg1.origin.y = -8;
		arg1.origin.x = -8;
	}
	%orig;
}

-(BOOL)adjustsFontForContentSizeCategory {
    if(self.isFromBanner)
        return NO;

    return %orig;
}

%end

%hook NCShortLookView

-(void)setBanner:(BOOL)arg1 {
	%orig;
	NCLookHeaderContentView* i = [self _headerContentView];
	if(i)
		i.isFromBanner = arg1;
}

-(double)cornerRadius {
	if([self isBanner]) {
		return %orig/2;
	}
	return %orig;
}

-(void)_configureHeaderOverlayViewIfNecessary {
	if(![self isBanner])
		%orig;
}

-(void)_configureShadowViewIfNecessary {
	if(![self isBanner])
		%orig;
}


-(void)_configureMainOverlayViewIfNecessary {
	if(![self isBanner])
		%orig;
}

%end

%hook NCNotificationContentView
%property (nonatomic, assign) BOOL isFromBanner;

-(id)_newPrimaryLabel {
	UILabel *o = %orig;
	
	if(self.isFromBanner) {
		o = [[[MarqueeLabel alloc] initWithFrame:o.frame rate:85.0 andFadeLength:0.0f]retain];
		((MarqueeLabel*)o).trailingBuffer = 20;
	}
	
	return o;
}

-(CGSize)sizeThatFits:(CGSize)arg1 {
	CGSize s = %orig;
	
	if(self.isFromBanner) {
		s.height = 20;
	}
	
	return s;
}

-(void)setFrame:(CGRect)arg1 {
	if(self.isFromBanner) {
		arg1.origin.y = -8;
		arg1.origin.x = 8;
	}
	
	%orig;
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
				
				NSString* secondaryText = [self hintText];
				
				if(!secondaryText || secondaryText.length == 0)
				secondaryText = [self secondaryText];
				
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

-(id)_newSecondaryLabel {
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

-(void)setBanner:(BOOL)arg1 {
	%orig;
	NCNotificationContentView* i = [self _notificationContentView];
	if(i) {
		i.isFromBanner = arg1;
	}
}

-(void)setThumbnail:(UIImage *)arg1 {
	if([self isBanner])
		%orig(nil);
	else
		%orig;
}

-(BOOL)_shouldShowGrabber {
	if([self isBanner])
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
-(id)_startTimerWithDelay:(unsigned long long)arg1 eventHandler:(/*^block*/id)arg2 {
	return %orig(MAX(arg1, [PB sharedInstance].savedAnimationDuration),arg2);
}
%end

%end


%group ios101
%hook MarqueeLabel

- (double)_firstLineBaselineOffsetFromBoundsTop {
	return 14;
}

%end
%end

%ctor {
    %init(main);
    
    if (kCFCoreFoundationVersionNumber < 1348.22)
        %init(ios101);
}