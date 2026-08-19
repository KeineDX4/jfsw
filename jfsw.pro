# jfsw.pro -- the full JFSW (Shadow Warrior) game for the Symbian Belle (Nokia E7) port.
#
# The ENTIRE jfsw game (all 72 game .c, the 8 jfmact library files, and the
# software-rendering engine without the editor's build.c/config.c) under the
# Symbian GCCE 4.4.1 toolchain, driven by a real Qt 4.7.4 baselayer
# (src/belle_layer.c + src/belle_main.cpp). No SDL, no GTK, no OpenGL. Sound FX come
# from jfaudiolib (multivoc/fx_man) + our DevSound driver (driver_belle.c);
# music is OGG, played through the FX path (FX_PlayLoopedAuto -> MV_PlayLoopedVorbis);
# the MIDI/CD (MUSIC_/CD_) APIs are excluded on Symbian (#ifndef __SYMBIAN32__
# in src/sounds.c / src/setup.c). No network
# (mmulti_null.c).
#
# The game busy-loop runs on a QThread inside the Qt GUI app; see src/belle_layer.c
# and src/belle_main.cpp for the threading model.
#
#   docker run --rm -v <host>/jfsw:/project symbian-belle-buildtools:final /project
#   -> build/jfsw.sis

TEMPLATE = app
TARGET = JFSW
QT += core gui

# --- Game sources (all of jfsw/src except the editor-only files) ---
SOURCES += \
    src/actor.c \
    src/ai.c \
    src/anim.c \
    src/border.c \
    src/break.c \
    src/bunny.c \
    src/cache.c \
    src/cheats.c \
    src/colormap.c \
    src/config.c \
    src/console.c \
    src/coolg.c \
    src/coolie.c \
    src/copysect.c \
    src/demo.c \
    src/draw.c \
    src/eel.c \
    src/game.c \
    src/girlninj.c \
    src/goro.c \
    src/grpscan.c \
    src/hornet.c \
    src/interp.c \
    src/interpsh.c \
    src/inv.c \
    src/jplayer.c \
    src/jsector.c \
    src/jweapon.c \
    src/lava.c \
    src/light.c \
    src/mclip.c \
    src/menus.c \
    src/miscactr.c \
    src/morph.c \
    src/net.c \
    src/ninja.c \
    src/osdcmds.c \
    src/osdfuncs.c \
    src/panel.c \
    src/player.c \
    src/predict.c \
    src/quake.c \
    src/ripper.c \
    src/ripper2.c \
    src/rooms.c \
    src/rotator.c \
    src/rts.c \
    src/save.c \
    src/saveable.c \
    src/scrip2.c \
    src/sector.c \
    src/serp.c \
    src/setup.c \
    src/skel.c \
    src/skull.c \
    src/slidor.c \
    src/sounds.c \
    src/spike.c \
    src/sprite.c \
    src/sumo.c \
    src/swconfig.c \
    src/sync.c \
    src/text.c \
    src/track.c \
    src/vator.c \
    src/vis.c \
    src/wallmove.c \
    src/warp.c \
    src/weapon.c \
    src/zilla.c \
    src/zombie.c

# --- jfmact game library ---
SOURCES += \
    jfmact/animlib.c \
    jfmact/control.c \
    jfmact/file_lib.c \
    jfmact/keyboard.c \
    jfmact/mathutil.c \
    jfmact/mouse.c \
    jfmact/scriplib.c \
    jfmact/util_lib.c

# --- Engine core (software renderer only, no editor build.c/config.c) ---
SOURCES += \
    jfbuild/src/a-c.c \
    jfbuild/src/asmprot.c \
    jfbuild/src/baselayer.c \
    jfbuild/src/cache1d.c \
    jfbuild/src/compat.c \
    jfbuild/src/crc32.c \
    jfbuild/src/defs.c \
    jfbuild/src/engine.c \
    jfbuild/src/kplib.c \
    jfbuild/src/mmulti_null.c \
    jfbuild/src/osd.c \
    jfbuild/src/pragmas.c \
    jfbuild/src/scriptfile.c \
    jfbuild/src/smalltextfont.c \
    jfbuild/src/startwin_stub.c \
    jfbuild/src/talltextfont.c \
    jfbuild/src/textfont.c

# --- Platform glue (Qt baselayer: C platform layer + C++ Qt shell) ---
SOURCES += \
    src/belle_main.cpp \
    src/belle_layer.c

# --- jfaudiolib (sound FX mixer + FX API) + Belle output driver ---
SOURCES += \
    jfaudiolib/src/asssys.c \
    jfaudiolib/src/driver_belle.c \
    jfaudiolib/src/driver_nosound.c \
    jfaudiolib/src/drivers.c \
    jfaudiolib/src/fx_man.c \
    jfaudiolib/src/mix.c \
    jfaudiolib/src/mixst.c \
    jfaudiolib/src/multivoc.c \
    jfaudiolib/src/pitch.c \
    jfaudiolib/src/vorbis.c

# --- Version stamping (mirrors the desktop Makefiles) ---
# On desktop, when git is present each Makefile regenerates ITS OWN
# version-auto.c and compiles it instead of the committed version.c fallback:
# the game defines game_version (startup window, console banner; game.c:3517,
# startwin_game.c:671) via src/version.c / src/version-auto.c; the engine
# defines build_version (BUILD banner, engine.c:5429) via
# jfbuild/src/build-version.c / build-version-auto.c (Makefile:204-210, 274-277;
# jfbuild/Makefile:168-172, 260-263).
#
# The Symbian pipeline stages the project WITHOUT .git, so the version files are
# stamped on the HOST before the container runs (tools/stamp-version.sh,
# .github/workflows/build-belle.yml). These exists() rules pick the stamped file
# when present and fall back to the committed file otherwise -- exactly like the
# desktop Makefiles' git check. Two files, two versions, each in its own tree:
#   src/version.c / src/version-auto.c                 -> game_version
#   jfbuild/src/build-version.c / build-version-auto.c -> build_version
#
# IMPORTANT: unlike desktop (where the game and engine are built by two separate
# Makefiles that never share an object dir), the Symbian qmake -> .mmp -> sbs
# pipeline compiles everything into ONE build dir and names objects after the
# SOURCE BASENAME. Two sources with the same basename would collapse into one .o
# (sbs warning "overriding commands for target ...", then multiple-definition /
# undefined-symbol link errors). The game and engine files therefore carry
# distinct basenames by construction: version(-auto) in src/, build-version(-auto)
# in jfbuild/src/. (jfbuild/src/version.c was renamed to build-version.c so the
# engine never ships a second file named version.c / version-auto.c.)
exists(src/version-auto.c) {
    SOURCES += src/version-auto.c
} else {
    SOURCES += src/version.c
}
exists(jfbuild/src/build-version-auto.c) {
    SOURCES += jfbuild/src/build-version-auto.c
} else {
    SOURCES += jfbuild/src/build-version.c
}

INCLUDEPATH += \
    . \
    src \
    jfbuild/include \
    jfbuild/src \
    jfmact \
    jfaudiolib/include \
    jfaudiolib/src

DEFINES += \
    USE_POLYMOST=0 \
    USE_OPENGL=0 \
    USE_ASM=0 \
    B_LITTLE_ENDIAN=1 \
    B_BIG_ENDIAN=0 \
    B_ENDIAN_C_INLINE=1 \
    HAVE_VORBIS

symbian: {
    TARGET.UID3 = 0xE1234569
    # SIS package version (App Manager / installer). Independent of the game's
    # own version string, game_version (src/version.c), which the startup
    # window shows. Dotted numerics only (split on "." for the .pkg header).
    VERSION = 1.0.0
    # App icon in the Belle menu. JFSW.mif/JFSW.mbm are pre-generated from
    # rsrc/game.bmp by mifconv (see rsrc/icon/README.txt). On symbian-sbsv2
    # this qmake cannot run mifconv itself (application_icon.prf skips the
    # !symbian-sbsv2 branch and leaves number_of_icons=0), so the files are
    # installed via pkg rules and referenced from the app-info. The mif/mbm
    # names follow the TARGET (JFSW) to match RSS_RULES.icon_file.
    default_deployment.pkg_postrules += "\"$$_PRO_FILE_PWD_/rsrc/icon/JFSW.mif\" - \"!:\\resource\\apps\\JFSW.mif\""
    default_deployment.pkg_postrules += "\"$$_PRO_FILE_PWD_/rsrc/icon/JFSW.mbm\" - \"!:\\resource\\apps\\JFSW.mbm\""
    RSS_RULES.number_of_icons = 1
    RSS_RULES.icon_file = "\\\\resource\\\\apps\\\\JFSW.mif"
    TARGET.EPOCSTACKSIZE = 0x14000
    # Heap cap raised 128MB -> 256MB (0x10000000): on-device the process heap
    # (Qt main thread + game thread share it) saturates at the 0x8000000 cap and
    # the game OOM-crashes during death/respawn allocation spikes.
    TARGET.EPOCHEAPSIZE = 0x20000 0x10000000
    # The on-device game-data directory is defined once in src/belle_config.h
    # (BELLE_GAME_DIR). The Symbian build tools cannot carry a quoted define
    # containing a space through qmake -> .mmp -> GCCE, so it lives in a C header
    # rather than here.
    # GCC defaults to gnu89 for .c; the engine's compat.h demands C99.
    MMP_RULES += "OPTION gcce -std=c99"
    # Native Symbian media-framework output via CMMFDevSound DIRECT.
    LIBS += -lmmfdevsound
}
