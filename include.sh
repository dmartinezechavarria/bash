SCRIPTPATH="$( cd "$( dirname "$BASH_SOURCE" )" >/dev/null 2>&1 && pwd )"

# Config
source $SCRIPTPATH/config.properties

# Alias
source $SCRIPTPATH/scripts/alias.sh

# Variables
source $SCRIPTPATH/scripts/styles.sh

# Chat
source $SCRIPTPATH/scripts/rocketchat.sh
source $SCRIPTPATH/scripts/googlechat.sh

# JIRA
source $SCRIPTPATH/scripts/jira.sh

# Helpers
source $SCRIPTPATH/scripts/helpers.sh

# GIT
source $SCRIPTPATH/scripts/git/helpers.sh
source $SCRIPTPATH/scripts/git/alias.sh
source $SCRIPTPATH/scripts/git/feature.sh
source $SCRIPTPATH/scripts/git/hotfix.sh
source $SCRIPTPATH/scripts/git/release.sh

# Servers
source $SCRIPTPATH/scripts/servers/sync.sh
source $SCRIPTPATH/scripts/servers/development.sh
source $SCRIPTPATH/scripts/servers/machines.sh

# Admines
source $SCRIPTPATH/scripts/admines.sh

# Composer
source $SCRIPTPATH/scripts/composer/helpers.sh
source $SCRIPTPATH/scripts/composer/alias.sh

# Updates
source $SCRIPTPATH/scripts/updater.sh

# Saludo
if [ -z ${SHOWGREETING+x} ]; then 
    SHOWGREETING=1
fi

if [ "$SHOWGREETING" -eq 1 ] ; then
    printtitle "Wall-e Team | Arsys Products and Tools Development"
    printwalle
    printlinebreak
fi

# Check for updates
if [ -z ${AUTOUPDATE+x} ]; then 
    AUTOUPDATE=1
fi

if [ "$AUTOUPDATE" -eq 1 ] ; then
    toolscheckupdates
fi