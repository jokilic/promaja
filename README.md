![Header](https://raw.githubusercontent.com/jokilic/promaja/main/screenshots/header-wide.png)

# Promaja 🌬️🍃

🌬️🍃 **Promaja** is a simple weather application made in **Flutter**. 👨‍💻

It features beautiful weather icons and accurate weather information for any location you can think of. 🌍\
Weather is shown in a simple card UI which gives you all data at a glance. 🃏\
You can use a simple widget which shows current weather for the chosen location 🌡️

### Promaja can be downloaded from [HERE](https://play.google.com/store/apps/details?id=com.josipkilic.promaja).
&nbsp;

![Multi](https://raw.githubusercontent.com/jokilic/promaja/main/screenshots/multi.png)

**Current weather** 🌤️

Using a simple card UI, check current weather for all enabled locations.\
All relevant information is accurate and easily visible.


**Forecast weather** 🌦️

Like in Current weather, data is shown in a simple card UI.\
Forecast shows a single location, the one you decided to check out.\
Weather for multiple days is shown and hourly weather is visible at a glance.

**List of locations** 📍

Here you can add new locations, delete unwanted ones and reorder them how you desire.\
You can also see current weather for them in one simple place.\
Tapping on any location will bring you to Forecast weather.

## Things I still want to do 👷‍♂️

- [ ] Publish app on App Store
- [ ] Make a good looking settings screen with ListTiles and minimal design
    - [ ] Localization
    - [ ] Widget
        - [ ] Location
        - [ ] Current weather or forecast
    - [ ] Notifications
        - [ ] Location
        - [ ] Morning notification about daily forecast
            - [ ] Put it between 7, 8, 9 or 10
        - [ ] Hourly notification about current weathe
        - [ ] Nightly notification about tomorrows forecast
            - [ ] Put it between 19, 20, 21 or 22
    - [ ] Units
        - [ ] Temperature
            - [ ] Celsius / Fahrenheit
        - [ ] Distance / speed
            - [ ] Kilometers / miles
        - [ ] Pressure
            - [ ] Hectopascal / Inches of Mercury



Temperature
    - CardSuccess
    - ListCardSuccess
    - WeatherCardSuccess
    - WeatherCardHourSuccess
    - WeatherCardIndividualHour
    - NotificationService
    - HomeWidget
    - AdditionalWPF

Added fields
    - Current
        - temp_f
        - wind_mph
        - pressure_in
        - precip_in
        - feelslike_f
        - vis_miles
        - gust_mph
