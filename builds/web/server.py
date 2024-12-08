from http import server

class HTTPServer(server.SimpleHTTPRequestHandler):
    def send_headers(self):
        self.send_headers()
        server.SimpleHTTPRequestHandler.send_headers(self)

    def send_my_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")

if __name__ == '__main__':
    server.test(HandlerClass=HTTPServer)
