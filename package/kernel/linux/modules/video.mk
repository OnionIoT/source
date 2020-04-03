#
# Copyright (C) 2009 David Cooper <dave@kupesoft.com>
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

VIDEO_MENU:=Video Support

V4L2_DIR=v4l2-core
V4L2_USB_DIR=usb

#
# Video Display
#

define KernelPackage/backlight
	SUBMENU:=$(VIDEO_MENU)
	TITLE:=Backlight support
	DEPENDS:=@DISPLAY_SUPPORT
	HIDDEN:=1
	KCONFIG:=CONFIG_BACKLIGHT_CLASS_DEVICE \
		CONFIG_BACKLIGHT_LCD_SUPPORT=y \
		CONFIG_LCD_CLASS_DEVICE=n \
		CONFIG_BACKLIGHT_GENERIC=n \
		CONFIG_BACKLIGHT_ADP8860=n \
		CONFIG_BACKLIGHT_ADP8870=n \
		CONFIG_BACKLIGHT_OT200=n \
		CONFIG_BACKLIGHT_PM8941_WLED=n
	FILES:=$(LINUX_DIR)/drivers/video/backlight/backlight.ko
	AUTOLOAD:=$(call AutoProbe,video backlight)
endef

define KernelPackage/backlight/description
	Kernel module for Backlight support.
endef

$(eval $(call KernelPackage,backlight))

define KernelPackage/backlight-pwm
	SUBMENU:=$(VIDEO_MENU)
	TITLE:=PWM Backlight support
	DEPENDS:=+kmod-backlight
	KCONFIG:=CONFIG_BACKLIGHT_PWM
	FILES:=$(LINUX_DIR)/drivers/video/backlight/pwm_bl.ko
	AUTOLOAD:=$(call AutoProbe,video pwm_bl)
endef

define KernelPackage/backlight-pwm/description
	Kernel module for PWM based Backlight support.
endef

$(eval $(call KernelPackage,backlight-pwm))


define KernelPackage/fb
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer support
  DEPENDS:=@DISPLAY_SUPPORT
  KCONFIG:= \
	CONFIG_FB \
	CONFIG_FB_MXS=n \
	CONFIG_FB_SM750=n
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/fb.ko \
	$(LINUX_DIR)/lib/fonts/font.ko
  AUTOLOAD:=$(call AutoLoad,06,fb font)
endef

define KernelPackage/fb/description
 Kernel support for framebuffers
endef

define KernelPackage/fb/x86
  FILES+=$(LINUX_DIR)/arch/x86/video/fbdev.ko
  AUTOLOAD+=$(call AutoLoad,06,fbdev fb)
endef

$(eval $(call KernelPackage,fb))


define KernelPackage/fbcon
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer Console support
  DEPENDS:=+kmod-fb @!LINUX_4_14
  KCONFIG:= \
	CONFIG_FRAMEBUFFER_CONSOLE \
	CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y \
	CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y \
	CONFIG_FONTS=y \
	CONFIG_FONT_8x8=y \
	CONFIG_FONT_8x16=y \
	CONFIG_FONT_6x11=n \
	CONFIG_FONT_7x14=n \
	CONFIG_FONT_PEARL_8x8=n \
	CONFIG_FONT_ACORN_8x8=n \
	CONFIG_FONT_MINI_4x6=n \
	CONFIG_FONT_6x10=n \
	CONFIG_FONT_SUN8x16=n \
	CONFIG_FONT_SUN12x22=n \
	CONFIG_FONT_10x18=n \
	CONFIG_VT=y \
	CONFIG_CONSOLE_TRANSLATIONS=y \
	CONFIG_VT_CONSOLE=y \
	CONFIG_VT_HW_CONSOLE_BINDING=y
  FILES:= \
	$(LINUX_DIR)/drivers/video/console/bitblit.ko \
	$(LINUX_DIR)/drivers/video/console/softcursor.ko \
	$(LINUX_DIR)/drivers/video/console/fbcon.ko \
	$(LINUX_DIR)/drivers/video/console/fbcon_rotate.ko \
	$(LINUX_DIR)/drivers/video/console/fbcon_cw.ko \
	$(LINUX_DIR)/drivers/video/console/fbcon_ud.ko \
	$(LINUX_DIR)/drivers/video/console/fbcon_ccw.ko \
	$(LINUX_DIR)/lib/fonts/font.ko
  AUTOLOAD:=$(call AutoLoad,94,font softcursor tileblit fbcon_cw fbcon_ud fbcon_ccw fbcon_rotate bitblit fbcon)
endef

define KernelPackage/fbcon/description
  Kernel support for framebuffer console
endef

$(eval $(call KernelPackage,fbcon))

define KernelPackage/fb-cfb-fillrect
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software rectangle filling support
  DEPENDS:=+kmod-fb
  KCONFIG:=CONFIG_FB_CFB_FILLRECT
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/cfbfillrect.ko
  AUTOLOAD:=$(call AutoLoad,07,cfbfillrect)
endef

define KernelPackage/fb-cfb-fillrect/description
 Kernel support for software rectangle filling
endef

$(eval $(call KernelPackage,fb-cfb-fillrect))


define KernelPackage/fb-cfb-copyarea
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software copy area support
  DEPENDS:=+kmod-fb
  KCONFIG:=CONFIG_FB_CFB_COPYAREA
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/cfbcopyarea.ko
  AUTOLOAD:=$(call AutoLoad,07,cfbcopyarea)
endef

define KernelPackage/fb-cfb-copyarea/description
 Kernel support for software copy area
endef

$(eval $(call KernelPackage,fb-cfb-copyarea))

define KernelPackage/fb-cfb-imgblt
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software image blit support
  DEPENDS:=+kmod-fb
  KCONFIG:=CONFIG_FB_CFB_IMAGEBLIT
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/cfbimgblt.ko
  AUTOLOAD:=$(call AutoLoad,07,cfbimgblt)
endef

define KernelPackage/fb-cfb-imgblt/description
 Kernel support for software image blitting
endef

$(eval $(call KernelPackage,fb-cfb-imgblt))


define KernelPackage/fb-sys-fops
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software sys ops support
  DEPENDS:=+kmod-fb
  KCONFIG:=CONFIG_FB_SYS_FOPS
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/fb_sys_fops.ko
  AUTOLOAD:=$(call AutoLoad,07,fbsysfops)
endef

define KernelPackage/fb-sys-fops/description
 Kernel support for framebuffer sys ops
endef

$(eval $(call KernelPackage,fb-sys-fops))


define KernelPackage/fbtft-support
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer TFT and OLED support (p44/luz)
  DEPENDS:=\
  +kmod-fb \
  +kmod-fb-cfb-imgblt \
  +kmod-fb-cfb-copyarea \
  +kmod-fb-cfb-fillrect \
  +kmod-fb-sys-fops
  KCONFIG:= \
  CONFIG_FB \
  CONFIG_FB_SYS_FILLRECT \
  CONFIG_FB_SYS_COPYAREA \
  CONFIG_FB_SYS_IMAGEBLIT \
  CONFIG_FB_FLEX \
  CONFIG_FB_MODE_HELPERS=y \
  CONFIG_FB_BACKLIGHT=y \
  CONFIG_FB_TILEBLITTING=y \
  CONFIG_FB_BOTH_ENDIAN=y \
  CONFIG_FB_CMDLINE=y \
  CONFIG_FB_DEFERRED_IO=y \
  CONFIG_FB_FOREIGN_ENDIAN=y \
  CONFIG_FB_PROVIDE_GET_FB_UNMAPPED_AREA=n \
  CONFIG_BACKLIGHT_LCD_SUPPORT=y \
  CONFIG_LCD_CLASS_DEVICE=y \
  CONFIG_LCD_PLATFORM=y \
  CONFIG_BACKLIGHT_CLASS_DEVICE=y \
  CONFIG_STAGING_BOARD=y \
  CONFIG_FB_TFT \
  CONFIG_FB_TFT_FBTFT_DEVICE=y
  FILES:= \
  $(LINUX_DIR)/drivers/video/fbdev/core/syscopyarea.ko \
  $(LINUX_DIR)/drivers/video/fbdev/core/sysfillrect.ko \
  $(LINUX_DIR)/drivers/video/fbdev/core/sysimgblt.ko \
  $(LINUX_DIR)/drivers/staging/fbtft/fbtft.ko \
  $(LINUX_DIR)/drivers/staging/fbtft/flexfb.ko \
  $(LINUX_DIR)/drivers/staging/fbtft/fbtft_device.ko
  AUTOLOAD:=$(call AutoLoad,07,sysfillrect syscopyarea sysimgblt fb_sys_fops fbtft)
endef


define KernelPackage/fbtft-support/description
 Framebuffer TFT and OLED support (p44/luz)
 These are drivers from staging!
endef

$(eval $(call KernelPackage,fbtft-support))


define AddDepends/fbtft-support
  SUBMENU:=$(VIDEO_MENU)
  DEPENDS+=kmod-fbtft-support $(1)
endef


define KernelPackage/fbtft-ssd1306
  TITLE:=SSD1306 monochrome OLED driver
  KCONFIG:=CONFIG_FB_TFT_SSD1306
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ssd1306.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-ssd1306/description
 Kernel module for supporting Solomon systech SSD1306 based OLED/PLED displays
endef

$(eval $(call KernelPackage,fbtft-ssd1306))


define KernelPackage/fbtft-ssd1331
  TITLE:=SSD1331 driver
  KCONFIG:=CONFIG_FB_TFT_SSD1331
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ssd1331.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-ssd1331/description
 Kernel module for supporting SSD1331 displays
endef

$(eval $(call KernelPackage,fbtft-ssd1331))


define KernelPackage/fbtft-ili9340
  TITLE:=ILI9340 driver
  KCONFIG:=CONFIG_FB_TFT_ILI9340
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ili9340.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-ili9340/description
 Kernel module for supporting ILI9340 displays
endef

$(eval $(call KernelPackage,fbtft-ili9340))


define KernelPackage/fbtft-ili9341
  TITLE:=ILI9341 driver
  KCONFIG:=CONFIG_FB_TFT_ILI9341
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ili9341.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-ili9341/description
 Kernel module for supporting ILI9341 displays
endef

$(eval $(call KernelPackage,fbtft-ili9341))


define KernelPackage/fbtft-ssd1289
  TITLE:=SSD1289 driver
  KCONFIG:=CONFIG_FB_TFT_SSD1289
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ssd1289.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-ssd1289/description
 Kernel module for supporting SSD1289 displays
endef

$(eval $(call KernelPackage,fbtft-ssd1289))


define KernelPackage/fbtft-ssd1305
  TITLE:=SSD1305 driver
  KCONFIG:=CONFIG_FB_TFT_SSD1305
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ssd1305.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-ssd1305/description
 Kernel module for supporting SSD1305 displays
endef

$(eval $(call KernelPackage,fbtft-ssd1305))


define KernelPackage/fbtft-ssd1325
  TITLE:=SSD1325 driver
  KCONFIG:=CONFIG_FB_TFT_SSD1325
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ssd1325.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-ssd1325/description
 Kernel module for supporting SSD1325 displays
endef

$(eval $(call KernelPackage,fbtft-ssd1325))


define KernelPackage/fbtft-ssd1351
  TITLE:=SSD1351 driver
  KCONFIG:=CONFIG_FB_TFT_SSD1351
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ssd1351.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-ssd1351/description
 Kernel module for supporting SSD1351 displays
endef

$(eval $(call KernelPackage,fbtft-ssd1351))


define KernelPackage/fbtft-ili9163
  TITLE:=ILI9163 driver
  KCONFIG:=CONFIG_FB_TFT_ILI9163
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ili9163.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-ili9163/description
 Kernel module for supporting ILI9163 displays
endef

$(eval $(call KernelPackage,fbtft-ili9163))


define KernelPackage/fbtft-ili9320
  TITLE:=ILI9320 driver
  KCONFIG:=CONFIG_FB_TFT_ILI9320
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ili9320.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-ili9320/description
 Kernel module for supporting ILI9320 displays
endef

$(eval $(call KernelPackage,fbtft-ili9320))


define KernelPackage/fbtft-ili9325
  TITLE:=ILI9325 driver
  KCONFIG:=CONFIG_FB_TFT_ILI9325
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ili9325.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-ili9325/description
 Kernel module for supporting ILI9325 displays
endef

$(eval $(call KernelPackage,fbtft-ili9325))


define KernelPackage/fbtft-ili9481
  TITLE:=ILI9481 driver
  KCONFIG:=CONFIG_FB_TFT_ILI9481
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ili9481.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-ili9481/description
 Kernel module for supporting ILI9481 displays
endef

$(eval $(call KernelPackage,fbtft-ili9481))


define KernelPackage/fbtft-ili9486
  TITLE:=ILI9486 driver
  KCONFIG:=CONFIG_FB_TFT_ILI9486
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ili9486.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-ili9486/description
 Kernel module for supporting ILI9486 displays
endef

$(eval $(call KernelPackage,fbtft-ili9486))


define KernelPackage/fbtft-agm1264k_fl
  TITLE:=AGM1264K_FL driver
  KCONFIG:=CONFIG_FB_TFT_AGM1264K_FL
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_agm1264k_fl.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-agm1264k_fl/description
 Kernel module for supporting AGM1264K_FL displays
endef

$(eval $(call KernelPackage,fbtft-agm1264k_fl))


define KernelPackage/fbtft-bd663474
  TITLE:=BD663474 driver
  KCONFIG:=CONFIG_FB_TFT_BD663474
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_bd663474.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-bd663474/description
 Kernel module for supporting BD663474 displays
endef

$(eval $(call KernelPackage,fbtft-bd663474))


define KernelPackage/fbtft-hx8340bn
  TITLE:=HX8340BN driver
  KCONFIG:=CONFIG_FB_TFT_HX8340BN
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_hx8340bn.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-hx8340bn/description
 Kernel module for supporting HX8340BN displays
endef

$(eval $(call KernelPackage,fbtft-hx8340bn))


define KernelPackage/fbtft-hx8347d
  TITLE:=HX8347D driver
  KCONFIG:=CONFIG_FB_TFT_HX8347D
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_hx8347d.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-hx8347d/description
 Kernel module for supporting HX8347D displays
endef

$(eval $(call KernelPackage,fbtft-hx8347d))


define KernelPackage/fbtft-hx8353d
  TITLE:=HX8353D driver
  KCONFIG:=CONFIG_FB_TFT_HX8353D
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_hx8353d.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-hx8353d/description
 Kernel module for supporting HX8353D displays
endef

$(eval $(call KernelPackage,fbtft-hx8353d))


define KernelPackage/fbtft-hx8357d
  TITLE:=HX8357D driver
  KCONFIG:=CONFIG_FB_TFT_HX8357D
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_hx8357d.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-hx8357d/description
 Kernel module for supporting HX8357D displays
endef

$(eval $(call KernelPackage,fbtft-hx8357d))


define KernelPackage/fbtft-pcd8544
  TITLE:=PCD8544 driver
  KCONFIG:=CONFIG_FB_TFT_PCD8544
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_pcd8544.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-pcd8544/description
 Kernel module for supporting PCD8544 displays
endef

$(eval $(call KernelPackage,fbtft-pcd8544))


define KernelPackage/fbtft-ra8875
  TITLE:=RA8875 driver
  KCONFIG:=CONFIG_FB_TFT_RA8875
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ra8875.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-ra8875/description
 Kernel module for supporting RA8875 displays
endef

$(eval $(call KernelPackage,fbtft-ra8875))


define KernelPackage/fbtft-s6d02a1
  TITLE:=S6D02A1 driver
  KCONFIG:=CONFIG_FB_TFT_S6D02A1
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_s6d02a1.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-s6d02a1/description
 Kernel module for supporting S6D02A1 displays
endef

$(eval $(call KernelPackage,fbtft-s6d02a1))


define KernelPackage/fbtft-s6d1121
  TITLE:=S6D1121 driver
  KCONFIG:=CONFIG_FB_TFT_S6D1121
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_s6d1121.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-s6d1121/description
 Kernel module for supporting S6D1121 displays
endef

$(eval $(call KernelPackage,fbtft-s6d1121))


define KernelPackage/fbtft-sh1106
  TITLE:=SH1106 driver
  KCONFIG:=CONFIG_FB_TFT_SH1106
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_sh1106.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-sh1106/description
 Kernel module for supporting SH1106 displays
endef

$(eval $(call KernelPackage,fbtft-sh1106))


define KernelPackage/fbtft-st7735r
  TITLE:=ST7735R driver
  KCONFIG:=CONFIG_FB_TFT_ST7735R
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_st7735r.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-st7735r/description
 Kernel module for supporting ST7735R displays
endef

$(eval $(call KernelPackage,fbtft-st7735r))


define KernelPackage/fbtft-st7789v
  TITLE:=ST7789V driver
  KCONFIG:=CONFIG_FB_TFT_ST7789V
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_st7789v.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-st7789v/description
 Kernel module for supporting ST7789V displays
endef

$(eval $(call KernelPackage,fbtft-st7789v))


define KernelPackage/fbtft-tinylcd
  TITLE:=TINYLCD driver
  KCONFIG:=CONFIG_FB_TFT_TINYLCD
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_tinylcd.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-tinylcd/description
 Kernel module for supporting TINYLCD displays
endef

$(eval $(call KernelPackage,fbtft-tinylcd))


define KernelPackage/fbtft-tls8204
  TITLE:=TLS8204 driver
  KCONFIG:=CONFIG_FB_TFT_TLS8204
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_tls8204.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-tls8204/description
 Kernel module for supporting TLS8204 displays
endef

$(eval $(call KernelPackage,fbtft-tls8204))


define KernelPackage/fbtft-uc1611
  TITLE:=UC1611 driver
  KCONFIG:=CONFIG_FB_TFT_UC1611
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_uc1611.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-uc1611/description
 Kernel module for supporting UC1611 displays
endef

$(eval $(call KernelPackage,fbtft-uc1611))


define KernelPackage/fbtft-uc1701
  TITLE:=UC1701 driver
  KCONFIG:=CONFIG_FB_TFT_UC1701
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_uc1701.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-uc1701/description
 Kernel module for supporting UC1701 displays
endef

$(eval $(call KernelPackage,fbtft-uc1701))


define KernelPackage/fbtft-upd161704
  TITLE:=UPD161704 driver
  KCONFIG:=CONFIG_FB_TFT_UPD161704
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_upd161704.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-upd161704/description
 Kernel module for supporting UPD161704 displays
endef

$(eval $(call KernelPackage,fbtft-upd161704))


define KernelPackage/fbtft-watterott
  TITLE:=WATTEROTT driver
  KCONFIG:=CONFIG_FB_TFT_WATTEROTT
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_watterott.ko
  $(call AddDepends/fbtft-support)
endef

define KernelPackage/fbtft-watterott/description
 Kernel module for supporting WATTEROTT displays
endef

$(eval $(call KernelPackage,fbtft-watterott))




define KernelPackage/drm
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Direct Rendering Manager (DRM) support
  HIDDEN:=1
  DEPENDS:=+kmod-dma-buf +kmod-i2c-core
  KCONFIG:=CONFIG_DRM
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/drm.ko
  AUTOLOAD:=$(call AutoLoad,05,drm)
endef

define KernelPackage/drm/description
  Direct Rendering Manager (DRM) core support
endef

$(eval $(call KernelPackage,drm))

define KernelPackage/drm-imx
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Freescale i.MX DRM support
  DEPENDS:=@TARGET_imx6 +kmod-drm +kmod-fb +kmod-fb-cfb-copyarea +kmod-fb-cfb-imgblt +kmod-fb-cfb-fillrect +kmod-fb-sys-fops
  KCONFIG:=CONFIG_DRM_IMX \
	CONFIG_DRM_FBDEV_EMULATION=y \
	CONFIG_DRM_FBDEV_OVERALLOC=100 \
	CONFIG_IMX_IPUV3_CORE \
	CONFIG_RESET_CONTROLLER=y \
	CONFIG_DRM_IMX_IPUV3 \
	CONFIG_IMX_IPUV3 \
	CONFIG_DRM_KMS_HELPER \
	CONFIG_FB_SYS_FILLRECT \
	CONFIG_FB_SYS_COPYAREA \
	CONFIG_FB_SYS_IMAGEBLIT \
	CONFIG_DRM_KMS_FB_HELPER=y \
	CONFIG_DRM_GEM_CMA_HELPER=y \
	CONFIG_DRM_KMS_CMA_HELPER=y \
	CONFIG_DRM_IMX_FB_HELPER \
	CONFIG_DRM_IMX_PARALLEL_DISPLAY=n \
	CONFIG_DRM_IMX_TVE=n \
	CONFIG_DRM_IMX_LDB=n \
	CONFIG_DRM_IMX_HDMI=n
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/imx/imxdrm.ko \
	$(LINUX_DIR)/drivers/gpu/ipu-v3/imx-ipu-v3.ko \
	$(LINUX_DIR)/drivers/video/fbdev/core/syscopyarea.ko \
	$(LINUX_DIR)/drivers/video/fbdev/core/sysfillrect.ko \
	$(LINUX_DIR)/drivers/video/fbdev/core/sysimgblt.ko \
	$(LINUX_DIR)/drivers/gpu/drm/drm_kms_helper.ko
  AUTOLOAD:=$(call AutoLoad,05,imxdrm imx-ipu-v3 imx-ipuv3-crtc)
endef

define KernelPackage/drm-imx/description
  Direct Rendering Manager (DRM) support for Freescale i.MX
endef

$(eval $(call KernelPackage,drm-imx))

define KernelPackage/drm-imx-hdmi
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Freescale i.MX HDMI DRM support
  DEPENDS:=+kmod-sound-core kmod-drm-imx
  KCONFIG:=CONFIG_DRM_IMX_HDMI \
	CONFIG_DRM_DW_HDMI_AHB_AUDIO \
	CONFIG_DRM_DW_HDMI_I2S_AUDIO
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/bridge/synopsys/dw-hdmi.ko \
	$(LINUX_DIR)/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.ko \
	$(LINUX_DIR)/drivers/gpu/drm/imx/dw_hdmi-imx.ko
  AUTOLOAD:=$(call AutoLoad,05,dw-hdmi dw-hdmi-ahb-audio.ko dw_hdmi-imx)
endef

define KernelPackage/drm-imx-hdmi/description
  Direct Rendering Manager (DRM) support for Freescale i.MX HDMI
endef

$(eval $(call KernelPackage,drm-imx-hdmi))

define KernelPackage/drm-imx-ldb
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Freescale i.MX LVDS DRM support
  DEPENDS:=+kmod-backlight kmod-drm-imx
  KCONFIG:=CONFIG_DRM_IMX_LDB \
	CONFIG_DRM_PANEL_SIMPLE \
	CONFIG_DRM_PANEL=y \
	CONFIG_DRM_PANEL_SAMSUNG_LD9040=n \
	CONFIG_DRM_PANEL_SAMSUNG_S6E8AA0=n \
	CONFIG_DRM_PANEL_LG_LG4573=n \
	CONFIG_DRM_PANEL_LD9040=n \
	CONFIG_DRM_PANEL_LVDS=n \
	CONFIG_DRM_PANEL_S6E8AA0=n \
	CONFIG_DRM_PANEL_SITRONIX_ST7789V=n
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/imx/imx-ldb.ko \
	$(LINUX_DIR)/drivers/gpu/drm/panel/panel-simple.ko
  AUTOLOAD:=$(call AutoLoad,05,imx-ldb)
endef

define KernelPackage/drm-imx-ldb/description
  Direct Rendering Manager (DRM) support for Freescale i.MX LVDS
endef

$(eval $(call KernelPackage,drm-imx-ldb))


#
# Video Capture
#

define KernelPackage/video-core
  SUBMENU:=$(VIDEO_MENU)
  TITLE=Video4Linux support
  DEPENDS:=@PCI_SUPPORT||USB_SUPPORT +PACKAGE_kmod-i2c-core:kmod-i2c-core
  KCONFIG:= \
	CONFIG_MEDIA_SUPPORT \
	CONFIG_MEDIA_CAMERA_SUPPORT=y \
	CONFIG_VIDEO_DEV \
	CONFIG_VIDEO_V4L1=y \
	CONFIG_VIDEO_ALLOW_V4L1=y \
	CONFIG_VIDEO_CAPTURE_DRIVERS=y \
	CONFIG_V4L_USB_DRIVERS=y \
	CONFIG_V4L_PCI_DRIVERS=y \
	CONFIG_V4L_PLATFORM_DRIVERS=y \
	CONFIG_V4L_ISA_PARPORT_DRIVERS=y
  FILES:= \
	$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/v4l2-common.ko \
	$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/videodev.ko
  AUTOLOAD:=$(call AutoLoad,60, videodev v4l2-common)
endef

define KernelPackage/video-core/description
 Kernel modules for Video4Linux support
endef

$(eval $(call KernelPackage,video-core))


define AddDepends/video
  SUBMENU:=$(VIDEO_MENU)
  DEPENDS+=kmod-video-core $(1)
endef

define AddDepends/camera
$(AddDepends/video)
  KCONFIG+=CONFIG_MEDIA_USB_SUPPORT=y \
	 CONFIG_MEDIA_CAMERA_SUPPORT=y
endef


define KernelPackage/video-videobuf2
  TITLE:=videobuf2 lib
  DEPENDS:=+kmod-dma-buf
  KCONFIG:= \
	CONFIG_VIDEOBUF2_CORE \
	CONFIG_VIDEOBUF2_MEMOPS \
	CONFIG_VIDEOBUF2_VMALLOC
  FILES:= \
	$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/videobuf2-core.ko \
	$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/videobuf2-v4l2.ko@ge4.4 \
	$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/videobuf2-memops.ko \
	$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/videobuf2-vmalloc.ko
  AUTOLOAD:=$(call AutoLoad,65,videobuf2-core videobuf-v4l2@ge4.4 videobuf2-memops videobuf2-vmalloc)
  $(call AddDepends/video)
endef

define KernelPackage/video-videobuf2/description
 Kernel modules that implements three basic types of media buffers.
endef

$(eval $(call KernelPackage,video-videobuf2))


define KernelPackage/video-cpia2
  TITLE:=CPIA2 video driver
  DEPENDS:=@USB_SUPPORT +kmod-usb-core
  KCONFIG:=CONFIG_VIDEO_CPIA2
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/cpia2/cpia2.ko
  AUTOLOAD:=$(call AutoProbe,cpia2)
  $(call AddDepends/camera)
endef

define KernelPackage/video-cpia2/description
 Kernel modules for supporting CPIA2 USB based cameras
endef

$(eval $(call KernelPackage,video-cpia2))


define KernelPackage/video-pwc
  TITLE:=Philips USB webcam support
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-video-videobuf2
  KCONFIG:= \
	CONFIG_USB_PWC \
	CONFIG_USB_PWC_DEBUG=n
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/pwc/pwc.ko
  AUTOLOAD:=$(call AutoProbe,pwc)
  $(call AddDepends/camera)
endef

define KernelPackage/video-pwc/description
 Kernel modules for supporting Philips USB based cameras
endef

$(eval $(call KernelPackage,video-pwc))


define KernelPackage/video-uvc
  TITLE:=USB Video Class (UVC) support
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-video-videobuf2 +kmod-input-core
  KCONFIG:= CONFIG_USB_VIDEO_CLASS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/uvc/uvcvideo.ko
  AUTOLOAD:=$(call AutoProbe,uvcvideo)
  $(call AddDepends/camera)
endef

define KernelPackage/video-uvc/description
 Kernel modules for supporting USB Video Class (UVC) devices
endef

$(eval $(call KernelPackage,video-uvc))


define KernelPackage/video-gspca-core
  MENU:=1
  TITLE:=GSPCA webcam core support framework
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-input-core
  KCONFIG:=CONFIG_USB_GSPCA
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_main.ko
  AUTOLOAD:=$(call AutoProbe,gspca_main)
  $(call AddDepends/camera)
endef

define KernelPackage/video-gspca-core/description
 Kernel modules for supporting GSPCA based webcam devices. Note this is just
 the core of the driver, please select a submodule that supports your webcam.
endef

$(eval $(call KernelPackage,video-gspca-core))


define AddDepends/camera-gspca
  SUBMENU:=$(VIDEO_MENU)
  DEPENDS+=kmod-video-gspca-core $(1)
endef


define KernelPackage/video-gspca-conex
  TITLE:=conex webcam support
  KCONFIG:=CONFIG_USB_GSPCA_CONEX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_conex.ko
  AUTOLOAD:=$(call AutoProbe,gspca_conex)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-conex/description
 The Conexant Camera Driver (conex) kernel module
endef

$(eval $(call KernelPackage,video-gspca-conex))


define KernelPackage/video-gspca-etoms
  TITLE:=etoms webcam support
  KCONFIG:=CONFIG_USB_GSPCA_ETOMS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_etoms.ko
  AUTOLOAD:=$(call AutoProbe,gspca_etoms)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-etoms/description
 The Etoms USB Camera Driver (etoms) kernel module
endef

$(eval $(call KernelPackage,video-gspca-etoms))


define KernelPackage/video-gspca-finepix
  TITLE:=finepix webcam support
  KCONFIG:=CONFIG_USB_GSPCA_FINEPIX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_finepix.ko
  AUTOLOAD:=$(call AutoProbe,gspca_finepix)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-finepix/description
 The Fujifilm FinePix USB V4L2 driver (finepix) kernel module
endef

$(eval $(call KernelPackage,video-gspca-finepix))


define KernelPackage/video-gspca-mars
  TITLE:=mars webcam support
  KCONFIG:=CONFIG_USB_GSPCA_MARS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_mars.ko
  AUTOLOAD:=$(call AutoProbe,gspca_mars)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-mars/description
 The Mars USB Camera Driver (mars) kernel module
endef

$(eval $(call KernelPackage,video-gspca-mars))


define KernelPackage/video-gspca-mr97310a
  TITLE:=mr97310a webcam support
  KCONFIG:=CONFIG_USB_GSPCA_MR97310A
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_mr97310a.ko
  AUTOLOAD:=$(call AutoProbe,gspca_mr97310a)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-mr97310a/description
 The Mars-Semi MR97310A USB Camera Driver (mr97310a) kernel module
endef

$(eval $(call KernelPackage,video-gspca-mr97310a))


define KernelPackage/video-gspca-ov519
  TITLE:=ov519 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV519
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_ov519.ko
  AUTOLOAD:=$(call AutoProbe,gspca_ov519)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov519/description
 The OV519 USB Camera Driver (ov519) kernel module
endef

$(eval $(call KernelPackage,video-gspca-ov519))


define KernelPackage/video-gspca-ov534
  TITLE:=ov534 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV534
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_ov534.ko
  AUTOLOAD:=$(call AutoProbe,gspca_ov534)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov534/description
 The OV534 USB Camera Driver (ov534) kernel module
endef

$(eval $(call KernelPackage,video-gspca-ov534))


define KernelPackage/video-gspca-ov534-9
  TITLE:=ov534-9 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV534_9
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_ov534_9.ko
  AUTOLOAD:=$(call AutoProbe,gspca_ov534_9)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov534-9/description
 The OV534-9 USB Camera Driver (ov534_9) kernel module
endef

$(eval $(call KernelPackage,video-gspca-ov534-9))


define KernelPackage/video-gspca-pac207
  TITLE:=pac207 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_PAC207
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_pac207.ko
  AUTOLOAD:=$(call AutoProbe,gspca_pac207)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-pac207/description
 The Pixart PAC207 USB Camera Driver (pac207) kernel module
endef

$(eval $(call KernelPackage,video-gspca-pac207))


define KernelPackage/video-gspca-pac7311
  TITLE:=pac7311 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_PAC7311
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_pac7311.ko
  AUTOLOAD:=$(call AutoProbe,gspca_pac7311)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-pac7311/description
 The Pixart PAC7311 USB Camera Driver (pac7311) kernel module
endef

$(eval $(call KernelPackage,video-gspca-pac7311))


define KernelPackage/video-gspca-se401
  TITLE:=se401 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SE401
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_se401.ko
  AUTOLOAD:=$(call AutoProbe,gspca_se401)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-se401/description
 The SE401 USB Camera Driver kernel module
endef

$(eval $(call KernelPackage,video-gspca-se401))


define KernelPackage/video-gspca-sn9c20x
  TITLE:=sn9c20x webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SN9C20X
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sn9c20x.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sn9c20x)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sn9c20x/description
 The SN9C20X USB Camera Driver (sn9c20x) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sn9c20x))


define KernelPackage/video-gspca-sonixb
  TITLE:=sonixb webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SONIXB
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sonixb.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sonixb)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sonixb/description
 The SONIX Bayer USB Camera Driver (sonixb) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sonixb))


define KernelPackage/video-gspca-sonixj
  TITLE:=sonixj webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SONIXJ
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sonixj.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sonixj)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sonixj/description
 The SONIX JPEG USB Camera Driver (sonixj) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sonixj))


define KernelPackage/video-gspca-spca500
  TITLE:=spca500 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA500
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca500.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca500)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca500/description
 The SPCA500 USB Camera Driver (spca500) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca500))


define KernelPackage/video-gspca-spca501
  TITLE:=spca501 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA501
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca501.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca501)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca501/description
 The SPCA501 USB Camera Driver (spca501) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca501))


define KernelPackage/video-gspca-spca505
  TITLE:=spca505 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA505
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca505.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca505)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca505/description
 The SPCA505 USB Camera Driver (spca505) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca505))


define KernelPackage/video-gspca-spca506
  TITLE:=spca506 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA506
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca506.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca506)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca506/description
 The SPCA506 USB Camera Driver (spca506) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca506))


define KernelPackage/video-gspca-spca508
  TITLE:=spca508 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA508
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca508.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca508)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca508/description
 The SPCA508 USB Camera Driver (spca508) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca508))


define KernelPackage/video-gspca-spca561
  TITLE:=spca561 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA561
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca561.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca561)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca561/description
 The SPCA561 USB Camera Driver (spca561) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca561))


define KernelPackage/video-gspca-sq905
  TITLE:=sq905 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SQ905
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sq905.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sq905)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sq905/description
 The SQ Technologies SQ905 based USB Camera Driver (sq905) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sq905))


define KernelPackage/video-gspca-sq905c
  TITLE:=sq905c webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SQ905C
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sq905c.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sq905c)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sq905c/description
 The SQ Technologies SQ905C based USB Camera Driver (sq905c) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sq905c))


define KernelPackage/video-gspca-stk014
  TITLE:=stk014 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_STK014
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_stk014.ko
  AUTOLOAD:=$(call AutoProbe,gspca_stk014)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-stk014/description
 The Syntek DV4000 (STK014) USB Camera Driver (stk014) kernel module
endef

$(eval $(call KernelPackage,video-gspca-stk014))


define KernelPackage/video-gspca-sunplus
  TITLE:=sunplus webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SUNPLUS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sunplus.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sunplus)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sunplus/description
 The SUNPLUS USB Camera Driver (sunplus) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sunplus))


define KernelPackage/video-gspca-t613
  TITLE:=t613 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_T613
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_t613.ko
  AUTOLOAD:=$(call AutoProbe,gspca_t613)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-t613/description
 The T613 (JPEG Compliance) USB Camera Driver (t613) kernel module
endef

$(eval $(call KernelPackage,video-gspca-t613))


define KernelPackage/video-gspca-tv8532
  TITLE:=tv8532 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_TV8532
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_tv8532.ko
  AUTOLOAD:=$(call AutoProbe,gspca_tv8532)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-tv8532/description
 The TV8532 USB Camera Driver (tv8532) kernel module
endef

$(eval $(call KernelPackage,video-gspca-tv8532))


define KernelPackage/video-gspca-vc032x
  TITLE:=vc032x webcam support
  KCONFIG:=CONFIG_USB_GSPCA_VC032X
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_vc032x.ko
  AUTOLOAD:=$(call AutoProbe,gspca_vc032x)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-vc032x/description
 The VC032X USB Camera Driver (vc032x) kernel module
endef

$(eval $(call KernelPackage,video-gspca-vc032x))


define KernelPackage/video-gspca-zc3xx
  TITLE:=zc3xx webcam support
  KCONFIG:=CONFIG_USB_GSPCA_ZC3XX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_zc3xx.ko
  AUTOLOAD:=$(call AutoProbe,gspca_zc3xx)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-zc3xx/description
 The ZC3XX USB Camera Driver (zc3xx) kernel module
endef

$(eval $(call KernelPackage,video-gspca-zc3xx))


define KernelPackage/video-gspca-m5602
  TITLE:=m5602 webcam support
  KCONFIG:=CONFIG_USB_M5602
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/m5602/gspca_m5602.ko
  AUTOLOAD:=$(call AutoProbe,gspca_m5602)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-m5602/description
 The ALi USB m5602 Camera Driver (m5602) kernel module
endef

$(eval $(call KernelPackage,video-gspca-m5602))


define KernelPackage/video-gspca-stv06xx
  TITLE:=stv06xx webcam support
  KCONFIG:=CONFIG_USB_STV06XX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/stv06xx/gspca_stv06xx.ko
  AUTOLOAD:=$(call AutoProbe,gspca_stv06xx)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-stv06xx/description
 The STV06XX USB Camera Driver (stv06xx) kernel module
endef

$(eval $(call KernelPackage,video-gspca-stv06xx))


define KernelPackage/video-gspca-gl860
  TITLE:=gl860 webcam support
  KCONFIG:=CONFIG_USB_GL860
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gl860/gspca_gl860.ko
  AUTOLOAD:=$(call AutoProbe,gspca_gl860)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-gl800/description
 The GL860 USB Camera Driver (gl860) kernel module
endef

$(eval $(call KernelPackage,video-gspca-gl860))


define KernelPackage/video-gspca-jeilinj
  TITLE:=jeilinj webcam support
  KCONFIG:=CONFIG_USB_GSPCA_JEILINJ
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_jeilinj.ko
  AUTOLOAD:=$(call AutoProbe,gspca_jeilinj)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-jeilinj/description
 The JEILINJ USB Camera Driver (jeilinj) kernel module
endef

$(eval $(call KernelPackage,video-gspca-jeilinj))


define KernelPackage/video-gspca-konica
  TITLE:=konica webcam support
  KCONFIG:=CONFIG_USB_GSPCA_KONICA
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_konica.ko
  AUTOLOAD:=$(call AutoProbe,gspca_konica)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-konica/description
 The Konica USB Camera Driver (konica) kernel module
endef

$(eval $(call KernelPackage,video-gspca-konica))
