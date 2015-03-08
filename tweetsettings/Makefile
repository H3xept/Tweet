include theos/makefiles/common.mk

BUNDLE_NAME = TweetSettings
TweetSettings_FILES = TweetSettings.mm
TweetSettings_INSTALL_PATH = /Library/PreferenceBundles
TweetSettings_FRAMEWORKS = UIKit
TweetSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/TweetSettings.plist$(ECHO_END)
