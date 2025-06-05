from app import create_app

app = create_app()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

# app.run(host='0.0.0.0', port=5000, debug=True) This makes the app listen on all IPs, not just localhost
