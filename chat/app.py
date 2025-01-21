import chainlit as cl
import requests
import json

chatUrl = "http://n8n:5678/webhook/chat"

@cl.on_chat_start
async def start():
    image = cl.CustomElement(name="mycomponent1")

    # Attach the image to the message
    # await cl.Message(
    #     content="",
    #     elements=[image],
    # ).send()


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

