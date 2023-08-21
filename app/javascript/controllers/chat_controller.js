import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["message"];

  connect() {
    console.log("from chat")
    this.formElement = this.element.querySelector("#chat-form");
    this.messageInput = this.messageTarget;
    this.chatHistory = this.element.querySelector("#chat-history");

    if (this.formElement) {
      this.formElement.addEventListener("submit", this.sendMessage.bind(this));
    }
  }

  async sendMessage(event) {
    event.preventDefault();

    const message = this.messageInput.value.trim();
    if (!message) return;

    try {
      const response = await fetch("/chats", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Requested-With": "XMLHttpRequest",
        },
        body: JSON.stringify({ chat: { message } }),
      });

      if (!response.ok) {
        throw new Error("Failed to create a chat entry.");
      }

      const { chat } = await response.json();

      // Now we manually construct the chat entry using the provided HTML structure
      const chatEntry = document.createElement("div");
      chatEntry.classList.add("chat-entry");
      chatEntry.innerHTML = `
        <p><strong>Message:</strong> ${chat.message}</p>
        <p><strong>Response:</strong> ${chat.response}</p>
        <p><strong>Created At:</strong> ${chat.created_at}</p>
      `;

      // Append the chat entry to the chat history container
      this.chatHistory.appendChild(chatEntry);

      // Reset the form input
      this.formElement.reset();
    } catch (error) {
      console.error("Error:", error);
      alert("Failed to create a chat entry.");
    }
  }
}
