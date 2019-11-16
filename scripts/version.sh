#! /bin/bash

if [ -z "$1" ] || [ "$1" == "version" ]; then
    # Taken from https://github.com/AuraDevelopmentTeam/GradleCommon/blob/master/common.gradle and turned into a shell script 

    GIT_DESCRIPTION="$(git describe --tags --dirty)"

    function getBuildType() {
        if [[ "$GIT_DESCRIPTION" == *dirty ]]; then
            echo "SNAPSHOT"
        elif [[ "$GIT_DESCRIPTION" == *-* ]]; then
            echo "DEV"
        else
            echo "RELEASE"
        fi
    }

    BUILD_TYPE="$(getBuildType)"

    IS_SNAPSHOT=$([ "$BUILD_TYPE" == "SNAPSHOT" ] && echo 1 || echo 0)
    IS_DEV=$(([ $IS_SNAPSHOT -eq 1 ] || [ "$BUILD_TYPE" == "DEV" ]) && echo 1 || echo 0)

    function getBuild() {
        local commits=$(git rev-list --count HEAD)

        echo $(($commits + $IS_SNAPSHOT))
    }

    BUILD=$(getBuild)

    function getShortVersion() {
        local tempVersion=($(echo $GIT_DESCRIPTION | sed -e 's/^v\|-.*//g' -e 's/\./ /g'))

        if [ $IS_DEV -eq 1 ]; then
            if [ ! -z "$MAJOR" ]; then
                tempVersion[0]=$((${tempVersion[0]} + 1))
                tempVersion[1]=0
                tempVersion[2]=0
            elif [ ! -z "$MINOR" ]; then
                tempVersion[1]=$((${tempVersion[1]} + 1))
                tempVersion[2]=0
            else
                tempVersion[2]=$((${tempVersion[2]} + 1))
            fi
        fi

        local baseVersion="$(printf ".%s" "${tempVersion[@]}")"

        echo "${baseVersion:1}"
    }

    SHORT_VERSION="$(getShortVersion)"

    function getVersion() {
        local baseVersion="$SHORT_VERSION.$BUILD"

        if [ -z "$BRANCH"]; then
            BRANCH=$(git describe --all | sed -e 's@^[^/]*/@@g' -e 's@/\|\\@_@g')
        fi

        if [ "$BRANCH" != "master" ] && ! [[ "$BRANCH" =~ v[0-9]+\.[0-9]+\.[0-9]+ ]]; then
            baseVersion="$baseVersion-$BRANCH"
        fi

        if [ "$BUILD_TYPE" != "RELEASE" ]; then
            baseVersion="$baseVersion-$BUILD_TYPE"
        fi

        echo "$baseVersion"
    }

    VERSION="$(getVersion)"

    function getChangelog() {
        if [ -f CHANGELOG.md ]; then
            local changelog="$(cat CHANGELOG.md | tr -d '\r' | awk 'BEGIN{p=0} /^Version /{p++; if (p != 1) exit} {if (p == 1) print}')"
        fi

        if [ -z "$changelog" ]; then
            echo "*No Changelog*"
        else
            echo "$changelog"
        fi
    }
fi

if [ -z "$1" ] || [ "$1" == "timestamp" ]; then
    TIMESTAMP=$(git log -1 --date=format:'%s' --format="%ad")
fi
