#!/bin/bash

#export > /tmp/export

CONFIG='/config/config.inc.php'

if [[ ! -z ${SITEBAR_BASEURL} ]] || [[ ! -z ${SITEBAR_DATABASE_NAME} ]] || [[ ! -z ${SITEBAR_DATABASE_PASSWORD} ]] || [[ ! -z ${SITEBAR_DATABASE_USER} ]]
then
    if [[ ! -f "$CONFIG" ]]; then

    cat << EOF > $CONFIG
<?php
\$SITEBAR = array
(
    'db' => array
    (
        'host'      =>  'db',
        'username'  =>  'sitebar',
        'password'  =>  'sitebar',
        'name'      =>  'sitebar',
    ),
    'baseurl' => '/sbar/',
    'login_as' => null,
);
?>
EOF
    fi

    sed -i "s~'baseurl'.*$~'baseurl' => '${SITEBAR_BASEURL}',~g" $CONFIG
    sed -i "s~'username'.*$~'username'  =>  '${SITEBAR_DATABASE_USER}',~g" $CONFIG
    sed -i "s~'password'.*$~'password'  => '${SITEBAR_DATABASE_PASSWORD}',~g" $CONFIG
    sed -i "s~'name'.*$~'name'      => '${SITEBAR_DATABASE_NAME}',~g" $CONFIG

fi

exit 0
