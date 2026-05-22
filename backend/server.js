const WebSocket = require("ws");

const wss = new WebSocket.Server({ port: 3000 });

let clients = [];

wss.on("connection", (ws) => {
    console.log("User connected");

    clients.push(ws);

    ws.on("message", (message) => {
        console.log("Received:", message.toString());

        // Broadcast to everyone except sender
        clients.forEach(client => {
            if (client !== ws && client.readyState === WebSocket.OPEN) {
                client.send(message.toString());
            }
        });
    });

    ws.on("close", () => {
        console.log("User disconnected");

        clients = clients.filter(client => client !== ws);
    });
});

console.log("WebSocket server running on port 3000");