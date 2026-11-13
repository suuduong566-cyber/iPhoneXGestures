
TARGET = iphone:clang:latest:7.0
ARCHS = armv7

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iPhoneXGestures

iPhoneXGestures_FILES = Tweak.xm
iPhoneXGestures_FRAMEWORKS = UIKit
iPhoneXGestures_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

