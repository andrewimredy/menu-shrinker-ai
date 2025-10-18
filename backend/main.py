"""
Menu Shrinker AI Backend
A Flask API for analyzing menu photos and suggesting items based on dietary preferences.
"""

from flask import Flask, jsonify, request
from werkzeug.datastructures import FileStorage
import requests
import os
import base64
from PIL import Image
import pytesseract
from io import BytesIO

# ============================================================================
# Configuration
# ============================================================================

app = Flask(__name__)

# Get API key from environment variable
GRADIENT_API_KEY = os.getenv('GRADIENT_API_KEY', 'YOUR_MODEL_ACCESS_KEY')


# ============================================================================
# Utility Functions
# ============================================================================

def extract_text_from_image(image_file):
    """Extract text from an image file using OCR."""
    try:
        # Read image data
        img_data = image_file.read()
        image_file.seek(0)  # Reset file pointer

        # Open image with PIL
        image = Image.open(BytesIO(img_data))

        # Extract text using pytesseract
        text = pytesseract.image_to_string(image)

        print(f"[OCR] Extracted {len(text)} characters from {image_file.filename}")
        return text.strip()
    except Exception as e:
        print(f"[OCR] Error extracting text: {str(e)}")
        return ""


def call_gradient_ai(prompt):
    """Call Gradient AI model with the given prompt."""
    url = "https://inference.do-ai.run/v1/chat/completions"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {GRADIENT_API_KEY}"
    }

    data = {
        "model": "llama3.3-70b-instruct",
        "messages": [
            {
                "role": "user",
                "content": prompt
            }
        ],
        "temperature": 0.7,
        "max_tokens": 500
    }

    print(f"[Gradient AI] Calling API with prompt: {prompt[:100]}...")
    print(f"[Gradient AI] API Key set: {GRADIENT_API_KEY[:10]}..." if GRADIENT_API_KEY != 'YOUR_MODEL_ACCESS_KEY' else "[Gradient AI] WARNING: Using default API key")

    response = requests.post(url, headers=headers, json=data)

    print(f"[Gradient AI] Response status: {response.status_code}")
    print(f"[Gradient AI] Response body: {response.text[:500]}...")

    if response.status_code != 200:
        return {"error": response.text, "status_code": response.status_code}

    try:
        return response.json()
    except:
        return {"error": "Failed to parse response", "raw": response.text}


# ============================================================================
# API Routes
# ============================================================================

@app.route('/')
def index():
    """Health check endpoint."""
    return jsonify({
        'message': 'Menu Shrinker AI Backend',
        'status': 'running',
        'version': '1.0.0'
    })


@app.route('/health')
def health():
    """Health check endpoint."""
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


@app.route('/suggest', methods=['POST'])
def suggest():
    """
    Suggest menu items based on dietary preferences and menu photos.

    Expects:
        - preferences: list of strings (dietary preferences)
        - menu_photos: list of image files

    Returns:
        JSON with AI-generated suggestions
    """
    # Get preferences from form data or JSON
    preferences = request.form.getlist('preferences') if 'preferences' in request.form else request.json.get('preferences', [])

    # Get uploaded menu photos
    menu_photos = request.files.getlist('menu_photos')

    # Validate inputs
    if not preferences:
        return jsonify({'error': 'preferences are required'}), 400

    if not menu_photos:
        return jsonify({'error': 'menu_photos are required'}), 400

    # Extract text from all menu photos using OCR
    print(f"[OCR] Processing {len(menu_photos)} menu photos...")
    menu_texts = []
    for photo in menu_photos:
        text = extract_text_from_image(photo)
        if text:
            menu_texts.append(text)

    if not menu_texts:
        return jsonify({'error': 'Could not extract text from menu photos'}), 400

    # Combine all menu text
    full_menu_text = "\n\n=== MENU ===\n\n".join(menu_texts)

    # Build prompt for AI
    preferences_str = ", ".join(preferences)
    prompt = f"""Here is a restaurant menu:

{full_menu_text}

Based on these dietary preferences: {preferences_str}

Please suggest 3-5 menu items that best match these preferences. For each item, explain why it matches the preferences."""

    # Call Gradient AI
    ai_response = call_gradient_ai(prompt)

    return jsonify({
        'message': 'Menu suggestion generated',
        'preferences': preferences,
        'photos_processed': len(menu_photos),
        'menu_items_found': len(menu_texts),
        'suggestion': ai_response
    }), 200


# ============================================================================
# Main
# ============================================================================

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
