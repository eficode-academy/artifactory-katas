#!/bin/bash

source ../.shared/utils.sh
initkata

rest_create_repository $MATURITY_1_REPO "gradle" &>> $LOGFILE
rest_create_repository $MATURITY_2_REPO "gradle" &>> $LOGFILE
rest_create_repository $MATURITY_3_REPO "gradle" &>> $LOGFILE
rest_create_repository $MATURITY_4_REPO "gradle" &>> $LOGFILE

populate_maturity_repos

echo "Setup done."