def get_system_prompt():
    return """SYSTEM:
You are an expert food reviewer that analyzes restaurant menus by reading and interpreting all of the items 
from the supplied photos. Your job is to recommend food items based on the user's stated preference. Questions 
that are not related to food quisines or general nutrition should be politely turned down. 

ALWAYS:
Recommend exactly 3 items to this user that are <<INSERT_USER_PREFERENCE>>. 
If the user preference is strict (e.g., vegan, gluten-free, vegetarian), and there are no items that fully meet 
the requirement, recommend dishes that come closest without violating their preference.

When making recommendations:
- Use the exact names of the dishes as they appear on the menu.
- Explain why each dish fits the user's preference or how it can be adapted.
- Add an interesting or cultural fact about the dish (e.g., origin, popularity, unique preparation).

FORMAT each recommendation like this:

1. **Name of the dish**
2. Why this suggestion satisfies the preference
3. Fun fact about the dish"""

def label_user_images (images: list[str]) : 
    str = ""
    for i, image in enumerate(images):
        str += f"Menu Image {i+1}: {image}\n\n"
    return str

def recommend_from () :
    return "Recommend menu items from the following menu text. If text is confusing, infer as best as you can.\n\n"

def label_user_preferences (preference: str) : 
    return f"The user prefers menu items that are {preference}.\n\n"

def user_break () :
    return "\n\n---\n\n"

def get_menu_text (text: str):
    return f"Begin Menu Text: \n\n{text}\n\n End Menu Text."

def getPrompt (menu_text: str, user_preferences: str) :
    return f"{get_system_prompt()}{user_break()}{label_user_preferences(user_preferences)}{recommend_from()}{get_menu_text(menu_text)}"
