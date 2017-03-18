
GHOST_INSTALL=/var/www/ghost
TEMP=/tmp/ghost-update
TEMP_NEW_FILES=ghost-new
BACKUP_FOLDERS=$GHOST_INSTALL/content 

backup() {
    echo "Backup Ghost installation"
    rm -rf $TEMP
    cp -R $BACKUP_FOLDERS $TEMP
    cp $GHOST_INSTALL/index.js $GHOST_INSTALL/*.json $TEMP
}

update() {
    echo "Update Ghost installation"
    rm -rf $GHOST_INSTALL/core
    rm $BACKUP_FILES
    rm -rf $TEMP
    mkdir $TEMP
    cd $TEMP
    curl -LOk https://ghost.org/zip/ghost-latest.zip
    unzip -q ghost-latest.zip -d $TEMP_NEW_FILES
    cp -R $TEMP/$TEMP_NEW_FILES/core $GHOST_INSTALL
    cp $TEMP/$TEMP_NEW_FILES/index.js $TEMP/$TEMP_NEW_FILES/*.json $GHOST_INSTALL
    cd $GHOST_INSTALL
    chown -R ghost:ghost *
    npm install --production --unsafe-perm
}

clean() {
    echo "Clean Ghost installation"
    rm -rf $TEMP/$TEMP_NEW_FILES
    rm $TEMP/*.zip
}

stop() {
    echo "Stop services"
    sudo service nginx stop
    sudo service ghost stop
}

start() {
    echo "Start services"
    sudo service ghost start
    sudo service nginx start
}

clear;

echo "*********** Upgrading Ghost installation ***********";

#stop;
backup;
update;
clean;
#start;

echo "*********** Upgrading End ***********";
