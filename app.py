from flask import Flask
import urllib2
import os

app = Flask(__name__)
host = os.environ.get('WEBDIS_HOST', 'redis')

@app.route('/')
def hello():
    url = "http://"+host+"/INCR/hits"
    app.logger.info("Now hitting: "+url)
    visits = urllib2.urlopen(url).read()

    html = "<h3>Hello Kubernauts</h3> <br/>" \
           "<h2>Number of Hits:</2> {hits}<br/>"

    return html.format(hits=visits)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
