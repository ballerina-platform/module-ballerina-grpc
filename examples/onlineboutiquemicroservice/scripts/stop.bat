rem ----- Only set DEMO_HOME if not already set ----------------------------
:checkDemoHome
rem %~sdp0 is expanded pathname of the current script under NT with spaces in the path removed
if "%DEMO_HOME%"=="" set DEMO_HOME=%~sdp0..

kubectl delete -f  %DEMO_HOME%\productcatalogservice\target\kubernetes\productcatalogservice\productcatalogservice.yaml
kubectl delete -f  %DEMO_HOME%\adservice\target\kubernetes\adservice\adservice.yaml
kubectl delete -f  %DEMO_HOME%\recommendationservice\target\kubernetes\recommendationservice\recommendationservice.yaml
