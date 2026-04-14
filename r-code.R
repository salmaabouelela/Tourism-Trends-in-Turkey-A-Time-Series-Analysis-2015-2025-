rm(list = ls())

library(forecast)
library(fpp)
library(lmtest)
library(readxl)
library(tseries)
library(stats)


View(data)
str(data)
data <- data[order(data$Year,
                   match(data$Month,
                         month.name)), ]
visitors_ts <- ts(data$`The number of foreign visitors to Turkey`,
                  start = c(2015,11),
                  frequency = 12)
ts.plot(visitors_ts,
        xlab = "Zaman",
        ylab = "Yabanci Ziyaretçi Sayisi",
        lwd = 2,
        main = "Türkiye'ye Gelen Yabanci Ziyaretçiler")

Acf(visitors_ts, lag.max = 42, ylim = c(-1,1), lwd = 3)
Pacf(visitors_ts, lag.max = 42, ylim = c(-1,1), lwd = 3)

diff1 <- diff(visitors_ts, differences = 1)

ts.plot(diff1,
        main = "Birinci Dereceden Fark Alinmis Seri",
        ylab = "Fark Degerleri",
        xlab = "Zaman")

diff_seasonal <- diff(visitors_ts, lag = 12)

ts.plot(diff_seasonal,
        main = "12 Dönemlik Mevsimsel Fark Alinmis Seri",
        ylab = "Fark Degerleri",
        xlab = "Zaman")


diff_final <- diff(diff(visitors_ts, lag = 12), differences = 1)

Acf(diff_final,
    lag.max = 42,
    main = "Duragan Seri için ACF")

Pacf(diff_final,
     lag.max = 42,
     main = "Duragan Seri için PACF")

add_decomp <- decompose(visitors_ts, type = "additive")
plot(add_decomp)

trend_add <- tslm(visitors_ts ~ trend)
summary(trend_add)

fitted_add <- add_decomp$trend + add_decomp$seasonal

plot(visitors_ts,
     main = "Toplamsal Model: Orijinal vs Tahmin",
     xlab = "Zaman",
     ylab = "Ziyaretçi Sayisi",
     lwd = 2)
lines(fitted_add, col = "red", lwd = 2)
legend("topleft",
       legend = c("Orijinal Seri", "Tahmin"),
       col = c("black", "red"),
       lwd = 2)


resid_add <- add_decomp$random

Acf(resid_add,
    main = "Toplamsal Model - Hata ACF",
    lag.max = 42)

Pacf(resid_add,
     main = "Toplamsal Model - Hata PACF",
     lag.max = 42)

Box.test(resid_add,
         lag = 24,
         type = "Ljung-Box")


mult_decomp <- decompose(visitors_ts, type = "multiplicative")
plot(mult_decomp)

trend_mult <- tslm(visitors_ts / mult_decomp$seasonal ~ trend)
summary(trend_mult)

fitted_mult <- mult_decomp$trend * mult_decomp$seasonal

plot(visitors_ts,
     main = "Çarpimsal Model: Orijinal vs Tahmin",
     xlab = "Zaman",
     ylab = "Ziyaretçi Sayisi",
     lwd = 2)
lines(fitted_mult, col = "blue", lwd = 2)
legend("topleft",
       legend = c("Orijinal Seri", "Tahmin"),
       col = c("black", "blue"),
       lwd = 2)

resid_mult <- mult_decomp$random


Acf(resid_mult,
    main = "Çarpimsal Model - Hata ACF",
    lag.max = 42)

Pacf(resid_mult,
     main = "Çarpimsal Model - Hata PACF",
     lag.max = 42)

Box.test(resid_mult,
         lag = 24,
         type = "Ljung-Box")




#regresyon analizi
#toplamsal model
t <- 1:length(visitors_ts)

sin1 <- sin(2*pi*t/12)
cos1 <- cos(2*pi*t/12)
data_add <- data.frame(
  y = as.numeric(visitors_ts),
  t = t,
  sin1 = sin1,
  cos1 = cos1
)

model_add <- lm(y ~ t + sin1 + cos1, data = data_add)
summary(model_add)

add_fitted_ts <- ts(add_fitted,
                    start = start(visitors_ts),
                    frequency = frequency(visitors_ts))

plot(visitors_ts,
     col = "blue", lwd = 2,
     ylab = "Deger", xlab = "Zaman",
     main = "Toplamsal Regresyon: Orijinal - Tahmin")

lines(add_fitted_ts,
      col = "red", lwd = 2, lty = 2)

legend("topleft",
       c("Orijinal Seri", "Toplamsal Tahmin"),
       col = c("blue", "red"),
       lwd = 2, lty = c(1,2))


res_add <- resid(model_add)

Acf(res_add, lag.max = 42,
    main = "Toplamsal Model - Artik ACF")

Pacf(res_add, lag.max = 42,
     main = "Toplamsal Model - Artik PACF")
Box.test(res_add, lag = 24, type = "Ljung")

library(lmtest)
dwtest(model_add)


#carpimsal model
s1 <- t * sin(2*pi*t/12)
c1 <- t * cos(2*pi*t/12)

data_mult <- data.frame(
  y = as.numeric(visitors_ts),
  t = t,
  s1 = s1,
  c1 = c1
)

model_mult <- lm(y ~ t + s1 + c1, data = data_mult)
summary(model_mult)

mult_fitted_ts <- ts(mult_fitted,
                     start = start(visitors_ts),
                     frequency = frequency(visitors_ts))

plot(visitors_ts,
     col = "blue", lwd = 2,
     ylab = "Deger", xlab = "Zaman",
     main = "Çarpimsal Regresyon: Orijinal - Tahmin")

lines(mult_fitted_ts,
      col = "darkgreen", lwd = 2, lty = 2)

legend("topleft",
       c("Orijinal Seri", "Çarpimsal Tahmin"),
       col = c("blue", "darkgreen"),
       lwd = 2, lty = c(1,2))


res_mult <- resid(model_mult)

Acf(res_mult, lag.max = 42,
    main = "Çarpimsal Model - Artik ACF")

Pacf(res_mult, lag.max = 42,
     main = "Çarpimsal Model - Artik PACF")
Box.test(res_mult, lag = 24, type = "Ljung")
dwtest(model_mult)

#ustel duzlestirma yontemleri
#basit ustel duzlestirma

SES <- ets(visitors_ts, model = "ANN")
summary(SES)
checkresiduals(SES, lag = 42)

#Holt yontemi
Holt <- ets(visitors_ts, model = "AAN")
summary(Holt)
holt_fitted <- ts(Holt$fitted,
                  start = start(visitors_ts),
                  frequency = frequency(visitors_ts))

plot(visitors_ts,
     xlab="Zaman", ylab="",
     lwd=2, col=4,
     main="Holt Yöntemi: Orijinal - Tahmin")

lines(holt_fitted, col=2, lwd=3, lty=3)

legend("topleft",
       c("Orijinal Seri", "Holt Tahmin"),
       col=c(4,2), lwd=c(2,3), lty=c(1,3))
hata_holt <- Holt$residuals

Box.test(hata_holt, lag = 24, type = "Ljung")

Acf(hata_holt, lag.max = 42, ylim=c(-1,1), lwd=3)
Pacf(hata_holt, lag.max = 42, ylim=c(-1,1), lwd=3)

checkresiduals(Holt, lag = 42)

#Winters Toplamsal Yöntemi
Winters_add <- ets(visitors_ts, model = "AAA")
summary(Winters_add)

add_fitted <- ts(Winters_add$fitted,
                 start = start(visitors_ts),
                 frequency = frequency(visitors_ts))

plot(visitors_ts,
     xlab="Zaman", ylab="",
     lwd=2, col=4,
     main="Toplamsal Winters: Orijinal - Tahmin")

lines(add_fitted, col=2, lwd=3, lty=3)

legend("topleft",
       c("Orijinal Seri", "Toplamsal Winters"),
       col=c(4,2), lwd=c(2,3), lty=c(1,3))

hata_add <- Winters_add$residuals

Box.test(hata_add, lag = 24, type = "Ljung")

Acf(hata_add, lag.max = 42, ylim=c(-1,1), lwd=3)
Pacf(hata_add, lag.max = 42, ylim=c(-1,1), lwd=3)

checkresiduals(Winters_add, lag = 42)

#Winters carpimsal Yöntemi

Winters_mult <- ets(visitors_ts, model = "MAM")
summary(Winters_mult)

mult_fitted <- ts(Winters_mult$fitted,
                  start = start(visitors_ts),
                  frequency = frequency(visitors_ts))

plot(visitors_ts,
     xlab="Zaman", ylab="",
     lwd=2, col=4,
     main="Çarpimsal Winters: Orijinal - Tahmin")

lines(mult_fitted, col=3, lwd=3, lty=3)

legend("topleft",
       c("Orijinal Seri", "Çarpimsal Winters"),
       col=c(4,3), lwd=c(2,3), lty=c(1,3))

hata_mult <- Winters_mult$residuals

Box.test(hata_mult, lag = 24, type = "Ljung")

Acf(hata_mult, lag.max = 42, ylim=c(-1,1), lwd=3)
Pacf(hata_mult, lag.max = 42, ylim=c(-1,1), lwd=3)

checkresiduals(Winters_mult, lag = 42)

#model Karsilastirma
accuracy(SES)
accuracy(Holt)
accuracy(Winters_add)
accuracy(Winters_mult)

#Aday ARIMA Modelleri

model_1 <- Arima(visitors_ts,
                 order = c(0,1,1),
                 seasonal = c(0,1,1))

model_2 <- Arima(visitors_ts,
                 order = c(1,1,1),
                 seasonal = c(0,1,1))

model_3 <- Arima(visitors_ts,
                 order = c(0,1,1),
                 seasonal = c(1,1,0))

model_4 <- Arima(visitors_ts,
                 order = c(1,1,0),
                 seasonal = c(1,1,0))
summary(model_1)
coeftest(model_1)

summary(model_2)
coeftest(model_2)

summary(model_3)
coeftest(model_3)

summary(model_4)
coeftest(model_4)



best_model <- model_1

fitted_arima <- fitted(best_model)

plot(visitors_ts,
     xlab = "Zaman",
     ylab = "Ziyaretçi Sayisi",
     lwd = 2,
     col = "blue",
     main = "ARIMA Modeli: Orijinal - Tahmin")

lines(fitted_arima,
      col = "red",
      lwd = 2,
      lty = 2)
legend("topleft",
       c("Orijinal Seri", "ARIMA Tahmin"),
       col = c("blue", "red"),
       lwd = 2,
       lty = c(1,2))


res_arima <- residuals(best_model)

# Ljung-Box Testi
Box.test(res_arima,
         lag = 24,
         type = "Ljung-Box")

# ACF - PACF (Artiklar)
Acf(res_arima,
    lag.max = 42,
    ylim = c(-1,1),
    main = "ARIMA Artiklar - ACF")

Pacf(res_arima,
     lag.max = 42,
     ylim = c(-1,1),
     main = "ARIMA Artiklar - PACF")

forecast_arima <- forecast(best_model, h = 12)

plot(forecast_arima,
     main = "SARIMA ile 12 Aylik Tahmin",
     xlab = "Zaman",
     ylab = "Yabanci Ziyaretçi Sayisi")
forecast_arima$mean
