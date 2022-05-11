#!/bin/bash

source ../.shared/utils.sh
initkata

rest_create_repository $MATURITY_1_REPO "gradle"
rest_create_repository $MATURITY_2_REPO "gradle"
rest_create_repository $MATURITY_3_REPO "gradle"
rest_create_repository $MATURITY_4_REPO "gradle"


echo "Setup done. Your repositories are called the following:"
echo "level 1: $MATURITY_1_REPO"
echo "level 2: $MATURITY_2_REPO"
echo "level 3: $MATURITY_3_REPO"
echo "level 4: $MATURITY_4_REPO"
echo "Remember to navigate to the exercise folder created."
