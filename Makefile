export ARCHS = armv7 arm64
export THEOS_DEVICE_IP=192.168.1.6
include theos/makefiles/common.mk

TWEAK_NAME = Tweet
Tweet_FILES = Tweak.xm TweetHelper.mm TweetView.mm TweetDeclarations.mm TweetFloatingView.mm
Tweet_FRAMEWORKS = UIKit Social CoreGraphics
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += tweetsettings
include $(THEOS_MAKE_PATH)/aggregate.mk
