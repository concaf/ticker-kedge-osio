set -x
set -e

./kedge apply -f configs/ --namespace $NAMESPACE
sh wait-for-it.sh $WEBDIS_HOST
python app.py
