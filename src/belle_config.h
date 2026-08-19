// belle_config.h -- JFSW -> Symbian Belle port: single source of truth for the
// on-device game-data directory (BELLE_GAME_DIR). This is the one place to
// change where the game expects its data (SW.GRP sits right there) and where
// sw.log / sw.cfg / savegames land: the engine chdir()s the process into this
// directory in game.c, because the default Symbian process CWD is a private
// folder the user can't browse. Included only on Symbian builds.
#ifndef __belle_config_h__
#define __belle_config_h__

#define BELLE_GAME_DIR "E:/Games/Shadow Warrior"

#endif /* __belle_config_h__ */
