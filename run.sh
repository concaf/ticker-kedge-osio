set -x
set -e

./kedge apply -f configs/ --namespace $NAMESPACE
oc expose service webdis --namespace $NAMESPACE || true
WEBDIS_HOST="$(oc get route webdis --namespace $NAMESPACE --template={{.spec.host}})"
sh ./wait-for-it.sh $WEBDIS_HOST:80
$WEBDIS_HOST python app.py
