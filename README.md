# Air Quality in Mexico City
This repository contains some tools to analyze the air quality of Mexico City using Python. 
My main objective is to keep uploading more complex analysis on this topic, as I keep learning on data analysis and machine learning. 

1. [General Description](https://github.com/Chinnasf/Air-Quality-in-Mexico-City#General-Description)

2. [Codes Description](https://github.com/Chinnasf/Air-Quality-in-Mexico-City#Codes-Description)

3. [Contributing](https://github.com/Chinnasf/Air-Quality-in-Mexico-City#Contributing)

---

### 1. General Description

The project was born out of the question: **how harmful is the air quality of Mexico City over a given period time?** 
My motivation was to understand if there were important patterns of presence of pollutants in Mexico City -- the city with most population in the country. 

The following table, shows the pollutants being considered, accompanied with a general description and the source of the data. 

| Pollutant | Units | Information | Data Source 
| :--------: | :--------: | :--------: | :--------: | 
| UVA Rays | mW/m^2 | [click](https://uihc.org/health-topics/what-difference-between-uva-and-uvb-rays) | [click](http://www.aire.cdmx.gob.mx/default.php?opc=%27aKBhnmI=%27&opcion=bA==) 
| UVB Rays |mW/m^2<br>and<br>UVI | [click](https://uihc.org/health-topics/what-difference-between-uva-and-uvb-rays) | [click](http://www.aire.cdmx.gob.mx/default.php?opc=%27aKBhnmI=%27&opcion=bQ==) 
| PM10 | μg/m^3 | [click](https://www.epa.gov/pm-pollution/particulate-matter-pm-basics) | [click](http://www.aire.cdmx.gob.mx/default.php?opc=%27aKBhnmE=%27&r=b3BlbmRhdGEvcmVkX21hbnVhbC9yZWRfbWFudWFsX3BhcnRpY3VsYXNfc3VzcC5jc3Y=) 
| PM2.5 | μg/m^3 | [click](https://www.epa.gov/pm-pollution/particulate-matter-pm-basics) | [click](http://www.aire.cdmx.gob.mx/default.php?opc=%27aKBhnmE=%27&r=b3BlbmRhdGEvcmVkX21hbnVhbC9yZWRfbWFudWFsX3BhcnRpY3VsYXNfc3VzcC5jc3Y=) 
| PST<br>(Total Suspended<br>Particulate Matter)| μg/m^3 | [click](https://www.encyclopedia.com/education/encyclopedias-almanacs-transcripts-and-maps/total-suspended-particles-tsp) | [click](http://www.aire.cdmx.gob.mx/default.php?opc=%27aKBhnmE=%27&r=b3BlbmRhdGEvcmVkX21hbnVhbC9yZWRfbWFudWFsX3BhcnRpY3VsYXNfc3VzcC5jc3Y=) 
| Pb (lead) | μg/m^3 | [click](https://www.epa.gov/lead-air-pollution/basic-information-about-lead-air-pollution#health) | [click](http://www.aire.cdmx.gob.mx/default.php?opc=%27aKBhnmE=%27&r=b3BlbmRhdGEvcmVkX21hbnVhbC9yZWRfbWFudWFsX3Bsb21vLmNzdg==)

<h4 style="text-align: center;" markdown="1">  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Types of pollutants considered in codes.</h4>


I chose these samples because they are amongst the most damaging to health and natural environment. Since the data available for lead is from 1989/01/08 to 2017/10/28; and, the data available for UVA rays is from the years 2000 to 2020, **I am going to analyze the years 2000 to 2015**, so I can have a 16 years time span. The source of the data is from [Mexico City government's website](https://www.cdmx.gob.mx/), and it is free to use. 

The obtained data for UVA and UVB rays is given in mW/cm^2 and MED/h, respectively; however, I will convert them to mW/m^2 as it is the convention to study them. 
The values I used were the ones [proposed by the UVR-RI](https://meteo.lcd.lu/uvi_calculator/02-UVI-Calculations-2-7.PDF).

#### IMPORTANT

In order to understand registered values of particles's presence, I considered the AQI (air quality) scale. Parameters are explained below: 


| AQI<br>Category 	| AQI <br>Parameter 	| PM2.5<br>μg/m^3 	| PM10<br>μg/m^3 	| Pb<br>μg/m^3 	|
|:---------------:	|:-------------------:	|:--------------------------:	|:-------------------------:	|:------------------:	|
|       **Good**      	| 0-50              	|            0-30            	|            0-50           	|        0-0.5       	|
|   **Satisfactory**  	| 51-100            	|            31-60           	|           51-100          	|       0.6-1.0      	|
|     **Moderate**    	| 101-200           	|            61-90           	|          101-250          	|       1.1-2.0      	|
|       **Poor**      	| 201-350           	|           91-120           	|          251-350          	|       2.1-3.0      	|
|    **Very Poor**    	| 351-400           	|           121-250          	|          351-430          	|       3.1-3.5      	|
|      **Severe**     	| 401-500+          	|            >250            	|            >430           	|        >3.5        	|

<h4 style="text-align: center;" markdown="1">  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Breakingpoints for AQI scale.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Data in columns represent 24h monitoring.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</h4>


[Table's Information Source](https://books.google.com.mx/books?id=i6eMDwAAQBAJ&pg=PA215&lpg=PA215&dq=aqi+air+quality+index+for+lead+Pb+ug/m3&source=bl&ots=MLBgE2il4h&sig=ACfU3U2BXYIoBhbkM5AcxPhjQpWWhydK6A&hl=en&sa=X&ved=2ahUKEwiyrJ3_tKrqAhUIP6wKHXDfAycQ6AEwAHoECA0QAQ#v=onepage&q&f=false). For PST values, I will consider it as a similar behaviour compared to PM10.

Also, to understand the registered values for ultraviolet rays's intensity, I considered the UVI scale/units. Parameters are explained below: 


| UVI Value | 1-2 |   3-5  |  6-7 |    8-10   |       11+      |
|:---------:|:---:|:------:|:----:|:---------:|:--------------:|
|   Meaning   | Low | Medium | High | Very High | Extremely High |

<h4 style="text-align: center;" markdown="1">  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;UVI index according to the World Health Organization.</h4>


[Table's Information Source](http://origin.who.int/uv/intersunprogramme/activities/uv_index/en/index1.html).



---

### 2. Codes Description

`visual_analysis.py` contains the procedure of obtaining two visuals of the selected pollutants in the location 
of _Tlanepantla, Mexico City_. The python libraries `pandas`,`matplotlib`, `numpy`, `seaborn`, and `warnings` are used. No data preprocessing is done 
and it is assumed that all registered data is of equal importance for the analysis. 

---

### 3. Contributing

When contributing to this repository, please first discuss the change you wish to make via email 
(or any other method) with me before making a change.

