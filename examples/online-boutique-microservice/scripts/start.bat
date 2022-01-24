
rem ----- Only set DEMO_HOME if not already set ----------------------------
:checkDemoHome
rem %~sdp0 is expanded pathname of the current script under NT with spaces in the path removed
if "%DEMO_HOME%"=="" set DEMO_HOME=%~sdp0..

FOR %%service IN (product-catalog-service ad-service recommendation-service) DO (
    cd %DEMO_HOME%/%%service
    test --offline
    cd %DEMO_HOME%
)

kubectl apply -f  %DEMO_HOME%\product-catalog-service\target\kubernetes\productcatalogservice\productcatalogservice.yaml
kubectl apply -f  %DEMO_HOME%\ad-service\target\kubernetes\adservice\adservice.yaml
kubectl apply -f  %DEMO_HOME%\recommendationservice\target\kubernetes\recommendationservice\recommendationservice.yaml

:END
