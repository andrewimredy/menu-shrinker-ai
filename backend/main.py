from flask import Flask, jsonify, request
from werkzeug.datastructures import FileStorage
import requests
import os
import base64

app = Flask(__name__)

# Get API key from environment variable
GRADIENT_API_KEY = os.getenv('GRADIENT_API_KEY', 'YOUR_MODEL_ACCESS_KEY')


def call_gradient_ai(prompt, images=None):
    """Call Gradient AI model with the given prompt and optional images."""
    url = "https://inference.do-ai.run/v1/chat/completions"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {GRADIENT_API_KEY}"
    }

    # Build message content with images if provided
    if images:
        content = [{"type": "text", "text": prompt}]
        for img_data in images:
            content.append({
                "type": "image_url",
                "image_url": {
                    "url": f"data:image/jpeg;base64,{img_data}"
                }
            })
        message_content = content
    else:
        message_content = prompt

    data = {
        "model": "gpt-4o-mini",
        "messages": [
            {
                "role": "user",
                "content": message_content
            }
        ],
        "temperature": 0.7,
        "max_tokens": 500
    }

    print(f"[Gradient AI] Calling API with prompt: {prompt[:100]}...")
    print(f"[Gradient AI] Images included: {len(images) if images else 0}")
    print(f"[Gradient AI] API Key set: {GRADIENT_API_KEY[:10]}..." if GRADIENT_API_KEY != 'YOUR_MODEL_ACCESS_KEY' else "[Gradient AI] WARNING: Using default API key")

    response = requests.post(url, headers=headers, json=data)

    print(f"[Gradient AI] Response status: {response.status_code}")
    print(f"[Gradient AI] Response body: {response.text}")

    return response.json()


@app.route('/')
def index():
    return jsonify({
        'message': 'Menu Shrinker AI Backend',
        'status': 'running'
    })


@app.route('/health')
def health():
    return jsonify({'status': 'healthy'}), 200


@app.route('/models', methods=['GET'])
def get_models():
    """Get available models from DigitalOcean Gradient AI."""
    url = "https://inference.do-ai.run/v1/models"
    headers = {
        "Authorization": f"Bearer {GRADIENT_API_KEY}",
        "Content-Type": "application/json"
    }

    response = requests.get(url, headers=headers)
    return jsonify(response.json()), response.status_code


@app.route('/suggest', methods=['POST', 'GET'])
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

    # Encode menu photos as base64
    encoded_images = []
    for photo in menu_photos:
        img_data = photo.read()
        encoded = base64.b64encode(img_data).decode('utf-8')
        encoded_images.append(encoded)
        photo.seek(0)  # Reset file pointer

    # Build prompt for AI
    preferences_str = ", ".join(preferences)
    prompt = f"Analyze these menu photos and suggest items that match these dietary preferences: {preferences_str}. List the recommended dishes and explain why they match."

    # Call Gradient AI with images
    ai_response = call_gradient_ai(prompt, images=encoded_images)

    return jsonify({
        'message': 'Menu suggestion generated',
        'preferences': preferences,
        'photos_received': len(menu_photos),
        'ai_suggestion': ai_response
    }), 200


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
