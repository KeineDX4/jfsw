#!/bin/sh
# Stamp version-auto.c from git describe, mirroring the desktop Makefiles
# (Makefile:274-277 for the game, jfbuild/Makefile:260-263 for the engine).
#
# On desktop, when git is present the Makefile regenerates version-auto.c and
# compiles it instead of the committed version.c fallback. The Symbian build
# pipeline (keinedx2/symbian-belle-buildtools) stages the project WITHOUT .git,
# so `git describe` cannot run inside the container; this script stamps the
# version files on the HOST, before the container is started. jfsw.pro then
# picks them up via exists(version-auto.c).
#
# Usage:  tools/stamp-version.sh   (from the repo root)
# Output: src/version-auto.c          -> game_version    (startup window, console)
#         jfbuild/src/version-auto.c  -> build_version   (engine BUILD banner)
set -e

cd "$(dirname "$0")/.."    # repo root

# Game version.
printf 'const char *game_version = "%s";\n' "$(git describe --always || echo git error)" > src/version-auto.c
echo 'const char *game_date = __DATE__;' >> src/version-auto.c
echo 'const char *game_time = __TIME__;' >> src/version-auto.c

# Engine version (jfbuild submodule).
printf 'const char *build_version = "%s";\n' "$(git -C jfbuild describe --always || echo git error)" > jfbuild/src/version-auto.c
echo 'const char *build_date = __DATE__;' >> jfbuild/src/version-auto.c
echo 'const char *build_time = __TIME__;' >> jfbuild/src/version-auto.c

echo "stamped src/version-auto.c:         $(grep game_version src/version-auto.c)"
echo "stamped jfbuild/src/version-auto.c: $(grep build_version jfbuild/src/version-auto.c)"
