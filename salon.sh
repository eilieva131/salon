#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

# Main menu function
MAIN_MENU(){
echo "$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")"
}

echo -e "\n ~~~ Hair salon ~~~\n"
echo "What service would you like to book?"
MAIN_MENU

# ask user for service id
SERVICE_EXISTS=""
until [[ $SERVICE_EXISTS ]]
do
read SERVICE_ID_SELECTED
SERVICE_EXISTS=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
if [[ -z $SERVICE_EXISTS ]]
then
echo "No such service. Try again!"
MAIN_MENU
fi
done

# ask for customer phone number
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

# check if customer exists
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_ID ]]
then
echo -e "\nWhat's your name?"
read CUSTOMER_NAME
INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
else
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
fi

# ask for appointment time
echo -e "\nWhat time do you wanna book your appointment at?"
read SERVICE_TIME

# get service name
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

# insert appointment
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

# confirmation
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."