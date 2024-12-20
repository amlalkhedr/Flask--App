from flask import Flask, render_template, json, request, redirect, session, jsonify
import mysql.connector
import os

app = Flask(__name__)

# Flask will automatically store session data in client-side cookies
# Just ensure a secure secret key is set for signing session cookies
app.secret_key = os.getenv('SECRET_KEY', 'your_default_secret_key')

# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = os.getenv('MYSQL_DATABASE_USER')
app.config['MYSQL_DATABASE_PASSWORD'] = os.getenv('MYSQL_DATABASE_PASSWORD')
app.config['MYSQL_DATABASE_DB'] = os.getenv('MYSQL_DATABASE_DB')
app.config['MYSQL_DATABASE_HOST'] = os.getenv('MYSQL_DATABASE_HOST')

def get_db_connection():
    return mysql.connector.connect(
        user=app.config['MYSQL_DATABASE_USER'],
        password=app.config['MYSQL_DATABASE_PASSWORD'],
        host=app.config['MYSQL_DATABASE_HOST'],
        database=app.config['MYSQL_DATABASE_DB']
    )

@app.route("/")
def main():
    print("Hello from the Flask server console!")
    return render_template('index.html')

@app.route('/showSignUp')
def showSignUp():
    return render_template('signup.html')

@app.route('/signUp', methods=['POST'])
def signUp():
    _name = request.form['inputName']
    _email = request.form['inputEmail']
    _password = request.form['inputPassword']

    if _name and _email and _password:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.callproc('sp_createUser', (_name, _email, _password))
        data = cursor.fetchall()
        print("data")
        if len(data) == 0:
            conn.commit()
            return jsonify({'message': 'User created successfully!'})
        else:
            return jsonify({'error': str(data[0])})
    else:
        return jsonify({'html': '<span>Enter the required fields</span>'})

@app.route('/showSignIn')
def showSignin():
    return render_template('signin.html')

@app.route('/validateLogin', methods=['POST'])
def validateLogin():
    _username = request.form['inputEmail']
    _password = request.form['inputPassword']

    conn = get_db_connection()
    print(conn)
    cursor = conn.cursor(buffered=True)
    
    cursor.execute("SELECT * FROM tbl_user WHERE user_username = %s", (_username,))
    
    data = cursor.fetchone()
    print(data)
    
    if data and data[3] == _password:
        session['user'] = data[0]  # Storing user info in session (client-side cookie)
        return redirect('/userHome')
    else:
        return render_template('error.html', error='Wrong Email address or Password')

@app.route('/userHome')
def userHome():
    if 'user' in session:
        return render_template('userHome.html')
    else:
        return render_template('error.html', error='Unauthorized Access')

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect('/')

@app.route('/showAddWish')
def showAddWish():
    return render_template('addWish.html')

@app.route('/addWish', methods=['POST'])
def addWish():
    if 'user' in session:
        _title = request.form['inputTitle']
        _description = request.form['inputDescription']
        _user = session['user']

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.callproc('sp_addWish', (_title, _description, _user))
        data = cursor.fetchall()

        if len(data) == 0:
            conn.commit()
            return redirect('/userHome')
        else:
            return render_template('error.html', error='An error occurred!')
    else:
        return render_template('error.html', error='Unauthorized Access')

@app.route('/getWish')
def getWish():
    if 'user' in session:
        _user = session['user']

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM tbl_wish WHERE wish_user_id = %s", (_user,))
        wishes = cursor.fetchall()

        wishes_dict = [
            {
                'Id': wish[0],
                'Title': wish[1],
                'Description': wish[2],
                'Date': wish[4]
            } for wish in wishes
        ]

        return jsonify(wishes_dict)
    else:
        return render_template('error.html', error='Unauthorized Access')

@app.route('/editWish/<int:wish_id>', methods=['PUT'])
def editWish(wish_id):
    if 'user' in session:
        data = request.get_json()
        new_title = data.get('Title')
        new_description = data.get('Description')

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("UPDATE tbl_wish SET wish_title = %s, wish_description = %s WHERE wish_id = %s", (new_title, new_description, wish_id))
        conn.commit()

        return jsonify({'message': 'Wish updated successfully!'})
    else:
        return jsonify({'error': 'Unauthorized Access'}), 403

@app.route('/deleteWish/<int:wish_id>', methods=['DELETE'])
def deleteWish(wish_id):
    if 'user' in session:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM tbl_wish WHERE wish_id = %s", (wish_id,))
        conn.commit()

        return jsonify({'message': 'Wish deleted successfully!'})
    else:
        return jsonify({'error': 'Unauthorized Access'}), 403

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002, debug=True)
