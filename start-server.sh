#!/bin/bash
#
###############################################################################
#
# Edit memory option -Xmx in ProjectZomboid64.json for 64bit servers (common)
#   or ProjectZomboid32.json for 32bit servers (rare)
#
############

INSTDIR="`dirname $0`" ; cd "${INSTDIR}" ; INSTDIR="`pwd`"

if "${INSTDIR}/jre64/bin/java" -version > /dev/null 2>&1; then
        echo "64-bit java detected"
        export PATH="${INSTDIR}/jre64/bin:$PATH"
        export LD_LIBRARY_PATH="${INSTDIR}/linux64:${INSTDIR}/natives:${INSTDIR}:${INSTDIR}/jre64/lib/amd64:${LD_LIBRARY_PATH}"
        JSIG="libjsig.so"
        # I modified the following line slightly to add the arguments, idk how else to pass these two arguments via the environment, tried a few things, this is the only way that worked
        LD_PRELOAD="${LD_PRELOAD}:${JSIG}" ./ProjectZomboid64 -adminpassword $ADMIN_PASS -servername $SERVER_NAME "$@"
elif "${INSTDIR}/jre/bin/java" -client -version > /dev/null 2>&1; then
        echo "32-bit java detected"
        export PATH="${INSTDIR}/jre/bin:$PATH"
        export LD_LIBRARY_PATH="${INSTDIR}/linux32:${INSTDIR}/natives:${INSTDIR}:${INSTDIR}/jre/lib/i386:${LD_LIBRARY_PATH}"
        JSIG="libjsig.so"
        LD_PRELOAD="${LD_PRELOAD}:${JSIG}" ./ProjectZomboid32 "$@"
else
        echo "couldn't determine 32/64 bit of java"
fi
exit 0

#
# EOF
#
###############################################################################
