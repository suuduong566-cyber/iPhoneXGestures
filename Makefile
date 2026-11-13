ARCHS = armv7
TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iPhoneXGestures
iPhoneXGestures_FILES = Tweak.xm
iPhoneXGestures_FRAMEWORKS = UIKit
iPhoneXGestures_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-arc-performSelector-leaks

include $(THEOS_MAKE_PATH)/tweak.mk

