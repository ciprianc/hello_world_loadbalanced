#!/usr/bin/env python
from flask import Flask

app = Flask("super_simple_app")

@app.route('/')
@app.route('/<message>')
def mainPage(message="write something after / and it'll appear here"):
    """ saaaay something :)

    Arguments:
        message - something to echo back at ya
    """
    return 'Hi there, your message is: <b /> {message} </b>'.format(message=str(message))

if __name__ == '__main__':
    app.run(debug=True, port=8080)
