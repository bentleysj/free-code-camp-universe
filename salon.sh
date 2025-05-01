#! /bin/bash

# menu

PSQL="psql --username=freecodecamp --dbname=salon -c"


MENU () 
{
  SERVICES=$($PSQL "SELECT service_id, name FROM SERVICES;" -t -a )

echo "$SERVICES" | while read SERVICE_ID BAR NAME
do
  if [[ $SERVICE_ID =~ ^[0-9] ]] 
  then
  echo "$SERVICE_ID) $NAME"
  fi
done

echo -e "\n choose service"
read SERVICE_ID_SELECTED

if [[ $SERVICE_ID_SELECTED =~ ^[0-9] ]]
  then

    REQUESTED_SERIVCE=$($PSQL "SELECT name FROM SERVICES WHERE SERVICE_ID = $SERVICE_ID_SELECTED;" -t  -A)
    if [[ -z $REQUESTED_SERIVCE  ]]
    then
      MENU
    else

      echo -e  "\nPHONE NUMBER please"
      read CUSTOMER_PHONE

      CUSTOMER_ID=$($PSQL "SELECT CUSTOMER_ID FROM CUSTOMERS WHERE PHONE = '$CUSTOMER_PHONE';" -t -A)
      echo $CUSTOMER_ID
      if [[ -z $CUSTOMER_ID  ]]
      then
        echo -e "\nCustomer Name"
        read CUSTOMER_NAME

        CUSTOMER_ADDED=$($PSQL "INSERT INTO CUSTOMERS (NAME, PHONE) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
        CUSTOMER_ID=$($PSQL "SELECT CUSTOMER_ID FROM CUSTOMERS WHERE PHONE = '$CUSTOMER_PHONE';" -t -A) 
      else
        CUSTOMER_NAME=$($PSQL "SELECT NAME FROM CUSTOMERS WHERE PHONE = '$CUSTOMER_PHONE';" -t -A)
      fi

      echo -e "\nAppointment Time"
      read SERVICE_TIME

      APPOINT_ADDED=$($PSQL "INSERT INTO APPOINTMENTS (CUSTOMER_ID,SERVICE_ID,TIME) values ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")

      echo -e "I have put you down for a $REQUESTED_SERIVCE at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  else
    MENU
  fi
}

MENU