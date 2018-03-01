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

    html = "<h3>Hello World!</h3> <br/>" \
           "<h4>Number of hits: {hits}</h4><br/>"

    return html.format(hits=visits)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
