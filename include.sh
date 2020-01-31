SCRIPTPATH="$( cd "$( dirname "$BASH_SOURCE" )" >/dev/null 2>&1 && pwd )"

# Config
source $SCRIPTPATH/config.properties

# Alias
source $SCRIPTPATH/scripts/alias.sh

# Variables
source $SCRIPTPATH/scripts/styles.sh

# Rocketchat
source $SCRIPTPATH/scripts/rocketchat.sh

# Helpers
source $SCRIPTPATH/scripts/helpers.sh

# GIT
source $SCRIPTPATH/scripts/git/helpers.sh
source $SCRIPTPATH/scripts/git/feature.sh
source $SCRIPTPATH/scripts/git/hotfix.sh
source $SCRIPTPATH/scripts/git/release.sh

# Servers
source $SCRIPTPATH/scripts/servers/sync.sh
source $SCRIPTPATH/scripts/servers/development.sh
