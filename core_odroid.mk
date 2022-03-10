# Inherit from those products. Most specific first.

# Define the host tools and libs that are parts of the SDK.
ifneq ($(filter sdk win_sdk sdk_addon,$(MAKECMDGOALS)),)
-include sdk/build/product_sdk.mk
-include development/build/product_sdk.mk

PRODUCT_PACKAGES += \
    EmulatorSmokeTests
endif

# Additional settings used in all AOSP builds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.android.dateformat=MM-dd-yyyy

ALLOW_MISSING_DEPENDENCIES := true

PRODUCT_PACKAGES += \
    libWnnEngDic \
    libWnnJpnDic \
    libwnndict

PRODUCT_PACKAGES += \
    libfdt \
    libufdt \
    dtc

PRODUCT_PACKAGES += \
    VisualizationWallpapers

PRODUCT_PACKAGES += \
    audio.primary.default \
    audio_policy.default \
    audio.dia_remote.default

PRODUCT_PACKAGES += \
    local_time.default

PRODUCT_COPY_FILES += \
        frameworks/av/media/libeffects/data/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.conf

PRODUCT_PROPERTY_OVERRIDES += \
    ro.carrier=unknown \
    debug.sf.disable_backpressure=1 \
    debug.sf.latch_unsignaled=1 \
    net.tethering.noprovisioning=true

$(call inherit-product-if-exists, external/naver-fonts/fonts.mk)
ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
  $(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
else
  $(call inherit-product, device/google/atv/products/atv_base.mk)
endif
#default hardware composer version is 2.0
TARGET_USES_HWC2 := true

ifneq ($(wildcard $(BOARD_AML_VENDOR_PATH)/frameworks/av/LibPlayer),)
    WITH_LIBPLAYER_MODULE := true
else
    WITH_LIBPLAYER_MODULE := false
endif

# set soft stagefright extractor&decoder as defaults
WITH_SOFT_AM_EXTRACTOR_DECODER := true

PRODUCT_PROPERTY_OVERRIDES += \
    camera.disable_zsl_mode=1

# USB camera default face
PRODUCT_PROPERTY_OVERRIDES += \
    ro.media.camera_usb.faceback=false

ifeq ($(TARGET_BUILD_LIVETV), true)
PRODUCT_PACKAGES += \
    libjnidtvepgscanner \
    LiveTv \
    libtunertvinput_jni
endif

PRODUCT_PACKAGES += \
    droidlogic \
    droidlogic-res \
    droidlogic.software.core.xml \
    systemcontrol \
    systemcontrol_static \
    libsystemcontrolservice \
    libsystemcontrol_jni  \
    vendor.amlogic.hardware.systemcontrol@1.0_vendor

ifeq ($(TARGET_BUILD_GOOGLE_ATV), true)
#add tv library
PRODUCT_PACKAGES += \
    droidlogic-tv \
    droidlogic.tv.software.core.xml \
    libtv_jni
endif

PRODUCT_PACKAGES += \
    libdig \
    BluetoothRemote

PRODUCT_PACKAGES += \
    hostapd \
    wpa_supplicant \
    wpa_supplicant.conf \
    dhcpcd.conf \
    libds_jni \
    libsrec_jni \
    system_key_server \
    usb_modeswitch \
    libwifi-hal \
    libwpa_client \
    libGLES_mali \
    network \
    sdptool \
    e2fsck \
    libxml2 \
    libamgralloc_ext \
    gralloc.$(TARGET_PRODUCT) \
    power.$(TARGET_PRODUCT) \
    hwcomposer.$(TARGET_PRODUCT) \
    memtrack.$(TARGET_PRODUCT) \
    screen_source.$(TARGET_PRODUCT) \
    thermal.$(TARGET_PRODUCT)

# toybox static
PRODUCT_PACKAGES += \
    toybox_static

#glscaler and 3d format api
PRODUCT_PACKAGES += \
    libdisplaysetting

#native image player surface overlay so
PRODUCT_PACKAGES += \
    libsurfaceoverlay_jni

#native gif decode so
PRODUCT_PACKAGES += \
    libgifdecode_jni

#native bluetooth rc control
PRODUCT_PACKAGES += \
    libamlaudiorc \
    libremotecontrol_jni \
    libremotecontrolserver \
    vendor.amlogic.hardware.remotecontrol@1.0 \
    vendor.amlogic.hardware.remotecontrol@1.0_vendor

PRODUCT_PACKAGES += libomx_av_core_alt \
    libOmxCore \
    libOmxVideo \
    libOmxAudio \
    libHwAudio_dcvdec \
    libHwAudio_dtshd  \
    libdra \
    libthreadworker_alt \
    libdatachunkqueue_alt \
    libOmxBase \
    libomx_framework_alt \
    libomx_worker_peer_alt \
    libfpscalculator_alt \
    libomx_clock_utils_alt \
    libomx_timed_task_queue_alt \
    libstagefrighthw \
    libsecmem \
    secmem \
    2c1a33c0-44cc-11e5-bc3b0002a5d5c51b

# Dm-verity
ifeq ($(BUILD_WITH_DM_VERITY), true)
PRODUCT_SYSTEM_VERITY_PARTITION = /dev/block/system
PRODUCT_VENDOR_VERITY_PARTITION = /dev/block/vendor
# Provides dependencies necessary for verified boot
PRODUCT_SUPPORTS_BOOT_SIGNER := true
PRODUCT_SUPPORTS_VERITY := true
PRODUCT_SUPPORTS_VERITY_FEC := true
# The dev key is used to sign boot and recovery images, and the verity
# metadata table. Actual product deliverables will be re-signed by hand.
# We expect this file to exist with the suffixes ".x509.pem" and ".pk8".
PRODUCT_VERITY_SIGNING_KEY := device/hardkernel/common/security/verity
ifneq ($(TARGET_USE_SECURITY_DM_VERITY_MODE_WITH_TOOL),true)
PRODUCT_PACKAGES += \
        verity_key.amlogic
endif
endif

#########################################################################
#
#                                                App optimization
#
#########################################################################
#ifeq ($(BUILD_WITH_APP_OPTIMIZATION),true)

PRODUCT_COPY_FILES += \
    device/hardkernel/common/optimization/liboptimization_32.so:$(TARGET_COPY_OUT_VENDOR)/lib/liboptimization.so \
    device/hardkernel/common/optimization/config:$(TARGET_COPY_OUT_VENDOR)/package_config/config

PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.app.optimization=true

ifeq ($(ANDROID_BUILD_TYPE), 64)
PRODUCT_COPY_FILES += \
    device/hardkernel/common/optimization/liboptimization_64.so:$(TARGET_COPY_OUT_VENDOR)/lib64/liboptimization.so
endif
#endif

#########################################################################
#
#                                     hardware interfaces
#
#########################################################################
PRODUCT_PACKAGES += \
     android.hardware.soundtrigger@2.0-impl \
     android.hardware.wifi@1.0-service \
     android.hardware.usb@1.0-service

#workround because android.hardware.wifi@1.0-service has not permission to insmod ko
PRODUCT_COPY_FILES += \
        hardware/hardkernel/wifi/android.hardware.wifi@1.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.wifi@1.0-service.rc

PRODUCT_COPY_FILES += \
    device/hardkernel/common/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml

#Audio HAL
PRODUCT_PACKAGES += \
     android.hardware.audio@4.0-impl:32 \
     android.hardware.audio.effect@4.0-impl:32 \
     android.hardware.soundtrigger@2.1-impl:32 \
     android.hardware.audio@2.0-service
#Camera HAL
#ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_PACKAGES += \
     android.hardware.camera.provider@2.4-impl \
     android.hardware.camera.provider@2.4-service
#endif

#Power HAL
PRODUCT_PACKAGES += \
     android.hardware.power@1.0-impl \
     android.hardware.power@1.0-service

#Memtack HAL
PRODUCT_PACKAGES += \
     android.hardware.memtrack@1.0-impl \
     android.hardware.memtrack@1.0-service

# Gralloc HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service

# HW Composer
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.2-impl \
    android.hardware.graphics.composer@2.2-service

# dumpstate binderized
PRODUCT_PACKAGES += \
    android.hardware.dumpstate@1.0-service.droidlogic


# Keymaster HAL
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# new gatekeeper HAL
PRODUCT_PACKAGES += \
    gatekeeper.$(TARGET_PRODUCT) \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

#DRM HAL
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl:32 \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.1-service.widevine \
    android.hardware.drm@1.1-service.clearkey \
    move_widevine_data.sh

# HDMITX CEC HAL
PRODUCT_PACKAGES += \
    android.hardware.tv.cec@1.0-impl \
    android.hardware.tv.cec@1.0-service \
    hdmicecd \
    rc_server \
    libhdmicec \
    libhdmicec_jni \
    vendor.amlogic.hardware.hdmicec@1.0_vendor \
    hdmi_cec.$(TARGET_PRODUCT)

#light hal
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service

#thermal hal
PRODUCT_PACKAGES += \
    android.hardware.thermal@1.0-impl \
    android.hardware.thermal@1.0-service

PRODUCT_PACKAGES += \
    android.hardware.cas@1.0-service

# DroidVold
PRODUCT_PACKAGES += \
    vendor.amlogic.hardware.droidvold@1.0 \
    vendor.amlogic.hardware.droidvold@1.0_vendor \
    vendor.amlogic.hardware.droidvold-V1.0-java

ifeq ($(TARGET_BUILD_GOOGLE_ATV), true)
PRODUCT_IS_ATV := true
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/tutorial-library-google.zip:system/media/tutorial-library-google.zip
PRODUCT_PACKAGES += \
    DroidOverlay \
    BlueOverlay
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.disable_triple_buffer=1

# ro.product.first_api_level indicates the first api level the device has commercially launched on.
#PRODUCT_PROPERTY_OVERRIDES += \
#    ro.product.first_api_level=26

PRODUCT_PACKAGES += \
    vndk-sp

# VNDK version is specified
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.vndk.version=28.0.0

# Override heap growth limit due to high display density on device
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapgrowthlimit=256m


PRODUCT_PROPERTY_OVERRIDES += \
    ro.boot.fake_battery=42

#set audioflinger heapsize,for lowramdevice
#the default af heap size is 1M,it is not enough
PRODUCT_PROPERTY_OVERRIDES += \
    ro.af.client_heap_size_kbyte=1536

#fix android.permission2.cts.ProtectedBroadcastsTest
#PRODUCT_PACKAGES += \
#    TeleService

#add copy alarm file to product
#PRODUCT_COPY_FILES += \
#        frameworks\base\data\sounds\Alarm_Beep_01.ogg:product/media/audio/alarms/Alarm_Beep_01.ogg

#GPS
PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0 \
    android.hardware.gnss@1.0-impl \
    android.hardware.gnss@1.0-service

PRODUCT_PACKAGES += \
    Things \
    odroidThings \
    com.google.android.things.xml \
    vendor.hardkernel.hardware.odroidthings@1.0-service

# vednor/hk/
# hardware/hk/odroidThings, HAL

PRODUCT_PACKAGES += \
    libwiringPi \
    libwiringPiDev \
    gpio

# CAN-BUS
PRODUCT_PACKAGES += \
    libcan \
    candump \
    canplayer \
    cansend \
    cangen \
    cansniffer \
    canbusload

ifneq ($(TARGET_BUILD_GOOGLE_ATV), true)
# Superuser
PRODUCT_PACKAGES += \
    su
endif

# SQLite3
PRODUCT_PACKAGES += \
    sqlite3 \

# NTFS-3G
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

PRODUCT_COPY_FILES += \
    hardware/interfaces/gnss/1.0/default/android.hardware.gnss@1.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.gnss@1.0-service.rc

#public library txt
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

# Input device calibration files
PRODUCT_COPY_FILES += \
    device/hardkernel/common/bin/odroid-ts.idc:vendor/usr/idc/odroid-ts.idc \
    device/hardkernel/common/bin/odroid-ts.idc:vendor/usr/idc/usbio-keypad.idc \
    device/hardkernel/common/bin/odroid-ts.kl:vendor/usr/keylayout/odroid-ts.kl \
    device/hardkernel/common/bin/odroid-ts.kcm:vendor/usr/keylayout/odroid-ts.kcm \
    device/hardkernel/common/bin/odroid-keypad.kl:vendor/usr/keylayout/odroid-keypad.kl \
    device/hardkernel/common/bin/odroid-keypad.kcm:vendor/usr/keychars/odroid-keypad.kcm

# for USB HID MULTITOUCH
PRODUCT_COPY_FILES += \
    device/hardkernel/common/bin/Vendor_0eef_Product_0005.idc:vendor/usr/idc/Vendor_0eef_Product_0005.idc \
    device/hardkernel/common/bin/Vendor_03fc_Product_05d8.idc:vendor/usr/idc/Vendor_03fc_Product_05d8.idc \
    device/hardkernel/common/bin/Vendor_1870_Product_0119.idc:vendor/usr/idc/Vendor_1870_Product_0119.idc \
    device/hardkernel/common/bin/Vendor_1870_Product_0100.idc:vendor/usr/idc/Vendor_1870_Product_0100.idc \
    device/hardkernel/common/bin/Vendor_2808_Product_81c9.idc:vendor/usr/idc/Vendor_2808_Product_81c9.idc \
    device/hardkernel/common/bin/Vendor_16b4_Product_0704.idc:vendor/usr/idc/Vendor_16b4_Product_0704.idc \
    device/hardkernel/common/bin/Vendor_16b4_Product_0705.idc:vendor/usr/idc/Vendor_16b4_Product_0705.idc \
    device/hardkernel/common/bin/Vendor_04d8_Product_0c03.idc:vendor/usr/idc/Vendor_04d8_Product_0c03.idc

# XBox 360 Controller kl keymaps
PRODUCT_COPY_FILES += \
    device/hardkernel/common/bin/Vendor_045e_Product_0291.kl:vendor/usr/keylayout/Vendor_045e_Product_0291.kl \
    device/hardkernel/common/bin/Vendor_045e_Product_0719.kl:vendor/usr/keylayout/Vendor_045e_Product_0719.kl \
    device/hardkernel/common/bin/Vendor_0c45_Product_1109.kl:vendor/usr/keylayout/Vendor_0c45_Product_1109 \
    device/hardkernel/common/bin/Vendor_1b8e_Product_0cec_Version_0001.kl:vendor/usr/keylayout/Vendor_1b8e_Product_0cec_Version_0001 \
    device/hardkernel/common/bin/Vendor_045e_Product_0719.kcm:vendor/usr/keychars/Vendor_045e_Product_0719.kcm

