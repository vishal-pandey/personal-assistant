import chainlit as cl
import requests
import json

chatUrl = "https://n8n.vishalpandey.co.in/webhook/email-chat"




@cl.on_chat_start
async def start():
    image = cl.CustomElement(name="mycomponent1")

    # Attach the image to the message
    await cl.Message(
        content="",
        elements=[image],
    ).send()


@cl.on_message
async def main(message: cl.Message):

    data = requests.post(chatUrl, data={
        "chatInput": message.content,
        "sessionId": "12345"
    })
    print(data)

    data = data.text
    data = json.loads(data)

    await cl.Message(
        content=data[0]["output"],
    ).send()

