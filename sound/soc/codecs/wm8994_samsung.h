/*
 * wm8994_samsung.h  --  WM8994 Soc Audio driver
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#ifndef _WM8994_SAMSUNG_H
#define _WM8994_SAMSUNG_H

#include <sound/soc.h>
#include <linux/mfd/wm8994/wm8994_pdata.h>

extern struct snd_soc_codec_device soc_codec_dev_wm8994;

/* Sources for AIF1/2 SYSCLK - use with set_dai_sysclk() */
#define WM8994_SYSCLK_MCLK1 1
#define WM8994_SYSCLK_MCLK2 2
#define WM8994_SYSCLK_FLL1  3
#define WM8994_SYSCLK_FLL2  4

#define WM8994_FLL1 1
#define WM8994_FLL2 2

/* Added belows codes by Samsung Electronics.*/

#include "wm8994_def.h"

extern struct snd_soc_dai wm8994_dai;

#define WM8994_SYSCLK_MCLK     1
#define WM8994_SYSCLK_FLL      2

#define AUDIO_COMMON_DEBUG	0

/* Codec Output Path BIT */
#define PLAYBACK_MODE	0x01
#define VOICECALL_MODE	(0x01 << 1)
#define RECORDING_MODE	(0x01 << 2)
#define FMRADIO_MODE	(0x01 << 3)

#define COMMON_SET_BIT		(0x01 << 0)
#define PLAYBACK_RCV		(0x01 << 1)
#define PLAYBACK_SPK		(0x01 << 2)
#define PLAYBACK_HP		(0x01 << 3)
#define PLAYBACK_BT		(0x01 << 4)
#define PLAYBACK_SPK_HP		(0x01 << 5)
#define PLAYBACK_RING_SPK	(0x01 << 6)
#define PLAYBACK_RING_HP	(0x01 << 7)
#define PLAYBACK_RING_SPK_HP	(0x01 << 8)

#define VOICECALL_RCV		(0x01 << 1)
#define VOICECALL_SPK		(0x01 << 2)
#define VOICECALL_HP		(0x01 << 3)
#define VOICECALL_BT		(0x01 << 4)

#define RECORDING_MAIN		(0x01 << 1)
#define RECORDING_HP		(0x01 << 2)
#define RECORDING_BT		(0x01 << 3)
#define RECORDING_REC_MAIN	(0x01 << 4)
#define RECORDING_REC_HP	(0x01 << 5)
#define RECORDING_REC_BT	(0x01 << 6)

#define PLAYBACK_GAIN_NUM 41
#define VOICECALL_GAIN_NUM 26
#define RECORDING_GAIN_NUM 16

/*
 * Definitions of enum type
 */
enum audio_path	{
	OFF, RCV, SPK, HP, BT, SPK_HP,
	RING_SPK, RING_HP, RING_SPK_HP
};
enum mic_path		{MAIN, SUB, BT_REC, MIC_OFF};
enum call_state		{DISCONNECT, CONNECT};
enum power_state	{CODEC_OFF, CODEC_ON };
enum mic_state		{MIC_NO_USE, MIC_USE};
enum ringtone_state	{DEACTIVE, ACTIVE};
enum recognition	{REC_OFF, REC_ON};

typedef void (*select_route)(struct snd_soc_codec *);
typedef void (*select_mic_route)(struct snd_soc_codec *);
typedef int (*select_clock_control)(struct snd_soc_codec *, int);


struct wm8994_setup_data {
	int i2c_bus;
	unsigned short i2c_address;
};

struct wm8994_priv {
	struct snd_soc_codec codec;
	int master;
	int sysclk_source;
	unsigned int mclk_rate;
	unsigned int sysclk_rate;
	unsigned int fs;
	unsigned int bclk;
	unsigned int hw_version;
	enum audio_path cur_path;
	enum mic_path rec_path;
	enum call_state call_state;
	enum power_state power_state;
	enum mic_state mic_state;
	enum recognition recognition_active;
	enum ringtone_state ringtone_active;
	select_route *universal_playback_path;
	select_route *universal_voicecall_path;
	select_mic_route *universal_mic_path;
	select_clock_control universal_clock_control;
	bool	play_en_dis;
	bool	rec_en_dis;
	struct wm8994_platform_data *pdata;
	struct clk *codec_clk;
};

struct gain_info_t {
	int mode;
	int reg;
	int mask;
	int gain;
};

#if AUDIO_COMMON_DEBUG
#define DEBUG_LOG(format, ...)\
	printk(KERN_INFO "[ "SUBJECT " (%s,%d) ] " format "\n", \
			__func__, __LINE__, ## __VA_ARGS__);
#else
#define DEBUG_LOG(format, ...)
#endif

#define DEBUG_LOG_ERR(format, ...)\
	printk(KERN_ERR "[ "SUBJECT " (%s,%d) ] " format "\n", \
			__func__, __LINE__, ## __VA_ARGS__);

/* Definitions of function prototype. */
inline unsigned int wm8994_read(struct snd_soc_codec *codec, unsigned int reg);
int wm8994_write(struct snd_soc_codec *codec,
		unsigned int reg, unsigned int value);
int wm8994_configure_clock(struct snd_soc_codec *codec, int en);
void wm8994_disable_playback_path(struct snd_soc_codec *codec,
		enum audio_path path);
void wm8994_disable_rec_path(struct snd_soc_codec *codec);
void wm8994_record_main_mic(struct snd_soc_codec *codec);
void wm8994_record_headset_mic(struct snd_soc_codec *codec);
void wm8994_record_bluetooth(struct snd_soc_codec *codec);
void wm8994_set_playback_receiver(struct snd_soc_codec *codec);
void wm8994_set_playback_headset(struct snd_soc_codec *codec);
void wm8994_set_playback_speaker(struct snd_soc_codec *codec);
void wm8994_set_playback_speaker_headset(struct snd_soc_codec *codec);
void wm8994_set_voicecall_common_setting(struct snd_soc_codec *codec);
void wm8994_set_voicecall_receiver(struct snd_soc_codec *codec);
void wm8994_set_voicecall_headset(struct snd_soc_codec *codec);
void wm8994_set_voicecall_speaker(struct snd_soc_codec *codec);
void wm8994_set_voicecall_bluetooth(struct snd_soc_codec *codec);
int wm8994_set_codec_gain(struct snd_soc_codec *codec, u16 mode, u16 device);
#endif