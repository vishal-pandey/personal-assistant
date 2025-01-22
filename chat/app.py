import chainlit as cl
import requests
import json
from chainlit.input_widget import TextInput


chatUrl = "http://n8n:5678/webhook/chat"

promptGet = "http://n8n:5678/webhook/get-category-tag-preference"
promptSet = "http://n8n:5678/webhook/category-tag-preference"

@cl.on_chat_start
async def start():

    prompt = requests.get(promptGet)
    prompt = prompt.text

    prompt = json.loads(prompt)
    settings = await cl.ChatSettings(
        [
            TextInput(id="category-and-tag-prompt", label="LLM Prompt for category and tag", initial=prompt[0]["config_value"], multiline=True),
        ]
    ).send()
    value = settings["category-and-tag-prompt"]


# Listen for updates to the settings
@cl.on_settings_update
async def on_settings_update(updated_settings):
    # Get the updated value of category-and-tag-prompt
    updated_prompt = updated_settings["category-and-tag-prompt"]
    data = requests.post(promptSet, data={
        "prompt": updated_prompt
    })

    await cl.Message(content=f"LLM Prompt updated").send()


@cl.on_message
async def main(message: cl.Message):

    loading_message = await cl.Message(content="⏳ Loading, please wait...").send()

    session_id = cl.user_session.get("id")

    data = requests.post(chatUrl, data={
        "chatInput": message.content,
        "sessionId": session_id
    })
    print(data)

    data = data.text
    data = json.loads(data)

    loading_message.content = content=data[0]["output"]
    await loading_message.send()

