import os
import json
import time
from dotenv import load_dotenv
import streamlit as st
from groq import Groq

load_dotenv()

GROQ_API_KEY = os.getenv("GROQ_API_KEY")
if not GROQ_API_KEY:
    st.error("GROQ_API_KEY not set in environment variables.")
    st.stop()

client = Groq(api_key=GROQ_API_KEY)

st.set_page_config(page_title="Groq Chat", page_icon="💬", layout="wide")

CHAT_HISTORY_FILE = "chat_history.json"
if os.path.exists(CHAT_HISTORY_FILE):
    with open(CHAT_HISTORY_FILE, "r", encoding="utf-8") as f:
        saved_chats = json.load(f)
else:
    saved_chats = {}

if "messages" not in st.session_state:
    st.session_state.messages = []
if "chat_name" not in st.session_state:
    st.session_state.chat_name = f"Chat-{len(saved_chats) + 1}"

# Sidebar
with st.sidebar:
    st.title("⚙️ Controls")
    # Models - adjust to your valid list
    model_options = [
        "meta-llama/llama-4-maverick-17b-128e-instruct",
        "meta-llama/llama-4-scout-17b-16e-instruct",
        "openai/gpt-oss-20B",
        "openai/gpt-oss-120B"
    ]
    model_choice = st.selectbox("Select Model", model_options, index=0)
    use_web_search = st.checkbox("Enable Web Search")

    if st.button("🆕 New Chat", key="new_chat_btn"):
        # save current if non-empty
        if st.session_state.messages:
            saved_chats[st.session_state.chat_name] = st.session_state.messages
            with open(CHAT_HISTORY_FILE, "w", encoding="utf-8") as f:
                json.dump(saved_chats, f, indent=2)
        st.session_state.messages = []
        st.session_state.chat_name = f"Chat-{len(saved_chats) + 1}"
        # Make sure button key is cleared so state doesn’t persist
        if "new_chat_btn" in st.session_state:
            del st.session_state["new_chat_btn"]
        st.rerun()

    st.markdown("---")
    st.subheader("Saved Chats")
    for name in list(saved_chats.keys()):
        cols = st.columns([0.7, 0.3])
        with cols[0]:
            if st.button(f"📄 {name}", key=f"open_{name}"):
                st.session_state.chat_name = name
                st.session_state.messages = saved_chats[name]
                del st.session_state[f"open_{name}"]
                st.rerun()
        with cols[1]:
            if st.button("🗑️", key=f"del_{name}"):
                saved_chats.pop(name, None)
                # Also delete the file if exists
                with open(CHAT_HISTORY_FILE, "w", encoding="utf-8") as f:
                    json.dump(saved_chats, f, indent=2)
                # If we are deleting the current open chat, reset
                if st.session_state.chat_name == name:
                    st.session_state.messages = []
                    st.session_state.chat_name = f"Chat-{len(saved_chats) + 1}"
                del st.session_state[f"del_{name}"]
                st.rerun()

# CSS for bubbles, minimal UI
st.markdown("""
<style>
body { background-color: #f5f5f5; }
.main {
  background-color: #fff;
  padding: 30px;
  margin: auto;
  max-width: 800px;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.05);
  font-family: "Inter", sans-serif;
}
.user-bubble {
  background-color: #e6f0ff;
  color: #000;
  padding: 12px 16px;
  border-radius: 14px;
  margin: 8px 0;
  max-width: 80%;
  align-self: flex-end;
}
.assistant-bubble {
  background-color: #f3f3f3;
  color: #111;
  padding: 12px 16px;
  border-radius: 14px;
  margin: 8px 0;
  max-width: 80%;
  align-self: flex-start;
}
.chat-container {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 20px;
}
.header {
  text-align: center;
  font-size: 2em;
  color: #3b82f6;
  margin-bottom: 10px;
}
.subtitle {
  text-align: center;
  color: gray;
  margin-bottom: 25px;
}
</style>
""", unsafe_allow_html=True)

st.markdown('<div class="header">Groq Chat</div>', unsafe_allow_html=True)
st.markdown('<div class="subtitle">Chat with AI — streaming, memory, delete sessions</div>', unsafe_allow_html=True)

def perform_web_search_stub(query: str) -> str:
    return f"[Web search for '{query}']\n1. Sample result A\n2. Sample result B"

def stream_groq_response(messages):
    # Not inside try/except that uses rerun, to avoid st.rerun inside except
    resp_iter = None
    try:
        resp_iter = client.chat.completions.create(
            model=model_choice,
            messages=messages,
            stream=True
        )
    except Exception as e:
        err = str(e)
        if "model_not_found" in err or "does not exist" in err:
            st.warning(f"Model `{model_choice}` inaccessible; falling back.")
            fallback = "meta-llama/llama-4-maverick-17b-128e-instruct"
            resp_iter = client.chat.completions.create(
                model=fallback,
                messages=messages,
                stream=True
            )
        else:
            return f"⚠️ Error: {err}"

    full = ""
    placeholder = st.empty()
    for chunk in resp_iter:
        delta = chunk.choices[0].delta.content or ""
        full += delta
        placeholder.markdown(f"<div class='assistant-bubble'>{full}</div>", unsafe_allow_html=True)
        time.sleep(0.01)
    return full.strip()

# Display existing messages
st.markdown('<div class="chat-container">', unsafe_allow_html=True)
for msg in st.session_state.messages:
    if msg["role"] == "user":
        st.markdown(f"<div class='user-bubble'>{msg['content']}</div>", unsafe_allow_html=True)
    else:
        st.markdown(f"<div class='assistant-bubble'>{msg['content']}</div>", unsafe_allow_html=True)
st.markdown('</div>', unsafe_allow_html=True)

# Chat input
if prompt := st.chat_input("Ask me..."):
    st.session_state.messages.append({"role": "user", "content": prompt})

    if use_web_search:
        web_res = perform_web_search_stub(prompt)
        st.session_state.messages.append({"role": "system", "content": web_res})

    with st.spinner("Thinking..."):
        resp = stream_groq_response(st.session_state.messages)
    st.session_state.messages.append({"role": "assistant", "content": resp})

    # Save
    saved_chats[st.session_state.chat_name] = st.session_state.messages
    with open(CHAT_HISTORY_FILE, "w", encoding="utf-8") as f:
        json.dump(saved_chats, f, indent=2)

    st.rerun()

st.markdown('</div>', unsafe_allow_html=True)
