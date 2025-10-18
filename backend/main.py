from flask import Flask, jsonify, request
from werkzeug.datastructures import FileStorage

app = Flask(__name__)


@app.route('/')
def index():
    return jsonify({
        'message': 'Menu Shrinker AI Backend',
        'status': 'running'
    })


@app.route('/health')
def health():
    return jsonify({'status': 'healthy'}), 200


@app.route('/menu_suggestion', methods=['POST'])
def menu_suggestion():
    # Get preferences from form data or JSON
    preferences = request.form.getlist('preferences') if 'preferences' in request.form else request.json.get('preferences', [])

    # Get uploaded menu photos
    menu_photos = request.files.getlist('menu_photos')

    # Validate inputs
    if not preferences:
        return jsonify({'error': 'preferences are required'}), 400

    if not menu_photos:
        return jsonify({'error': 'menu_photos are required'}), 400

    # Process the photos and preferences
    # TODO: Implement AI logic here
    photo_info = [
        {
            'filename': photo.filename,
            'content_type': photo.content_type,
            'size': len(photo.read())
        }
        for photo in menu_photos
    ]

    # Reset file pointers after reading
    for photo in menu_photos:
        photo.seek(0)

    return jsonify({
        'message': 'Menu suggestion endpoint - wip',

    }), 200


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
