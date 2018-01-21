include $(THEOS)/makefiles/common.mk

ARCHS = arm64
TWEAK_NAME = PicoBanners
PicoBanners_FILES = Tweak.xm MarqueeLabel.m PB.m
PicoBanners_FRAMEWORKS = UIKit CoreGraphics QuartzCore
ADDITIONAL_OBJCFLAGS = -Iinclude

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
