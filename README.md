# Description
To run application, open terminal in folder with index.rb and run it

# Installation
```bash
git clone https://github.com/mirkru37/cars-management.git
cd cars-management
```

# Run
```bash
ruby index.rb
```

# Usage
After the start of the application, you need to fill in search rules **one by one**.
If you want **to skip** one, leave an **empty** field.

**Rules are case insensitive**

**Rules marked with * require valid input data**

###Table of validation
| Field  | Required value |
| ------------- | ------------- |
| year_(from/to)  | integer between 1800 and today's year  |
| price_(from/to)  | float under zero (**notice** that value will be rounded to two decimal places) |

###Rules
- make - takes one car brand you want to search
  >Input make: _Ford_
  >
  >Input make: ~~Ford Audi~~
- model - takes one car model
  >Input model: Focus 3
  > 
  >Input model: ~~Mondeo Focus~~ 
- year_from - takes the smallest year of searchable cars *
- year_to - takes the biggest year of searchable cars *
  >Input year: 2015
  >
  >Input year: ~~1765 BC~~
  >
  >Input year: ~~two thousand and seventeenth~~
- price_from - takes the smallest price of searchable cars *
- price_to - takes the biggest price of searchable cars *
  >Input price: 20000
  >
  >Input price: ~~20 000~~
  >
  >Input price: ~~twenty thousands~~

After that you can input sort option. If you want **to skip**, 
leave an **empty** field, and the **default** one will be chosen.
Also if you input **wrong** option, the **default** one will be chosen.

**Default** sorting is by **date_added** and **desc**

###Example

![Home Page](screenshots/usage_cast.gif)
___
####Input
```
Please input search rules(to skip one press enter)
	 Input make: 
	 Input model: 
	 Input year_from: 2017
	 Input year_to: 
	 Input price_from: 
	 Input price_to: 20000
Please input sort option (price | date_added) default: date_added
price
Please input sort order (asc | desc) default: desc
asc
Chosen sort_by: price sort_order: asc
```
####Result
```
id: 8841f970-330f-11ec-8d3d-0242ac130003
make: Renault
model: Megane
year: 2018
odometer: 245000
price: 10500
description: Car in very good condition, LPG installed
date_added: 28/09/21

id: 1ec46226-330f-11ec-8d3d-0242ac130003
make: Ford
model: Fusion
year: 2017
odometer: 65000
price: 18000
description: Selling a good car
date_added: 18/09/21

id: 7073efd8-330f-11ec-8d3d-0242ac130003
make: Ford
model: Focus
year: 2017
odometer: 103000
price: 19000
description: Like new
date_added: 24/08/21
```
___
####Input
```
Please input search rules(to skip one press enter)
	 Input make: ford
	 Input model: 
	 Input year_from: 1764
Argument 1764 must be >= 1800 and <= 2021
	 Input year_from: 
	 Input year_to: 
	 Input price_from: -123
Argument -123.0 must be >= 0 and <= 1.7976931348623157e+308
	 Input price_from: two thousands
Argument two thousands is not a number
	 Input price_from: 
	 Input price_to: 
Please input sort option (price | date_added) default: date_added

Please input sort order (asc | desc) default: desc

Chosen sort_by: date_added sort_order: desc
```
####Output
```
id: 1ec46226-330f-11ec-8d3d-0242ac130003
make: Ford
model: Fusion
year: 2017
odometer: 65000
price: 18000
description: Selling a good car
date_added: 18/09/21

id: 7073efd8-330f-11ec-8d3d-0242ac130003
make: Ford
model: Focus
year: 2017
odometer: 103000
price: 19000
description: Like new
date_added: 24/08/21
```