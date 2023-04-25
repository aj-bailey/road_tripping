# Road Tripping

### LEARNING GOALS
Create an API which consumes and incorporates weather, road trip and salary data based on unique locations into unique endpoints

### Built with:
![Ruby 3.1.1](https://img.shields.io/badge/Ruby_on_Rails-CC0000?style=for-the-badge&logo=ruby-on-rails&logoColor=white)

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)


### CLONE AND SETUP
1. `Navigate to desired directory`
1. `Run git clone git@github.com:aj-bailey/road_tripping.git`
1. `Run cd road_tripping`
1. `Run bundle`
1. `Run rails db:{create,migrate}`
1. `Run either of the below options`

### Postman
1. `Run rails s`
1. `Navigate to postman and hit any of the below endpoints`

### Test Suite
1. `Run bundle exec rspec`

### API KEYS
- WEATHER_API_KEY - https://www.weatherapi.com/
- MAP_QUEST_API_KEY - https://developer.mapquest.com/documentation/geocoding-api/

### ENDPOINTS

---

---
<br>

<details>
  <summary>GET: Weather for a city </summary>
  
  <br>
  Request:

  ```JS
  GET /api/v1/forecast?location={city,state}
  ```
  
  Params: 

  | Name | Requirement | Type | Description |
  | ----- | ----------- | -----| -------------- | 
  | `location` | Required | string | "city,state"

  <br>

  Response: 

  | Result | Status |
  | ------- | ------| 
  | `Success` | 201 |
  | `Failure`| 401 |


  ```JSON
  {
  "data": {
    "id": null,
    "type": "forecast",
    "attributes": {
      "current_weather": {
        "last_updated": "2023-04-07 16:30",
        "temperature": 55.0,
        etc
      },
      "daily_weather": [
        {
          "date": "2023-04-07",
          "sunrise": "07:13 AM",
          etc
        },
        {...} etc
      ],
      "hourly_weather": [
        {
          "time": "14:00",
          "temperature": 54.5,
          etc
        },
        {...} etc
      ]
    }
  }
}
  ```
</details>

<details>
  <summary>POST: Create User </summary>
  
  <br>
  Request:

  ```JS
  POST /api/v1/users
  ```
  
  Params: 

  | Name | Requirement | Type | Description |
  | ----- | ----------- | -----| -------------- | 
  | `email` | Required | string | unique user email
  | `password` | Required | string | password
  | `password_confirmation` | Required | string | matching password

  <br>

  Response: 

  | Result | Status |
  | ------- | ------| 
  | `Success` | 201 |
  | `Failure`| 401 |


  ```JSON
  {
    "data": {
      "type": "users",
      "id": "1",
      "attributes": {
        "email": "whatever@example.com",
        "api_key": "t1h2i3s4_i5s6_l7e8g9i10t11"
      }
    }
  }
  ```
</details>

<details>
  <summary>POST: Login User </summary>
  
  <br>
  Request:

  ```JS
  POST /api/v1/sessions
  ```
  
  Params: 

  | Name | Requirement | Type | Description |
  | ----- | ----------- | -----| -------------- | 
  | `email` | Required | string | unique user email
  | `password` | Required | string | password

  <br>

  Response: 

  | Result | Status |
  | ------- | ------| 
  | `Success` | 201 |
  | `Failure`| 401 |


  ```JSON
  {
    "data": {
      "type": "users",
      "id": "1",
      "attributes": {
        "email": "whatever@example.com",
        "api_key": "t1h2i3s4_i5s6_l7e8g9i10t11"
      }
    }
  }
  ```
</details>

<details>
  <summary>POST: Road Trip </summary>
  
  <br>
  Request:

  ```JS
  POST /api/v1/road_trip
  ```
  
  Params: 

  | Name | Requirement | Type | Description |
  | ----- | ----------- | -----| -------------- | 
  | `origin` | Required | string | start "city,state"
  | `destination` | Required | string | end "city,state"
  | `api_key` | Required | string | unique user api key

  <br>

  Response: 

  | Result | Status |
  | ------- | ------| 
  | `Success` | 201 |
  | `Failure`| 401 |


  ```JSON
  {
    "data": {
      "id": "null",
      "type": "road_trip",
      "attributes": {
        "start_city": "Cincinatti, OH",
        "end_city": "Chicago, IL",
        "travel_time": "04:40:45",
        "weather_at_eta": {
          "datetime": "2023-04-07 23:00",
          "temperature": 44.2,
          "condition": "Cloudy with a chance of meatballs"
        }
      }
    }
  }
  ```
</details>

<details>
  <summary>POST: Salaries </summary>
  
  <br>
  Request:

  ```JS
  POST /api/v1/salaries?destination={destination}
  ```
  
  Params: 

  | Name | Requirement | Type | Description |
  | ----- | ----------- | -----| -------------- | 
  | `destination` | Required | string | city

  <br>

  Response: 

  | Result | Status |
  | ------- | ------| 
  | `Success` | 201 |
  | `Failure`| 401 |


  ```JSON
  {
    "data": {
        "id": null,
        "type": "salaries",
        "attributes": {
            "destination": "denver",
            "forecast": {
                "summary": "Partly cloudy",
                "temperature": "58 F"
            },
            "salaries": [
                {
                    "title": "Data Analyst",
                    "min": "$42,878.34",
                    "max": "$62,106.69"
                },
                {
                    "title": "Data Scientist",
                    "min": "$74,686.72",
                    "max": "$108,990.21"
                },
                {
                    "title": "Mobile Developer",
                    "min": "$69,999.26",
                    "max": "$109,493.37"
                },
                {
                    "title": "QA Engineer",
                    "min": "$56,250.12",
                    "max": "$85,478.12"
                },
                {
                    "title": "Software Engineer",
                    "min": "$64,514.46",
                    "max": "$95,843.57"
                },
                {
                    "title": "Systems Administrator",
                    "min": "$53,889.29",
                    "max": "$78,055.83"
                },
                {
                    "title": "Web Developer",
                    "min": "$51,218.22",
                    "max": "$78,639.07"
                }
            ]
        }
    }
}
  ```
</details>