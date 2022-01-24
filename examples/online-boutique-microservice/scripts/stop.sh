# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '.*/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

# Get standard environment variables
PRGDIR=`dirname "$PRG"`

# Only set DEMO_HOME if not already set
[ -z "$DEMO_HOME" ] && DEMO_HOME=`cd "$PRGDIR/.." ; pwd`

kubectl delete -f  $DEMO_HOME/product-catalog-service/target/kubernetes/productcatalogservice/productcatalogservice.yaml
kubectl delete -f  $DEMO_HOME/recommendation-service/target/kubernetes/recommendationservice/recommendationservice.yaml
kubectl delete -f  $DEMO_HOME/ad-service/target/kubernetes/adservice/adservice.yaml
