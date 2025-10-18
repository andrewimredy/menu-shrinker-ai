from flask import Flask, jsonify, request
from werkzeug.datastructures import FileStorage
import requests
import os

app = Flask(__name__)

# Get API key from environment variable
GRADIENT_API_KEY = os.getenv('GRADIENT_API_KEY', 'YOUR_MODEL_ACCESS_KEY')


def call_gradient_ai(prompt):
    """Call Gradient AI model with the given prompt."""
    url = "https://inference.do-ai.run/v1/chat/completions"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {GRADIENT_API_KEY}"
    }
    data = {
        "model": "openai-o3-mini",
        "messages": [
            {
                "role": "user",
                "content": prompt
            }
        ],
        "temperature": 0.7,
        "max_tokens": 100
    }

    print(f"[Gradient AI] Calling API with prompt: {prompt[:100]}...")
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

    # Build prompt for AI
    preferences_str = ", ".join(preferences)
    prompt = f"Based on these dietary preferences: {preferences_str}, suggest menu items from the uploaded menu photos."

    # Call Gradient AI
    ai_response = call_gradient_ai(prompt)

    return jsonify({
        'message': 'Menu suggestion generated',
        'preferences': preferences,
        'photos_received': len(menu_photos),
        'ai_suggestion': ai_response
    }), 200


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
