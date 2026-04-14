Forecasting Tourist Arrivals to Turkey Using Time Series Models (2015–2025)

## Overview
This project analyzes the monthly number of foreign visitors arriving in Türkiye from November 2015 to October 2025. The study focuses on identifying underlying patterns such as trend and seasonality, evaluating multiple time series models, and selecting the most appropriate model for accurate forecasting.

## Objective
The main objective is to model and forecast tourist arrivals by:
- Detecting trend and seasonal components
- Transforming the series into a stationary process
- Comparing different time series models
- Selecting the most reliable model for forecasting future values

## Tools Used
- R (forecast, tseries, stats packages)
- Time Series Analysis Techniques (ACF, PACF, SARIMA, ETS)

## Dataset
Source: Monthly foreign visitor arrivals to Türkiye (2015–2025) :contentReference[oaicite:0]{index=0}  
Frequency: Monthly  
Observations: November 2015 – October 2025  

## What I Did
- Visualized the time series and identified trend and seasonality
- Analyzed ACF and PACF to understand dependency structure
- Applied first-order differencing and seasonal differencing to achieve stationarity
- Performed additive and multiplicative decomposition
- Built regression models including seasonal components (sin & cos terms)
- Evaluated multiple exponential smoothing models:
  - Simple Exponential Smoothing
  - Holt Method
  - Holt-Winters (Additive & Multiplicative)
- Developed and compared several SARIMA models
- Selected the best model based on AIC, residual diagnostics, and parsimony
- Forecasted future tourist arrivals using the final model

## Key Findings
- The series shows a **clear upward trend** and **strong annual seasonality**, with peaks in summer and declines in winter :contentReference[oaicite:1]{index=1}  
- The data is **non-stationary**, requiring both trend and seasonal differencing  
- The **multiplicative decomposition model** better captures changing seasonal amplitude compared to the additive model  
- Exponential smoothing models without seasonality (SES, Holt) performed poorly  
- **Holt-Winters additive model** captured trend and seasonality well but still left some autocorrelation  
- The best-performing model was:

  **SARIMA(0,1,1)(0,1,1)[12]**

- This model:
  - Successfully captured both trend and seasonal structure  
  - Produced residuals behaving like **white noise** (validated by Ljung–Box test, p > 0.05) :contentReference[oaicite:2]{index=2}  
  - Provided reliable and consistent forecasts  

## Files in This Repository
- `report.pdf` – Full report including methodology, model comparison, and interpretation of results
- `data.xlsx` – Monthly dataset of foreign visitor arrivals to Türkiye (2015–2025)
- `r-code.R` – R script containing data preprocessing, time series analysis, and forecasting models


## Project Preview
Time series graph for the orijinal series:


![Time Series](https://github.com/user-attachments/assets/33dd3aa0-ec2c-4cb1-896c-9a94ecc97cb4)


ACF & PACF for the original series:


<img width="553" height="422" alt="image" src="https://github.com/user-attachments/assets/66a73c72-d32a-4270-998a-13124e414044" />


<img width="534" height="485" alt="image" src="https://github.com/user-attachments/assets/5081a7a3-b0f9-431d-a611-4c71c948976a" />

Time series Graph for the series with first degree difference:


<img width="434" height="358" alt="image" src="https://github.com/user-attachments/assets/a045c900-e096-425e-9aa2-5bd4271a1ef3" />


Time series Graph for the series with first degree seasonal difference:


<img width="572" height="479" alt="image" src="https://github.com/user-attachments/assets/9691f61d-300f-4b52-ae1d-1b76ad4e6196" />


Checking stationarity( ACF&PACF):


<img width="528" height="423" alt="image" src="https://github.com/user-attachments/assets/db64fbbf-0c7d-4291-a86c-78738f25cf1c" />


<img width="523" height="444" alt="image" src="https://github.com/user-attachments/assets/5015b432-dff7-4925-879a-43c108b902dd" />


Comparing Box-Jenkins Modells:


<img width="636" height="208" alt="image" src="https://github.com/user-attachments/assets/7380c0f7-79f5-4743-a154-d016e32332c5" />


 Testing the fit between the orijinal series and SARIMA(0,1,1)(0,1,1)12 model estimation series

 
 <img width="684" height="566" alt="image" src="https://github.com/user-attachments/assets/d4b70642-4cb8-468f-9347-54f4e6cd34eb" />

 
 ACF & PACF for the error series(white noise check):

 
 <img width="543" height="861" alt="image" src="https://github.com/user-attachments/assets/0e8e4fc1-89bc-46f0-9a31-5faa750c7499" />

 
 12 Months estimation using SARIMA model:

 
 <img width="828" height="726" alt="image" src="https://github.com/user-attachments/assets/53a8a793-d5e7-41c5-b1f4-a6511d8801f5" />

## Author
Salma Sobhy
