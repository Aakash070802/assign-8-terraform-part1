from flask import Flask, request, jsonify, render_template

app = Flask(__name__)

@app.route('/')
def root():
    return 'Flask Server is running!!'

@app.route('/submit', methods=['POST'])
def submit():
    name = request.form.get('name')
    email = request.form.get('email')
    phone = request.form.get('phone')
    city = request.form.get('city')
    message = request.form.get('message')

    return jsonify({
        "status": "success",
        "name": name,
        "email": email,
        "phone": phone,
        "city": city,
        "message": message
    })
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
